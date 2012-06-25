import logging
from interfaces.automata import to_dot
from interfaces.smt_model import SmtModel
from synthesis.alternating_to_universal import convert_acw_to_ucw
from synthesis.states_extender import extend_self_looped_rejecting_states
from synthesis.smt_encoder import Encoder
from synthesis.z3 import Z3

_logger = None

def _get_logger():
    global _logger
    if _logger is None:
        _logger = logging.getLogger(__name__)
    return _logger


def search(automaton, inputs, outputs, size, bound, z3solver, logic):
    assert bound > 0

    logger = _get_logger()

    logger.info("searching the model of size {0}".format(('<=' + str(bound)) if size is None else size))

    model_sizes = range(1, bound + 1) if size is None else range(size, size + 1)
    for current_bound in model_sizes:
        logger.info('trying model size = %i', current_bound)

        logger.debug('original automaton nodes: ' + to_dot(automaton))

        ucw_automaton = convert_acw_to_ucw(automaton, automaton.rejecting_nodes, inputs+outputs)
        logger.info('converted alternating automaton to ucw: size increase from {0} to {1}'.format(
            len(automaton.nodes), len(ucw_automaton.nodes)))

        logger.debug('preprocessed ucw_automaton: ' + to_dot(ucw_automaton))

        encoder = Encoder(ucw_automaton, inputs, outputs, logic)
        smt_str = encoder.encode(current_bound)

        z3solver.solve(smt_str)
        logger.info('z3 solving finished')

        if z3solver.get_state() == Z3.UNSAT:
            logger.info('unsat..')
        elif z3solver.get_state() == Z3.SAT:
            logger.info('sat!')
            model = SmtModel(z3solver.get_model())
            return model
        else:
            logger.warning('solver status is unknown')

    return None
