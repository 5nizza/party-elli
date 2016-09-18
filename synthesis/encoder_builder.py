from typing import Iterable, Dict

from interfaces.automata import Automaton
from interfaces.expr import Signal
from interfaces.func_description import FuncDesc
from interfaces.solver_interface import SolverInterface
from synthesis.funcs_args_types_names import ARG_MODEL_STATE, TYPE_MODEL_STATE, smt_arg_name_signal, FUNC_MODEL_TRANS
from synthesis.encoder import Encoder
from synthesis.smt_logic import UFLRA


def build_tau_desc(inputs:Iterable[Signal]):
    arg_types_dict = dict()
    arg_types_dict[ARG_MODEL_STATE] = TYPE_MODEL_STATE

    for s in inputs:
        arg_types_dict[smt_arg_name_signal(s)] = 'Bool'

    tau_desc = FuncDesc(FUNC_MODEL_TRANS, arg_types_dict, TYPE_MODEL_STATE, None)
    return tau_desc


def build_output_desc(output:Signal, is_moore, inputs:Iterable[Signal]) -> FuncDesc:
    arg_types_dict = dict()
    arg_types_dict[ARG_MODEL_STATE] = TYPE_MODEL_STATE

    if not is_moore:
        for s in inputs:
            arg_types_dict[smt_arg_name_signal(s)] = 'Bool'

    return FuncDesc(output.name, arg_types_dict, 'Bool', None)


# TODO: remove this function -- use the above functions only
def create_encoder(input_signals:Iterable[Signal],
                   output_signals:Iterable[Signal],
                   is_moore:bool,
                   automaton:Automaton,
                   smt_solver:SolverInterface,
                   logic=UFLRA()):  # FIXME: mess with logic (two places: in solver and here)
    tau_desc = build_tau_desc(input_signals)

    desc_by_output = dict((o, build_output_desc(o, is_moore, input_signals))
                          for o in output_signals)

    encoder = Encoder(logic,
                      automaton,
                      smt_solver,
                      tau_desc,
                      input_signals, desc_by_output)
    return encoder
