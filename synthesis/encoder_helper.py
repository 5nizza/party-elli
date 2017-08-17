from itertools import chain, product
from typing import Iterable, List, Dict, Tuple, Container

from helpers.python_ext import lmap
from helpers.str_utils import remove_from_str
from interfaces.LTS import LTS
from interfaces.automaton import Label
from interfaces.expr import Signal
from interfaces.func_description import FuncDesc
from interfaces.labels_map import LabelsMap
from synthesis.smt_format import get_args_dict, bool_type, true, false, call_func, get_value, comment, forall, \
    assertion, op_or, op_eq, op_not, op_and
from synthesis.smt_namings import ARG_MODEL_STATE, smt_unname_if_signal, TYPE_MODEL_STATE, smt_unname_m, smt_name_m, \
    smt_name_free_arg, smt_arg_name_signal


def parse_model(smt_get_value_lines:Iterable[str],
                tau_desc, descr_by_output,
                inputs,
                model_init_state:int) -> LTS:
    all_signals = set(chain(inputs, descr_by_output.keys()))
    output_models = dict()
    for output_sig, output_desc in descr_by_output.items():
        output_func_model = _build_func_model_from_smt(smt_get_value_lines,
                                                       output_desc,
                                                       all_signals)

        output_models[output_sig] = LabelsMap(output_func_model)

    tau_model = LabelsMap(_build_func_model_from_smt(smt_get_value_lines, tau_desc, all_signals))

    lts = LTS([model_init_state],
              output_models, tau_model,
              ARG_MODEL_STATE,
              inputs, list(descr_by_output.keys()))

    return lts


def _build_func_model_from_smt(get_value_lines:Iterable[str],
                               func_desc:FuncDesc,
                               all_signals:Iterable[Signal]) -> dict:
    """
    Return graph for the transition (or output) function: {label:output}.
    For label's keys are used:
    - for inputs/outputs: original signals
    - for LTS states: ARG_MODEL_STATE
    """
    all_signals = set(all_signals)
    model = {}

    for l in get_value_lines:
        #            (get-value ((tau t0 true true)))
        l = remove_from_str(l, ['get-value', '(', ')'])
        tokens = l.split()

        func_name = tokens[0]
        arg_values_raw = tokens[1:-1]
        return_value_raw = tokens[-1]

        if func_name != func_desc.name:
            continue

        smt_args = get_args_dict(func_desc, arg_values_raw)

        args_label = Label(dict((smt_unname_if_signal(var, all_signals), _parse_value(val))
                                for var, val in smt_args.items()))

        if func_desc.output_ty == TYPE_MODEL_STATE:
            return_value_raw = smt_unname_m(return_value_raw)
        else:
            assert func_desc.output_ty == bool_type(), func_desc.output_ty
            return_value_raw = (return_value_raw == true())

        model[args_label] = return_value_raw

    return model


def _parse_value(val:str) -> bool or int:
    if val in (false(), true()):
        return val == true()
    return smt_unname_m(val)


def encode_get_model_values(tau_desc:FuncDesc,
                            descr_by_output:Dict[Signal, FuncDesc],
                            last_allowed_states:Iterable[int]) -> List[str]:
    func_descs = [tau_desc] + list(descr_by_output.values())
    res = []

    for func_desc in func_descs:
        for input_dict in _get_all_possible_inputs(func_desc, last_allowed_states):
            res.append(get_value(call_func(func_desc, input_dict)))
    return res


def _get_all_possible_inputs(func_desc:FuncDesc, last_allowed_states):
    arg_type_pairs = func_desc.ordered_argname_type_pairs

    get_values = lambda t: {     bool_type(): (true(), false()),
                                 TYPE_MODEL_STATE: [smt_name_m(m) for m in last_allowed_states],
                                 }[t]

    records = product(*[get_values(t) for (_,t) in arg_type_pairs])

    args = lmap(lambda a_t: a_t[0], arg_type_pairs)

    dicts = []
    for record in records:
        assert len(args) == len(record)

        arg_value_pairs = zip(args, record)
        dicts.append(dict(arg_value_pairs))

    return dicts


def encode_model_bound(allowed_model_states:Iterable[int], tau_desc:FuncDesc) -> List[str]:
    res = [comment('encoding model bound: ' + str(allowed_model_states))]

    # all args of tau function are quantified
    args_dict = dict((a, smt_name_free_arg(a))
                     for (a,ty) in tau_desc.ordered_argname_type_pairs)

    free_vars = [(args_dict[a],ty)
                 for (a,ty) in tau_desc.ordered_argname_type_pairs]

    smt_m_next = call_func(tau_desc, args_dict)

    disjuncts = []
    for allowed_m in iter(allowed_model_states):
        disjuncts.append(op_eq(smt_m_next,
                               smt_name_m(allowed_m)))

    condition = forall(free_vars, op_or(disjuncts))
    res.append(assertion(condition))

    return res


def build_inputs_values(inputs:Iterable[Signal],
                        label:Label) \
        -> Tuple[Dict[str,str], List[str]]:
    value_by_signal = dict()
    free_values = []

    for s in inputs:  # type: Signal
        if s in label:
            value_by_signal[smt_arg_name_signal(s)] = str(label[s]).lower()
        else:
            value = '?{0}'.format(str(s)).lower()  # FIXME: hack: we str(signal)
            value_by_signal[smt_arg_name_signal(s)] = value
            free_values.append(value)

    return value_by_signal, free_values


def build_tau_args_dict(inputs:Iterable[Signal], smt_m:str, i_o:Label) -> Dict[str, str]:
    args_dict = dict()
    args_dict[ARG_MODEL_STATE] = smt_m

    smt_label_args, _ = build_inputs_values(inputs, i_o)
    args_dict.update(smt_label_args)
    return args_dict


def smt_out(smt_m:str,
            i_o:Label,
            inputs:Iterable[Signal],
            descr_by_output:Dict[Signal, FuncDesc]) -> str:
    args_dict = build_tau_args_dict(inputs, smt_m, i_o)
    conjuncts = []
    for sig, val in i_o.items():
        out_desc = descr_by_output.get(sig)
        if out_desc is None:
            continue

        condition_on_out = call_func(out_desc, args_dict)
        if val is False:
            condition_on_out = op_not(condition_on_out)
        conjuncts.append(condition_on_out)

    return op_and(conjuncts)


def get_free_input_args(i_o:Label, inputs:Iterable[Signal]):
    _, free_args = build_inputs_values(inputs, i_o)
    return free_args
