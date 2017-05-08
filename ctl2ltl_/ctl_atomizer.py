from typing import Dict

from helpers.spec_helper import prop
from interfaces.expr import UnaryOp, BinOp
from parsing.visitor import Visitor


class CTLAtomizerVisitor(Visitor):
    """
    Replaces A/E subformulas with propositions.
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
        if unary_op.name in 'AE':
            p = self._get_add_new_p(res)
            self.f_by_p[p] = res
            return p
        return res
