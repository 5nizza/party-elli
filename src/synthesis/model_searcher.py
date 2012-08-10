import logging
from helpers.logging import log_entrance
from interfaces.automata import to_dot
from synthesis.smt_encoder import Encoder
from synthesis.smt_logic import UFLIA
from synthesis.z3 import Z3


@log_entrance(logging.getLogger(), logging.INFO)
def search(automaton, inputs, outputs, bounds, z3solver, logic):
    logger = logging.getLogger()

    logger.debug(automaton)
    logger.debug(to_dot(automaton))

    for bound in bounds:
        logger.info('searching a model of size {0}..'.format(bound))
        encoder = Encoder(UFLIA(), automaton, inputs, outputs)

        smt_query = encoder.encode(bound)
        logger.debug(smt_query)

        status, data = z3solver.solve(smt_query)

        if status == Z3.SAT:
            return encoder.parse_model(data)

        return None