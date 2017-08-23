from typing import Dict

from helpers.nnf_normalizer import NNFNormalizer
from helpers.spec_helper import prop
from interfaces.expr import UnaryOp, BinOp
from parsing.visitor import Visitor


# TODO: remove me
class CTLAtomizerENFVisitor(Visitor):
    """
    All propositions refer to E-expressions,
    `dispatch` returns the top-level expression (over new propositions),
    it has no restriction on its form (can have ~p).
    For ~p we use !(sig=Number(1)) (rather than `sig=Number(0)`).
    """

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
        if unary_op.name == 'E':
            p = self._get_add_new_p(res)
            self.f_by_p[p] = p
            return p
        if unary_op.name == 'A':
            neg_res = NNFNormalizer().dispatch(~res)
            p = self._get_add_new_p(neg_res)
            self.f_by_p[p] = neg_res
            return ~p
        return res
