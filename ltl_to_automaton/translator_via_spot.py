import logging
from functools import lru_cache
from typing import Union, Dict

import spot

from interfaces.LTL_to_automaton import LTLToAutomaton
from interfaces.automata import Automaton
from interfaces.expr import Expr, Signal
from ltl_to_automaton.ast_to_ltl3ba import ConverterToLtl2BaFormatVisitor
from ltl_to_automaton.spot_atm_converter import spotAtm_to_automaton


class LTLToAtmViaSpot(LTLToAutomaton):
    @staticmethod
    @lru_cache()
    def convert(expr:Expr, states_prefix:str='', timeout:int=None) -> Automaton:
        format_converter = ConverterToLtl2BaFormatVisitor()
        property_in_ltl2ba_format = format_converter.dispatch(expr)

        logging.debug('ltl_to_automaton: converting:\n' + property_in_ltl2ba_format)
        if timeout is not None:
            logging.warning('unsupported: timeout will be ignored (was set to %i)' % timeout)

        return LTLToAtmViaSpot.convert_raw(property_in_ltl2ba_format,
                                           format_converter.signal_by_name,
                                           states_prefix)

    @staticmethod
    def convert_raw(formula:str, signal_by_name:Dict[str, Signal], states_prefix:str='') -> Automaton:
        spot_atm = spot.translate(formula, 'BA', 'Medium', 'Any')  # type: Union[spot.twa, spot.twa_graph]
        automaton = spotAtm_to_automaton(spot_atm, states_prefix, signal_by_name, formula)
        return automaton
