import logging

from helpers.logging import log_entrance
from interfaces.automata import to_dot
from synthesis.smt_logic import UFLIA
from synthesis.par_smt_encoder import ParEncoder
from synthesis.z3 import Z3


@log_entrance(logging.getLogger(), logging.INFO)
def search(automaton, inputs, outputs,
                        nof_processes,
                        local_bounds,
                        z3solver,
                        sched_id_prefix,
                        active_var_prefix,
                        sends_var_prefix):
    logger = logging.getLogger()

    logger.debug(automaton)
    logger.debug(to_dot(automaton))

    for bound in local_bounds:
        logger.info('searching a model of size {0}..'.format(bound))
        encoder = ParEncoder(UFLIA(), nof_processes,
            sched_id_prefix, active_var_prefix, sends_var_prefix,
            automaton, inputs, outputs)

        smt_query = encoder.encode_parametrized(bound)
        logger.debug(smt_query)

        status, data = z3solver.solve(smt_query)

        if status == Z3.SAT:
            return encoder.parse_model(data)

        return None