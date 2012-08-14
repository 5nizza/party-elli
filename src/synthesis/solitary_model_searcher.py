import logging
from helpers.logging import log_entrance
from interfaces.automata import to_dot
from synthesis.generic_smt_encoder import GenericEncoder
from synthesis.smt_logic import UFLIA
from synthesis.solitary_impl import SolitaryImpl
from synthesis.z3 import Z3


@log_entrance(logging.getLogger(), logging.INFO)
def search(automaton, inputs, outputs, bounds, z3solver, logic):
    logger = logging.getLogger()

    logger.debug(automaton)
    logger.debug(to_dot(automaton))

    for bound in bounds:
        logger.info('searching a model of size {0}..'.format(bound))

        encoder = GenericEncoder(UFLIA())
        impl = SolitaryImpl(automaton, inputs, outputs, bound)
        smt_lines = encoder.encode(impl)

        smt_query = '\n'.join(smt_lines)
        logger.debug(smt_query)

        status, data = z3solver.solve(smt_query)

        if status == Z3.SAT:
            return encoder.parse_model(data, impl)

        return None