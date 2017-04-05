from itertools import product, chain
from typing import Iterable, Dict, List

from helpers.automata_classifier import is_absorbing
from helpers.logging_helper import log_entrance
from helpers.python_ext import lmap
from helpers.str_utils import remove_from_str
from interfaces.LTS import LTS
from interfaces.automata import Label, Automaton, Node
from interfaces.expr import Signal
from interfaces.func_description import FuncDesc
from interfaces.labels_map import LabelsMap
from synthesis.final_sccs_finder import build_state_to_final_scc
from synthesis.smt_format import op_and, call_func, op_implies, forall_bool, op_not, assertion, comment, forall, op_eq, \
    op_or, declare_enum, declare_fun, op_ge, op_gt, get_args_dict, get_value, false, true, bool_type
from synthesis.smt_namings import TYPE_MODEL_STATE, ARG_MODEL_STATE, FUNC_REACH, FUNC_R, \
    smt_name_q, smt_name_m, smt_name_free_arg, smt_arg_name_signal, smt_unname_if_signal, smt_unname_m, \
    ARG_A_STATE, TYPE_A_STATE


def _build_signals_values(signals:Iterable[Signal], label:Label) -> (dict, list):
    value_by_signal = dict()
    free_values = []

    for s in signals:
        if s in label:
            value_by_signal[smt_arg_name_signal(s)] = str(label[s]).lower()
        else:
            value = '?{0}'.format(str(s)).lower()  # TODO: hack: we str(signal)
            value_by_signal[smt_arg_name_signal(s)] = value
            free_values.append(value)

    return value_by_signal, free_values


