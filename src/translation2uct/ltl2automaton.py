from functools import lru_cache
import logging

from helpers.converter_to_wring import ConverterToWringVisitor
from helpers.shell import execute_shell
from interfaces.automata import Automaton
from interfaces.parser_expr import UnaryOp, Expr, Signal
from parsing.visitor import WeakToUntilConverterVisitor
from translation2uct.ast_to_ltl3ba import ConverterToLtl2BaFormatVisitor
from translation2uct.ltl2ba import parse_ltl2ba_ba


def _negate(expr:Expr) -> Expr:
    return UnaryOp('!', expr)


def _assert_are_signals_in_labels(nodes):  # TODO: remove me after debugging phase finished
    for n in nodes:
        for label in n.transitions:
            for s in label.keys():
                assert isinstance(s, Signal), str(s.__class__)


class LTL3BA:
    def __init__(self, ltl2ba_path):
        self._execute_cmd = ltl2ba_path + ' -M -f'
        # self._execute_cmd = ltl2ba_path + ' -f'
        self._logger = logging.getLogger(__name__)

    @lru_cache()
    def convert(self, expr:Expr) -> Automaton:
        assert 0, 'make sure you negate the property before passing here!'
        # self._logger.info('Ltl2UCW: converting..\n' + ConverterToWringVisitor().dispatch(expr))

        # make sure we don't have Weak Until since ltl2ba does not accept it
        expr = WeakToUntilConverterVisitor().dispatch(expr)

        self._logger.info('Ltl2UCW: converting..(non-negated version)\n' + ConverterToWringVisitor().dispatch(expr))

        format_converter = ConverterToLtl2BaFormatVisitor()
        property_in_ltl2ba_format = format_converter.dispatch(expr)

        return self.convert_raw(property_in_ltl2ba_format, format_converter.signal_by_name)

    def convert_raw(self, property:str, signal_by_name:dict, states_prefix) -> Automaton:
        """
        :param property: in the LTL2BA format (we do NOT negate it!)
        """

        rc, ba, err = execute_shell('{0} "{1}"'.format(self._execute_cmd, property))
        assert rc == 0, str(rc) + ', err: ' + str(err) + ', out: ' + str(ba)
        assert (err == '') or err is None, err
        self._logger.debug(ba)

        initial_nodes, rejecting_nodes, nodes = parse_ltl2ba_ba(ba, signal_by_name, states_prefix)

        assert set(rejecting_nodes).issubset(set(nodes)) and set(initial_nodes).issubset(set(nodes))  # rm after debug

        _assert_are_signals_in_labels(nodes)

        automaton = Automaton(initial_nodes, rejecting_nodes, nodes, name=str(property))

        return automaton
