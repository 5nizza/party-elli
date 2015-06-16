import logging
from helpers.console_helpers import print_red, print_green

from helpers.logging_helper import log_entrance
from interfaces.automata import Automaton
from interfaces.lts import LTS
from interfaces.parser_expr import Signal
from interfaces.solver_interface import SolverInterface
from synthesis.full_info_encoder import FullInfoEncoder
from synthesis.func_description import FuncDescription
from synthesis.funcs_args_types_names import FUNC_MODEL_TRANS, \
    TYPE_MODEL_STATE, ARG_MODEL_STATE, ARG_S_a_STATE, TYPE_S_a_STATE, TYPE_S_g_STATE, TYPE_L_a_STATE, TYPE_L_g_STATE, \
    ARG_L_g_STATE, ARG_L_a_STATE, ARG_S_g_STATE, smt_arg_name_signal


@log_entrance(logging.getLogger(), logging.INFO)
def search(sizes, encoder) -> LTS:
    logger = logging.getLogger()

    for size in sizes:
        logger.info('searching a model of size {0}..'.format(size))

        cur_all_states = range(size)

        encoder.push()

        encoder.encode_headers(cur_all_states)
        encoder.encode_initialization()
        encoder.encode_run_graph(cur_all_states)
        # encoding_solver.encode_model_bound(cur_all_states)

        model = encoder.solve()
        if model:
            return model

        encoder.pop()

    return None

