import logging
from interfaces.smt_model import SmtModel
from synthesis.smt_encoder import Encoder, UFLIA
from synthesis.z3 import Z3

_logger = None

def _get_logger():
    global _logger
    if _logger is None:
        _logger = logging.getLogger(__name__)
    return _logger


def search(uct, inputs, outputs, size, bound, z3solver, logic):
    assert bound > 0

    logger = _get_logger()

    logger.info("searching the model of size {0}".format(('<=' + str(bound)) if size is None else size))

    encoder = Encoder(uct, inputs, outputs, logic)
    model_sizes = range(1, bound + 1) if size is None else range(size, size + 1)
    for current_bound in model_sizes:
        logger.info('trying model size = %i', current_bound)

        smt_str = encoder.encode(current_bound)
        z3solver.solve(smt_str)

        if z3solver.get_state() == Z3.UNSAT:
            logger.info('unsat..')
        elif z3solver.get_state() == Z3.SAT:
            logger.info('sat!')
            model = SmtModel(z3solver.get_model())
            return model
        else:
            logger.warning('solver status is unknown')

    return None