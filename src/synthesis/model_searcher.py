import logging
from interfaces.automata import to_dot
from interfaces.smt_model import SmtModel
from synthesis.smt_encoder import Encoder
from synthesis.z3 import Z3


_logger = None

SCHED_ID_PREFIX = 'sch'

def _get_logger():
    global _logger
    if _logger is None:
        _logger = logging.getLogger(__name__)
    return _logger


def search(ucw_automaton, inputs, outputs, size, bound, z3solver, logic):
    assert bound > 0

    logger = _get_logger()

    logger.debug(ucw_automaton)
    logger.debug(to_dot(ucw_automaton))

    model_sizes = range(1, bound + 1) if size is None else range(size, size + 1)
    for current_bound in model_sizes:
        logger.info('searching a model of size {0}..'.format(current_bound))

        encoder = Encoder(logic)
        smt_str = encoder.encode(ucw_automaton, inputs, outputs, current_bound)
        z3solver.solve(smt_str)

        if z3solver.get_state() == Z3.UNSAT:
            logger.info('unsat..')
        elif z3solver.get_state() == Z3.SAT:
            logger.info('sat!')
            model = SmtModel(z3solver.get_model())
            return model
        else:
            logger.warning('solver status is unknown')
            break

    return None
