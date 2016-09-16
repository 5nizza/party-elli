from interfaces.expr import Signal
from interfaces.func_description import FuncDesc
from synthesis.funcs_args_types_names import ARG_MODEL_STATE, TYPE_MODEL_STATE, smt_arg_name_signal, FUNC_MODEL_TRANS
from synthesis.smt_encoder import SMTEncoder
from synthesis.smt_logic import UFLRA


def _get_tau_desc(inputs):
    arg_types_dict = dict()
    arg_types_dict[ARG_MODEL_STATE] = TYPE_MODEL_STATE

    for s in inputs:
        arg_types_dict[smt_arg_name_signal(s)] = 'Bool'

    tau_desc = FuncDesc(FUNC_MODEL_TRANS, arg_types_dict, TYPE_MODEL_STATE, None)
    return tau_desc


def _get_output_desc(output:Signal, is_moore, inputs):
    arg_types_dict = dict()
    arg_types_dict[ARG_MODEL_STATE] = TYPE_MODEL_STATE

    if not is_moore:
        for s in inputs:
            arg_types_dict[smt_arg_name_signal(s)] = 'Bool'

    return FuncDesc(output.name, arg_types_dict, 'Bool', None)


def create_encoder(input_signals, output_signals,
                   is_moore,
                   automaton,
                   smt_solver,
                   logic=UFLRA()):  # TODO: some mess with logic (two places: in solver and here)
    tau_desc = _get_tau_desc(input_signals)

    desc_by_output = dict((o, _get_output_desc(o, is_moore, input_signals))
                          for o in output_signals)

    encoder = SMTEncoder(logic,
                         automaton,
                         smt_solver,
                         tau_desc,
                         input_signals, desc_by_output)
    return encoder
