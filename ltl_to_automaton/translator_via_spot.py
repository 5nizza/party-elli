import logging
from functools import lru_cache
from typing import Union

import spot

from interfaces.LTL_to_automaton import LTLToAutomaton
from interfaces.automata import Automaton
from interfaces.expr import Expr
from ltl_to_automaton.ast_to_ltl3ba import ConverterToLtl2BaFormatVisitor
from ltl_to_automaton.spot_atm_converter import spotAtm_to_automaton


class LTLToAtmViaSpot(LTLToAutomaton):
    @staticmethod
    @lru_cache()
    def convert(expr:Expr, states_prefix:str='') -> Automaton:
        format_converter = ConverterToLtl2BaFormatVisitor()
        property_in_ltl2ba_format = format_converter.dispatch(expr)

        logging.debug('ltl_to_automaton: converting:\n' + property_in_ltl2ba_format)

        return LTLToAtmViaSpot.convert_raw(property_in_ltl2ba_format, states_prefix)

    @staticmethod
    @lru_cache()
    def convert_raw(formula:str, states_prefix:str='') -> Automaton:
        spot_atm = spot.translate(formula, 'BA', 'High', 'Small')  # type: Union[spot.twa, spot.twa_graph]
        automaton = spotAtm_to_automaton(spot_atm, states_prefix)
        return automaton
