import logging

from helpers.logging import log_entrance
from interfaces.automata import to_dot
from synthesis.generic_smt_encoder import GenericEncoder
from synthesis.par_impl import ParImpl
from synthesis.smt_logic import UFLIA
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

        impl = ParImpl(automaton, inputs, outputs, nof_processes, bound, sched_id_prefix, active_var_prefix, sends_var_prefix)
        encoder = GenericEncoder(UFLIA())
        smt_query = encoder.encode(impl)
        logger.debug(smt_query)

        status, data = z3solver.solve(smt_query)

        if status == Z3.SAT:
            return encoder.parse_model(data, impl)

        return None