from functools import lru_cache

import logging
from typing import Dict

import spot

from config import LTL3BA_PATH
from helpers.python_ext import is_empty_str
from helpers.shell import execute_shell
from interfaces.LTL_to_automaton import LTLToAutomaton
from interfaces.automata import Automaton
from interfaces.expr import Expr, Signal
from ltl_to_automaton.ast_to_ltl3ba import ConverterToLtl2BaFormatVisitor
from ltl_to_automaton.spot_atm_converter import spotAtm_to_automaton
from parsing.weak_until_converter import WeakToUntilConverterVisitor


class LTLToAtmViaLTL3BA(LTLToAutomaton):
    _execute_cmd = LTL3BA_PATH + ' -H3 -f'

    @staticmethod
    @lru_cache()
    def convert(expr:Expr, states_prefix:str='', timeout:int=None) -> Automaton:
        expr = WeakToUntilConverterVisitor().dispatch(expr)   # ltl3ba 1.1.2 does not support W

        format_converter = ConverterToLtl2BaFormatVisitor()
        property_in_ltl2ba_format = format_converter.dispatch(expr)

        logging.debug('Ltl2UCW: converting:\n' + property_in_ltl2ba_format)

        return LTLToAtmViaLTL3BA._convert_raw(property_in_ltl2ba_format,
                                              format_converter.signal_by_name,
                                              states_prefix,
                                              timeout)

    @staticmethod
    def _convert_raw(property_:str, signal_by_name:Dict[str, Signal], states_prefix, timeout=None) -> Automaton:
        """ :param property_: in the LTL2BA format (we do NOT negate it!) """

        rc, ba, err = execute_shell('{0} "{1}"'.format(LTLToAtmViaLTL3BA._execute_cmd, property_),
                                    timeout=timeout)
        assert rc == 0, str(rc) + ', err: ' + str(err) + ', out: ' + str(ba)
        assert is_empty_str(err), err
        logging.debug(ba)

        aut = spot.automaton(ba + '\n')  # type: spot.twa
        # (when SPOT sees `\n` it treats input as the string)
        atm = spotAtm_to_automaton(aut, states_prefix, signal_by_name, property_)
        atm.name = property_
        return atm

        # initial_nodes, rejecting_nodes, nodes = parse_ltl2ba_ba(ba, signal_by_name, states_prefix)
        #
        # automaton = Automaton(initial_nodes, nodes, name=str(property_))
        #
        # return automaton
