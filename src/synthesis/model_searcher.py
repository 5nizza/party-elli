import logging
from interfaces.smt_model import SmtModel
from synthesis.smt_encoder import Encoder
from synthesis.z3 import Z3

_logger = None

def _get_logger():
    global _logger
    if _logger is None:
        _logger = logging.getLogger(__name__)
    return _logger


def search(uct, inputs, outputs, bound, z3solver):
    assert bound > 0

    _logger = _get_logger()

    _logger.info("searching the model of size <=%s", bound)

    encoder = Encoder(uct, inputs, outputs)
    for current_bound in range(1, bound+1):
        _logger.info('trying model size = %i', current_bound)

        smt_str = encoder.encode_uct(current_bound)
        z3solver.solve(smt_str)

        if z3solver.get_state() == Z3.UNSAT:
            _logger.info('unsat..')
        elif z3solver.get_state() == Z3.SAT:
            _logger.info('sat!')
            model = SmtModel(z3solver.get_model())
            _logger.debug(str(model))
            return model
        else:
            _logger.warning('solver status is unknown')

    return None