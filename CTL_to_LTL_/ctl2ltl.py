import logging
from typing import List

from CTL_to_LTL_.ctl_atomizer import CTLAtomizerVisitor
from helpers.nnf_normalizer import NNFNormalizer
from helpers.spec_helper import prop, G, X, F
from interfaces.expr import Expr, UnaryOp, BinOp, Number, Signal
from interfaces.spec import Spec


def build_ltl_for_A(f:UnaryOp, p:BinOp) -> Expr:
    """
    +-------------------------------------------+
    |         AG(arg)  |  G[ p -> G(arg) ]      |
    |         AF(arg)  |  G[ p -> F(arg)]       |  (can be expressed via U)
    |         AX(arg)  |  G[ p -> X(arg)]       |
    |  A(arg1 U arg2)  |  G[ p -> arg1 U arg2]  |
    +-------------------------------------------+
    """
    assert f.name == 'A', str(f)
    return G(p >> f.arg)


def build_ltl_for_E(f:UnaryOp, p:BinOp, d:BinOp, i:BinOp) -> Expr:
    """
    +-------------------------------------------------------------+
    |         EG(arg)  |  G[ p -> arg & (d=i -> X(p)) ]           |
    |         EX(arg)  |  G[ p -> (d=i -> X(arg))]                |
    |         EF(arg)  |  G[ p -> arg | (d=i -> X(p))] &          |  (can be expressed via U)
    |                  |  G[ G(p & d=i) -> F(arg) ]               |
    |  E(arg1 U arg2)  |  G[ p -> arg2 | (arg1 & (d=i -> X(p))] & |
    |                  |  G[ G(p & d=i) -> F(arg2) ]              |
    +-------------------------------------------------------------+
    """
    phi = f.arg
    d_eq_i = (d >> i) & (i >> d)
    if phi.name == 'G':
        return G(p >> (phi.arg & (d_eq_i >> X(p))))
    if phi.name == 'X':
        return G((p & d_eq_i) >> X(phi.arg))
    if phi.name == 'F':
        return G(p >> (phi.arg | (d_eq_i >> X(p)))) & \
               G(G(p & d_eq_i) >> F(phi.arg))
    if phi.name == 'U':
        return G(p >> (phi.arg2 | (phi.arg1 & (d_eq_i >> X(p))))) & \
               G(G(p & d_eq_i) >> F(phi.arg2))

    assert 0, str(f)


def convert(spec:Spec) -> (Expr, List[Signal]):
    """ :return LTL formula """
    assert 0, 'not sure it works after my modifications of the Atomizer'

    # Running example: EG~g & AG(EF~g & EFg), inputs = {r}, outputs = {g}

    # get top-formula and the first bunch for A/E sub-formulas
    pnf_formula = NNFNormalizer().dispatch(spec.formula)
    visitor = CTLAtomizerVisitor('p')
    top_formula = visitor.dispatch(pnf_formula)

    logging.debug(visitor.f_by_p)

    # Running example:
    #   top_formula = p3 & p2
    #   visitor.f_by_p = {p3:EG~g, p2:AG(p1&p0), p1:EF~g, p0:EFg}

    # build LTL for each A/E sub-formula
    ltl_conjuncts = list()  # List[Expr]
    d_outputs = []  # List[BinOp]
    assert len(spec.inputs) == 1, str(spec)
    input_p = BinOp('=', list(spec.inputs)[0], Number(1))
    for p,f in visitor.f_by_p.items():
        assert f.name in 'AE', str(f)
        if f.name == 'E':
            d = prop(p.arg1.name.replace('p', 'd'))
            d_outputs.append(d)
            ltl_conjuncts.append(build_ltl_for_E(f, p, d, input_p))
        else:
            ltl_conjuncts.append(build_ltl_for_A(f, p))

    # add LTL of the top formula
    ltl_conjuncts.append(top_formula)
    ltl = ltl_conjuncts[0]
    for c in ltl_conjuncts[1:]:
        ltl = ltl & c

    # Running example:
    #   p3 & p2 &
    #   G[p3 -> ~g & (d=i -> X(p3))] &
    #   G[p2 -> G(p1&p0)] &
    #   G[p1 -> ~g | (d=i -> X(p1))] & G[G(p1 & d=i) -> F(p1)] &
    #   G[p0 -> g | (d=i -> X(p0))] & G[G(p0 & d=i) -> F(p0)]

    new_outputs = []  # type: List[Signal]
    new_outputs.extend(map(lambda p: p.arg1, visitor.f_by_p.keys()))
    new_outputs.extend(map(lambda p: p.arg1, d_outputs))

    return ltl, new_outputs
