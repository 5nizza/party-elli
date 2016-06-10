from typing import Iterable

from helpers.gr1helpers import strengthen1, strengthen2
from helpers.spec_helper import split_safety_liveness
from interfaces.expr import Signal, Expr, and_expr
from parsing import acacia_parser


def parse_acacia_and_build_expr(ltl_text: str, part_text: str,
                                ltl3ba,
                                strengthen_lvl) \
        -> (Iterable[Signal], Iterable[Signal], Expr):
    """
    Note: parses and strengthens the formula.
    """

    input_signals, output_signals, data_by_unit = acacia_parser.parse(ltl_text, part_text)

    if data_by_unit is None:
        return None, None, None

    ltl_properties = []
    for (unit_name, unit_data) in data_by_unit.items():
        assumptions = unit_data[0]
        guarantees = unit_data[1]

        a_safeties, a_livenesses = split_safety_liveness(assumptions, ltl3ba)
        g_safeties, g_livenesses = split_safety_liveness(guarantees, ltl3ba)

        if strengthen_lvl == 2:
            ltl_property = strengthen2([], [],
                                       a_safeties, g_safeties,
                                       a_livenesses, g_livenesses)
        else:
            ltl_property = strengthen1([], [],
                                       a_safeties, g_safeties,
                                       a_livenesses, g_livenesses)
        ltl_properties.append(ltl_property)

    return input_signals, output_signals, and_expr(ltl_properties)
