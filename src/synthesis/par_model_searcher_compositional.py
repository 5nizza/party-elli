import logging

from helpers.logging import log_entrance
from interfaces.automata import to_dot
from synthesis.generic_smt_encoder import GenericEncoder
from synthesis.local_en_process_impl import LocalENImpl
from synthesis.par_impl import ParImpl
from synthesis.smt_logic import UFLIA
from synthesis.solitary_impl import SolitaryImpl
from synthesis.z3 import Z3


@log_entrance(logging.getLogger(), logging.INFO)
def search(local_automaton,
           global_automaton, inputs, outputs,
                        nof_processes,
                        local_bounds,
                        z3solver,
                        sched_id_prefix,
                        active_var_prefix,
                        sends_var_prefix,
                        has_tok_var_prefix,
                        sends_prev_var_name):
    logger = logging.getLogger()
#    logger.debug('local_automaton\n%s', local_automaton)
#    logger.debug('local_automaton\n%s', to_dot(local_automaton))
#    logger.debug('global_automaton\n%s', local_automaton)
#    logger.debug('global_automaton\n%s', to_dot(local_automaton))

    for bound in local_bounds:
#        logger.info('searching a model of size {0}..'.format(bound))

        global_encoder = GenericEncoder(UFLIA(), 'GQ', 'g')

        sys_state_type = 'LT'
        impl = ParImpl(global_automaton, inputs, outputs, nof_processes, bound,
            sched_id_prefix, active_var_prefix, sends_var_prefix, has_tok_var_prefix,
            sys_state_type)

        global_query_lines = global_encoder.encode_headers()
        global_query_lines += global_encoder.encode_sys_functions(impl)
        global_query_lines += global_encoder.encode_automaton(impl)

#        logger.debug('---- global automaton query\n%s', '\n'.join(global_query_lines))

        if local_automaton:
            local_impl = LocalENImpl(local_automaton, inputs, outputs, bound, sys_state_type,
                has_tok_var_prefix, sends_var_prefix, sends_prev_var_name, impl.init_state[0])
            local_encoder = GenericEncoder(UFLIA(), 'LQ', 'l')
            local_query_lines = local_encoder.encode_automaton(local_impl)
            global_query_lines += local_query_lines

#            logger.debug('---- local automaton query\n%s', '\n'.join(local_query_lines))

        global_query_lines += global_encoder.encode_footings(impl)

        smt_query = '\n'.join(global_query_lines)
        logger.debug(smt_query)

        status, data = z3solver.solve(smt_query)

        if status == Z3.SAT:
            return global_encoder.parse_model(data, impl)

        return None
