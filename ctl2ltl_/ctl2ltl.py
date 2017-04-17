import logging
from typing import Dict, List

from helpers.pnf_normalizer import PNFNormalizer
from helpers.spec_helper import prop, G, X, F
from interfaces.expr import Expr, UnaryOp, BinOp, Number, Signal
from interfaces.spec import Spec
from parsing.visitor import Visitor


class _ReplacerVisitor(Visitor):
    def __init__(self, new_props_prefix:str):
        self.f_by_p = dict()   # type: Dict[BinOp, UnaryOp]
        self._p_by_f = dict()  # type: Dict[UnaryOp, BinOp]
        self._p_prefix = new_props_prefix
        self._last = 0

    def _get_add_new_p(self, a_e_expr:UnaryOp) -> BinOp:
        # optimization:
        # check if we already introduced a proposition for this expression
        # (although it is OK to introduce several propositions for the same expression)
        if a_e_expr not in self._p_by_f:  # can miss the same Expr (e.g.: two different instances of the same Expr)
            p = prop(self.gen_new_name())
            self._p_by_f[a_e_expr] = p
        return self._p_by_f[a_e_expr]

    def gen_new_name(self) -> str:
        name = '%s%i' % (self._p_prefix, self._last)
        self._last += 1
        return name

    def visit_unary_op(self, unary_op:UnaryOp):
        res = super().visit_unary_op(unary_op)
        if unary_op.name in ('E', 'A'):
            p = self._get_add_new_p(res)
            self.f_by_p[p] = res
            return p
        return res
# end of ReplacerVisitor


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
               G(G((p & d_eq_i) >> F(phi.arg)))
    if phi.name == 'U':
        return G(p >> (phi.arg2 | (phi.arg1 & (d_eq_i >> X(p))))) & \
               G(G((p & d_eq_i) >> F(phi.arg2)))

    assert 0, str(f)


def convert(spec:Spec) -> (Expr, List[Signal]):
    """ :return LTL formula """

    # Running example: EG~g & AG(EF~g & EFg), inputs = {r}, outputs = {g}

    # get top-formula and the first bunch for A/E sub-formulas
    pnf_formula = PNFNormalizer().dispatch(spec.formula)
    visitor = _ReplacerVisitor('p')
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
