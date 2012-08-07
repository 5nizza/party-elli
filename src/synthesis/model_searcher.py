import logging
from helpers.logging import log_entrance
from interfaces.automata import to_dot
from interfaces.smt_model import SmtModel
from synthesis.smt_par_encoder import ParEncoder
from synthesis.z3 import Z3


__logger = None

SCHED_ID_PREFIX = 'sch'

def logger():
    global __logger
    if __logger is None:
        __logger = logging.getLogger(__name__)
    return __logger


@log_entrance(logging.getLogger(), logging.INFO)
def search_parametrized(architecture, ucw_automaton, inputs, outputs, nof_processes, local_bounds, z3solver, logic):
    logger().debug(ucw_automaton)
    logger().debug(to_dot(ucw_automaton))

    for bound in local_bounds:
        logger().info('searching a model of size {0}..'.format(bound))
        encoder = ParEncoder(logic, True)
        smt_query = encoder.encode_parametrized(architecture,
            ucw_automaton,
            inputs, outputs, nof_processes, bound, SCHED_ID_PREFIX)
        logger().debug(smt_query)

        z3solver.solve(smt_query)

        if z3solver.get_state() == Z3.UNSAT:
            logger().info('unsat..')
        elif z3solver.get_state() == Z3.SAT:
            logger().info('sat!')

    return None


@log_entrance(logging.getLogger(), logging.INFO)
def search(ucw_automaton, inputs, outputs, bounds, z3solver, logic):
    logger().debug(ucw_automaton)
    logger().debug(to_dot(ucw_automaton))

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
