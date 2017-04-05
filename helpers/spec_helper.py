from typing import Tuple

from helpers.automata_classifier import is_safety_automaton
from interfaces.LTL_to_automaton import LTLToAutomaton
from interfaces.expr import Expr, Number

from interfaces.expr import UnaryOp, BinOp, Signal


def is_safety_ltl(expr:Expr, ltl_to_atm:LTLToAutomaton) -> bool:
    automaton = ltl_to_atm.convert(~expr)  # !(safety ltl) should have safety automaton
    res = is_safety_automaton(automaton)
    return res


def split_safety_liveness(formulas, ltl_to_atm:LTLToAutomaton):
    formulas = set(formulas)

    safety = set(filter(lambda f: is_safety_ltl(f, ltl_to_atm), formulas))
    liveness = formulas - safety

    return safety, liveness


def A(arg) -> UnaryOp: return UnaryOp('A', arg)
def E(arg) -> UnaryOp: return UnaryOp('E', arg)
def G(arg) -> UnaryOp: return UnaryOp('G', arg)
def F(arg) -> UnaryOp: return UnaryOp('F', arg)
def X(arg) -> UnaryOp: return UnaryOp('X', arg)

def GF(arg) -> UnaryOp: return G(F(arg))
def FG(arg) -> UnaryOp: return F(G(arg))

def AG(arg) -> UnaryOp: return A(G(arg))
def AX(arg) -> UnaryOp: return A(X(arg))
def AF(arg) -> UnaryOp: return A(F(arg))
def EF(arg) -> UnaryOp: return E(F(arg))
def EX(arg) -> UnaryOp: return E(X(arg))
def EG(arg) -> UnaryOp: return E(G(arg))
def EU(a1, a2) -> UnaryOp: return E(U(a1, a2))
def AU(a1, a2) -> UnaryOp: return A(U(a1, a2))

def AGF(arg) -> UnaryOp: return A(G(F(arg)))
def EGF(arg) -> UnaryOp: return E(G(F(arg)))
def EFG(arg) -> UnaryOp: return E(F(G(arg)))

def AGEF(arg) -> UnaryOp: return A(G(E(F(arg))))
def AFEG(arg) -> UnaryOp: return A(F(E(G(arg))))
# def EFEG(arg) -> UnaryOp: return E(F(E(G(arg))))  # <- equiv. to EFG
def EFAG(arg) -> UnaryOp: return E(F(A(G(arg))))

def U(a1, a2) -> BinOp: return BinOp('U', a1, a2)
def W(a1, a2) -> BinOp: return BinOp('W', a1, a2)
def R(a1, a2) -> BinOp: return BinOp('R', a1, a2)

def prop(name:str) -> BinOp: return BinOp('=', Signal(name), Number(1))
def sig_prop(name:str) -> Tuple[Signal, BinOp]:
    return Signal(name),\
           BinOp('=', Signal(name), Number(1))