class CoBuchiEncoder:
    def __init__(self,
                 automaton:Automaton,
                 tau_desc:FuncDesc,
                 inputs:Iterable[Signal],
                 descr_by_output:Dict[Signal,FuncDesc],
                 model_init_state:int=0):  # the automata alphabet is inputs+outputs
        self.automaton = automaton

        self.inputs = inputs                    # type: Iterable[Signal]
        self.descr_by_output = descr_by_output  # type: Dict[Signal,FuncDesc]
        self.tau_desc = tau_desc                # type: FuncDesc

        reach_args_sig = {ARG_A_STATE: TYPE_A_STATE,
                      ARG_MODEL_STATE: TYPE_MODEL_STATE}

        rank_args = reach_args_sig

        self.reach_func_desc = FuncDesc(FUNC_REACH, reach_args_sig, 'Bool')
        self.rank_func_desc = FuncDesc(FUNC_R, rank_args, 'Real')

        self.model_init_state = model_init_state  # type: int
        self.last_allowed_states = None           # type: range

    def _smt_out(self, smt_m:str, i_o:Label) -> str:
        args_dict = self._build_tau_args_dict(smt_m, i_o)
        conjuncts = []
        for sig, val in i_o.items():
            out_desc = self.descr_by_output.get(sig)
            if out_desc is None:
                continue

            condition_on_out = call_func(out_desc, args_dict)
            if val is False:
                condition_on_out = op_not(condition_on_out)
            conjuncts.append(condition_on_out)

        return op_and(conjuncts)

    def _get_free_input_args(self, i_o:Label):
        _, free_args = _build_signals_values(self.inputs, i_o)
        return free_args

    def _build_tau_args_dict(self, smt_m:str, i_o:Label) -> Dict[str, str]:
        args_dict = dict()
        args_dict[ARG_MODEL_STATE] = smt_m

        smt_label_args, _ = _build_signals_values(self.inputs, i_o)
        args_dict.update(smt_label_args)
        return args_dict

    def encode_headers(self, model_states:Iterable[int]) -> List[str]:
        return self._encode_automata_functions() + \
               self._encode_model_functions(model_states) + \
               self._encode_counters()

    def _encode_model_functions(self, model_states:Iterable[int]) -> List[str]:
        return [declare_enum(TYPE_MODEL_STATE, map(smt_name_m, model_states))] + \
               [declare_fun(self.tau_desc)] + \
               [declare_fun(d) for d in self.descr_by_output.values()]

    def _encode_automata_functions(self) -> List[str]:
        return [declare_enum(TYPE_A_STATE, map(smt_name_q, self.automaton.nodes))]

    def _encode_counters(self) -> List[str]:
        return [declare_fun(self.reach_func_desc),
                declare_fun(self.rank_func_desc)]

    def encode_initialization(self) -> List[str]:
        assertions = []
        for q, m in product(self.automaton.init_nodes, [self.model_init_state]):
            vals_by_vars = {ARG_MODEL_STATE:smt_name_m(m), ARG_A_STATE:smt_name_q(q)}
            assertions.append(
                assertion(call_func(self.reach_func_desc, vals_by_vars))
            )
        return assertions

    def encode_run_graph(self, states_to_encode) -> List[str]:
        state_to_rejecting_scc = build_state_to_final_scc(self.automaton)

        res = []
        for q in self.automaton.nodes:
            for m in states_to_encode:
                for label in q.transitions:
                    res.extend(self._encode_transitions(q, m, label, state_to_rejecting_scc))
            res.append(comment('encoded spec state ' + smt_name_q(q)))
        return res

    def _get_greater_op(self, q, is_rejecting,
                        q_next,
                        state_to_rejecting_scc):
        crt_rejecting_scc = state_to_rejecting_scc.get(q, None)
        next_rejecting_scc = state_to_rejecting_scc.get(q_next, None)

        if crt_rejecting_scc is not next_rejecting_scc:
            return None
        if crt_rejecting_scc is None:
            return None
        if next_rejecting_scc is None:
            return None

        return (op_ge, op_gt)[is_rejecting]

    def _encode_transitions(self,
                            q:Node,
                            m:int,
                            i_o:Label,
                            state_to_final_scc:dict=None) -> List[str]:
        # syntax sugar
        def smt_r(smt_m:str, smt_q:str):
            return call_func(self.rank_func_desc,
                             {ARG_MODEL_STATE:smt_m, ARG_A_STATE:smt_q})

        def smt_reach(smt_m:str, smt_q:str):
            return call_func(self.reach_func_desc,
                             {ARG_MODEL_STATE:smt_m, ARG_A_STATE:smt_q})

        def smt_tau(smt_m:str, i_o:Label):
            tau_args = self._build_tau_args_dict(smt_m, i_o)
            return call_func(self.tau_desc, tau_args)
        #

        smt_m, smt_q = smt_name_m(m), smt_name_q(q)
        smt_m_next = smt_tau(smt_m, i_o)

        smt_pre = op_and([smt_reach(smt_m, smt_q),
                          self._smt_out(smt_m, i_o)])

        smt_post_conjuncts = []
        for q_next, is_fin in q.transitions[i_o]:
            if is_absorbing(q_next):
                smt_post_conjuncts = [false()]
                break

            smt_q_next = smt_name_q(q_next)

            smt_post_conjuncts.append(smt_reach(smt_m_next, smt_q_next))

            greater_op = self._get_greater_op(q, is_fin, q_next, state_to_final_scc)
            if greater_op is not None:
                smt_post_conjuncts.append(greater_op(smt_r(smt_m_next, smt_q_next),
                                                     smt_r(smt_m, smt_q)))

        smt_post = op_and(smt_post_conjuncts)
        pre_implies_post = op_implies(smt_pre, smt_post)
        free_input_args = self._get_free_input_args(i_o)

        return [assertion(forall_bool(free_input_args, pre_implies_post))]

    def encode_model_bound(self, allowed_model_states:range) -> List[str]:
        res = [comment('encoding model bound: ' + str(allowed_model_states))]

        # all args of tau function are quantified
        args_dict = dict((a, smt_name_free_arg(a))
                         for (a,ty) in self.tau_desc.ordered_argname_type_pairs)

        free_vars = [(args_dict[a],ty)
                     for (a,ty) in self.tau_desc.ordered_argname_type_pairs]

        smt_m_next = call_func(self.tau_desc, args_dict)

        disjuncts = []
        for allowed_m in allowed_model_states:
            disjuncts.append(op_eq(smt_m_next,
                                   smt_name_m(allowed_m)))

        condition = forall(free_vars, op_or(disjuncts))
        res.append(assertion(condition))

        self.last_allowed_states = allowed_model_states
        return res

    def encode_get_model_values(self) -> List[str]:
        func_descs = [self.tau_desc] + list(self.descr_by_output.values())
        res = []

        for func_desc in func_descs:
            for input_dict in self._get_all_possible_inputs(func_desc):
                res.append(get_value(call_func(func_desc, input_dict)))
        return res

    def _get_all_possible_inputs(self, func_desc:FuncDesc):
        arg_type_pairs = func_desc.ordered_argname_type_pairs

        get_values = lambda t: {     bool_type(): (true(), false()),
                                TYPE_MODEL_STATE: [smt_name_m(m) for m in self.last_allowed_states],
                                    TYPE_A_STATE: [smt_name_q(s) for s in self.automaton.nodes]
                               }[t]

        records = product(*[get_values(t) for (_,t) in arg_type_pairs])

        args = lmap(lambda a_t: a_t[0], arg_type_pairs)

        dicts = []
        for record in records:
            assert len(args) == len(record)

            arg_value_pairs = zip(args, record)
            dicts.append(dict(arg_value_pairs))

        return dicts

    @log_entrance()
    def parse_model(self, smt_get_value_lines) -> LTS:
        output_models = dict()
        for output_sig, output_desc in self.descr_by_output.items():
            output_func_model = self._build_func_model_from_smt(smt_get_value_lines, output_desc)
            output_models[output_sig] = LabelsMap(output_func_model)

        tau_model = LabelsMap(self._build_func_model_from_smt(smt_get_value_lines, self.tau_desc))

        lts = LTS([self.model_init_state],
                  output_models, tau_model,
                  ARG_MODEL_STATE,
                  self.inputs, list(self.descr_by_output.keys()))

        return lts

    def _build_func_model_from_smt(self, get_value_lines, func_desc:FuncDesc) -> dict:
        """
        Return graph for the transition (or output) function: {label:output}.
        For label's keys are used:
        - for inputs/outputs: original signals
        - for LTS states: ARG_MODEL_STATE
        """
        model = {}
        signals = set(chain(self.inputs, self.descr_by_output.keys()))

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

            args_label = Label(dict((smt_unname_if_signal(var, signals), self._parse_value(val))
                                    for var, val in smt_args.items()))

            if func_desc.output_ty == TYPE_MODEL_STATE:
                return_value_raw = smt_unname_m(return_value_raw)
            else:
                assert func_desc.output_ty == bool_type(), func_desc.output_ty
                return_value_raw = (return_value_raw == true())

            model[args_label] = return_value_raw

        return model

    def _parse_value(self, val:str) -> bool or int:
        if not hasattr(self, 'node_by_smt_value'):  # aka static method of the field
            self.node_by_smt_value = dict()
            self.node_by_smt_value.update((smt_name_q(q), q)
                                          for q in self.automaton.nodes)

        if val in self.node_by_smt_value:
            return self.node_by_smt_value[val]
        if val in (false(), true()):
            return val == 'true'
        return smt_unname_m(val)
