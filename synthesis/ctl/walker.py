from typing import Dict, Set

from ctl2ltl_.ctl_atomizer import CTLAtomizerVisitor
from interfaces.LTL_to_automaton import LTLToAutomaton
from interfaces.automata import Automaton
from interfaces.expr import Expr
from interfaces.expr import BinOp as Prop


def automize_ctl(formula:Expr, ltl_to_atm:LTLToAutomaton)\
        -> (Expr, Dict[Prop, Automaton], Set[Automaton]):
    """ Guarantees: all automata nodes have unique names.
    :returns  top_formula, atm_by_p, subset of automata that are UCWs
    """

    atomizer = CTLAtomizerVisitor('__p')
    top_formula = atomizer.dispatch(formula)
    atm_by_p = dict()  # type: Dict[Prop, Automaton]
    # (note that all `p` are positive, and all automata are NBWs)
    pref = 0
    UCWs = set()
    for p, subformula in atomizer.f_by_p.items():
        assert subformula.name in 'AE', subformula
        if subformula.name == 'A':
            atm = ltl_to_atm.convert(~subformula.arg, '%i_'%pref)
            atm.name = '(UCW) ' + str(subformula)
            UCWs.add(atm)
        else:
            atm = ltl_to_atm.convert(subformula.arg, '%i_'%pref)
            atm.name = str(subformula)
        atm_by_p[p] = atm
        pref += 1
    return top_formula, atm_by_p, UCWs
