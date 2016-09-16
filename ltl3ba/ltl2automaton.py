import logging
from functools import lru_cache

from helpers.converter_to_wring import ConverterToWringVisitor
from helpers.shell import execute_shell
from interfaces.automata import Automaton
from interfaces.expr import Expr, Signal
from ltl3ba.ast_to_ltl3ba import ConverterToLtl2BaFormatVisitor
from ltl3ba.ltl3ba_wrapper import parse_ltl2ba_ba
from parsing.weak_until_converter import WeakToUntilConverterVisitor


def _assert_are_signals_in_labels(nodes):  # TODO: remove me after debugging phase finished
    for n in nodes:
        for label in n.transitions:
            for s in label.keys():
                assert isinstance(s, Signal), str(s.__class__)


class LTL3BA:
    def __init__(self, ltl2ba_path):
        self._execute_cmd = ltl2ba_path + ' -f'  # determinization is enabled by default

    @lru_cache()
    def convert(self, expr:Expr, states_prefix='', timeout=None) -> Automaton:
        expr = WeakToUntilConverterVisitor().dispatch(expr)   # ltl3ba 1.1.2 does not support W

        format_converter = ConverterToLtl2BaFormatVisitor()
        property_in_ltl2ba_format = format_converter.dispatch(expr)

        logging.debug('Ltl2UCW: converting:\n' + property_in_ltl2ba_format)

        return self.convert_raw(property_in_ltl2ba_format, format_converter.signal_by_name, states_prefix, timeout)

    def convert_raw(self, property:str, signal_by_name:dict, states_prefix, timeout=None) -> Automaton:
        """
        :param property: in the LTL2BA format (we do NOT negate it!)
        """

        rc, ba, err = execute_shell('{0} "{1}"'.format(self._execute_cmd, property), timeout=timeout)
        assert rc == 0, str(rc) + ', err: ' + str(err) + ', out: ' + str(ba)
        assert (err == '') or err is None, err
        logging.debug(ba)

        initial_nodes, rejecting_nodes, nodes = parse_ltl2ba_ba(ba, signal_by_name, states_prefix)

        assert set(rejecting_nodes).issubset(set(nodes)) and set(initial_nodes).issubset(set(nodes))

        _assert_are_signals_in_labels(nodes)

        automaton = Automaton(initial_nodes, rejecting_nodes, nodes, name=str(property))

        return automaton
