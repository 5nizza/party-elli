from functools import lru_cache

from helpers.automata_classifier import is_safety_automaton
from interfaces.expr import Expr


@lru_cache()
def is_safety_ltl(expr:Expr, ltl2automaton) -> bool:
    automaton = ltl2automaton.convert(~expr)  # !(safety ltl) has safety automaton
    res = is_safety_automaton(automaton)
    return res


def split_safety_liveness(formulas, ltl2automaton):
    formulas = set(formulas)

    safety = set(filter(lambda f: is_safety_ltl(f, ltl2automaton), formulas))
    liveness = formulas - safety

    return safety, liveness