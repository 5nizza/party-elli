from helpers.nnf_normalizer import and_expr
from helpers.GR1helpers import strengthen1, strengthen2
from helpers.spec_helper import split_safety_liveness
from interfaces.LTL_to_automaton import LTLToAutomaton
from interfaces.spec import Spec
from parsing import acacia_parser


def parse_acacia_and_build_expr(ltl_text:str, part_text:str,
                                ltl_to_atm:LTLToAutomaton,
                                strengthen_lvl) -> Spec:
    """ Note: parses and strengthens the formula. """

    input_signals, output_signals, data_by_unit = acacia_parser.parse(ltl_text, part_text)

    assert data_by_unit is not None

    ltl_properties = []
    for (unit_name, unit_data) in data_by_unit.items():
        assumptions = unit_data[0]
        guarantees = unit_data[1]

        a_safeties, a_livenesses = split_safety_liveness(assumptions, ltl_to_atm)
        g_safeties, g_livenesses = split_safety_liveness(guarantees, ltl_to_atm)

        if strengthen_lvl == 2:
            ltl_property = strengthen2([], [],
                                       a_safeties, g_safeties,
                                       a_livenesses, g_livenesses)
        elif strengthen_lvl == 1:
            ltl_property = strengthen1([], [],
                                       a_safeties, g_safeties,
                                       a_livenesses, g_livenesses)
        else:
            ltl_property = and_expr(list(a_safeties) + list(a_livenesses))\
                           >> and_expr(list(g_safeties) + list(g_livenesses))
        ltl_properties.append(ltl_property)

    return Spec(input_signals, output_signals, and_expr(ltl_properties))
