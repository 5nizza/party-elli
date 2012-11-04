import logging
from helpers.logging import log_entrance
from helpers.shell import execute_shell
from helpers.automata_helper import to_dot
from interfaces.automata import Automaton
from synthesis.alternating_to_universal import convert_acw_to_ucw
from translation2uct.ltl2acw import parse_ltl3ba_aa
from translation2uct.ltl2ba import parse_ltl2ba_ba


def get_solid_property(properties):
    return ' && '.join(map(lambda p: '({0})'.format(p), properties))


def negate(prop):
    return '!({0})'.format(prop)


class Ltl2UCW:
    def __init__(self, ltl2ba_path):
        self._execute_cmd = ltl2ba_path +' -M -f'
        self._logger = logging.getLogger(__name__)

    @log_entrance(logging.getLogger(), logging.INFO)
    def convert(self, property):
        negated = negate(property)

        rc, ba, err = execute_shell('{0} "{1}"'.format(self._execute_cmd, negated))
        assert rc == 0, str(rc) + ', err: ' + str(err) + ', out: ' + str(ba)
        assert (err == '') or err is None, err
        self._logger.debug(ba)

        initial_nodes, rejecting_nodes, nodes = parse_ltl2ba_ba(ba)

        automaton = Automaton(initial_nodes, rejecting_nodes, nodes, name=str(property))
        return automaton


class Ltl2ACW:
    def __init__(self, ltl2ba_path): #TODO: should accept instance of ltl3ba runner
        self._execute_cmd = ltl2ba_path + ' -M -d -f'
        self._logger = logging.getLogger(__name__)

    def convert(self, ltl_spec):
        rc, text, err = execute_shell('{0} "{1}"'.format(self._execute_cmd, ltl_spec.property))
        self._logger.debug(text)
        assert rc == 0, rc
        assert (err == '') or err is None, err

        init_sets_list, rejecting_nodes, nodes = parse_ltl3ba_aa(text, self._logger)

        return Automaton(init_sets_list, rejecting_nodes, nodes)


class Ltl2UCW_thru_ACW:
    def __init__(self, ltl2ba_path):
        self._ltl2acw = Ltl2ACW(ltl2ba_path)
        self._logger = logging.getLogger()

    @log_entrance(logging.getLogger(), logging.INFO)
    def convert(self, ltl_spec):
        acw_automaton = self._ltl2acw.convert(ltl_spec)

        print('convert: before convert_acw_to_ucw')
        ucw_automaton = convert_acw_to_ucw(acw_automaton, acw_automaton.rejecting_nodes, ltl_spec.inputs+ltl_spec.outputs)

        self._logger.info('converted alternating automaton to ucw: size increase from {0} to {1}'
                          .format(len(acw_automaton.nodes), len(ucw_automaton.nodes)))
        self._logger.debug('original automaton nodes: ' + to_dot(acw_automaton))
        self._logger.debug('preprocessed ucw_automaton: ' + to_dot(ucw_automaton))

        return ucw_automaton
