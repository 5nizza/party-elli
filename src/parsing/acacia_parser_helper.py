from typing import Iterable

from helpers.gr1helpers import build_almost_gr1_formula
from helpers.spec_helper import split_safety_liveness
from interfaces.expr import Signal, Expr, and_expressions, Bool
from parsing import acacia_parser


def parse_acacia_and_build_expr(ltl_text: str, part_text: str, ltl3ba) \
        -> (Iterable[Signal], Iterable[Signal], Expr):
    """
    Note: it strengthens the formula and uses:
        (init_ass & safety_ass -> safety_gua) & ...
    instead of
        (init_ass & liveness_ass & safety_ass -> safety_gua) & ...
    """

    input_signals, output_signals, data_by_name = acacia_parser.parse(ltl_text, part_text)

    if data_by_name is None:
        return None, None, None

    ltl_properties = []
    for (unit_name, unit_data) in data_by_name.items():
        assumptions = unit_data[0]
        guarantees = unit_data[1]

        a_safety, a_liveness = (and_expressions(p)
                                for p in split_safety_liveness(assumptions, ltl3ba))
        g_safety, g_liveness = (and_expressions(p)
                                for p in split_safety_liveness(guarantees, ltl3ba))

        ltl_property = build_almost_gr1_formula(Bool(True), Bool(True),
                                                a_safety, g_safety,
                                                a_liveness, g_liveness)
        ltl_properties.append(ltl_property)

    return input_signals, output_signals, and_expressions(ltl_properties)