import logging

from helpers.logging_helper import log_entrance
from interfaces.automata import Automaton
from interfaces.lts import LTS
from interfaces.expr import Signal
from interfaces.solver_interface import SolverInterface
from synthesis.func_description import FuncDescription
from synthesis.funcs_args_types_names import FUNC_MODEL_TRANS, \
    TYPE_MODEL_STATE, ARG_MODEL_STATE, smt_arg_name_signal
from synthesis.smt_encoder import SMTEncoder


def _get_output_desc(output:Signal, is_mealy, inputs):
    arg_types_dict = dict()
    arg_types_dict[ARG_MODEL_STATE] = TYPE_MODEL_STATE

    if is_mealy:
        for s in inputs:
            arg_types_dict[smt_arg_name_signal(s)] = 'Bool'

    return FuncDescription(output.name, arg_types_dict, 'Bool', None)


def _get_tau_desc(inputs):
    arg_types_dict = dict()
    arg_types_dict[ARG_MODEL_STATE] = TYPE_MODEL_STATE

    for s in inputs:
        arg_types_dict[smt_arg_name_signal(s)] = 'Bool'

    tau_desc = FuncDescription(FUNC_MODEL_TRANS, arg_types_dict, TYPE_MODEL_STATE, None)
    return tau_desc


@log_entrance(logging.getLogger(), logging.INFO)
def search(automaton:Automaton,
           is_mealy,
           input_signals, output_signals,
           sizes,
           underlying_solver:SolverInterface, logic) -> LTS:
    logger = logging.getLogger()

    outputs_descs = dict((o,_get_output_desc(o, is_mealy, input_signals))
                         for o in output_signals)
    tau_desc = _get_tau_desc(input_signals)

    encoding_solver = SMTEncoder(logic,
                                      automaton,
                                      underlying_solver,
                                      tau_desc,
                                      input_signals,
                                      outputs_descs,
                                      0)

    max_model_states = list(range(sizes[-1]))
    encoding_solver.encode_headers(max_model_states)

    encoding_solver.encode_initialization()

    last_size = 0
    for size in sizes:
        logger.info('searching a model of size {0}..'.format(size))

        cur_all_states = range(size)
        new_states = cur_all_states[last_size:]
        last_size = size

        encoding_solver.encode_run_graph(new_states)

        encoding_solver.push()

        encoding_solver.encode_model_bound(cur_all_states)

        model = encoding_solver.solve()
        if model:
            return model

        encoding_solver.pop()

    return None

