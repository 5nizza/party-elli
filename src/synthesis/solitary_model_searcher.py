import logging

from helpers.logging_helper import log_entrance
from helpers.automata_helper import to_dot
from interfaces.automata import Automaton
from interfaces.solver_interface import SolverInterface
from synthesis.generic_smt_encoder import GenericEncoder
from synthesis.solitary_impl import SolitaryImpl


@log_entrance(logging.getLogger(), logging.INFO)
def search(automaton:Automaton,
           is_mealy:bool,
           input_signals, output_signals,
           sizes,
           underlying_solver:SolverInterface,
           logic):
    logger = logging.getLogger()

    logger.debug(automaton)
    logger.debug('search: automaton (dot) is:\n' + to_dot(automaton))

    spec_states_type = 'Q'
    sys_states_type = 'T'

    impl = SolitaryImpl(automaton, is_mealy, input_signals, output_signals, list(sizes)[-1], sys_states_type,
                        underlying_solver)

    encoding_solver = GenericEncoder(logic, spec_states_type, '', impl.state_types_by_process, underlying_solver)

    encoding_solver.encode_sys_model_functions(impl)  # TODO: emulator cannot advantage of knowing the current bound?
    encoding_solver.encode_sys_aux_functions(impl)
    encoding_solver.encode_run_graph_headers(impl)

    #: :type: EncodingSolver
    encoding_solver = encoding_solver
    last_size = 0
    for size in sizes:
        logger.info('searching a model of size {0}..'.format(size))

        cur_all_states = impl.states_by_process[0][:size]
        new_states = cur_all_states[last_size:]
        last_size = size

        encoding_solver.encode_run_graph(impl, list((s,) for s in new_states))

        encoding_solver.push()

        encoding_solver.encode_model_bound(cur_all_states, impl)

        model = encoding_solver.solve(impl)
        if model:
            return model

        encoding_solver.pop()

    return None