import logging
from helpers.logging import log_entrance
from interfaces.automata import to_dot
from interfaces.smt_model import SmtModel
from synthesis.smt_par_encoder import ParEncoder
from synthesis.z3 import Z3

@log_entrance(logging.getLogger(), logging.INFO)
def search(ucw_automaton, inputs, outputs, bounds, z3solver, logic):
    logger = logging.getLogger()

    logger.debug(ucw_automaton)
    logger.debug(to_dot(ucw_automaton))

    for current_bound in bounds:
        logger().info('searching a model of size {0}..'.format(current_bound))

        encoder = ParEncoder(logic, False)
        smt_str = encoder.encode(ucw_automaton, inputs, outputs, current_bound)
        z3solver.solve(smt_str)

        if z3solver.get_state() == Z3.UNSAT:
            logger().info('unsat..')
        elif z3solver.get_state() == Z3.SAT:
            logger().info('sat!')
            model = SmtModel(z3solver.get_model())
            return model
        else:
            logger().warning('solver status is unknown')
            break

    return None
