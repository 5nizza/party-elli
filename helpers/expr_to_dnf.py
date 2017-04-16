from typing import List

from sympy import Symbol, to_dnf, Not, Or, And, simplify_logic
from sympy import false as sympy_false
from sympy import true as sympy_true

from helpers.nnf_normalizer import get_sig_number
from helpers.spec_helper import prop
from interfaces.expr import Expr, BinOp, Number, Bool, UnaryOp
from parsing.visitor import Visitor


class SympyConverter(Visitor):
    def visit_binary_op(self, binary_op:BinOp):
        assert binary_op.name in '*+=', str(binary_op)
        if binary_op.name == '=':
            sig, num = get_sig_number(binary_op)
            assert num == Number(1), str(num)
            sympy_prop = Symbol(sig.name)
            return sympy_prop

        if binary_op.name == '*':
            return self.dispatch(binary_op.arg1) & self.dispatch(binary_op.arg2)

        if binary_op.name == '+':
            return self.dispatch(binary_op.arg1) | self.dispatch(binary_op.arg2)

    def visit_bool(self, bool_const:Bool):
        return (sympy_false, sympy_true)[bool_const==Bool(True)]

    def visit_unary_op(self, unary_op:UnaryOp):
        assert unary_op.name == '!', str(unary_op)
        return ~self.dispatch(unary_op.arg)
# end of SympyConverter


def to_dnf_set(dst_expr:Expr) -> List[List[Expr]]:
    sympy_dst_expr = simplify_logic(SympyConverter().dispatch(dst_expr))  # the checks below need this `simplify`

    if sympy_dst_expr == sympy_true:
        return [[]]
    if sympy_dst_expr == sympy_false:
        return []

    dnf_sympy_dst_expr = to_dnf(sympy_dst_expr, simplify=True)
    cubes = _get_cubes(dnf_sympy_dst_expr)
    cubes_list = []
    for cube in cubes:
        literals = _get_literals(cube)
        props_list = []
        for l in literals:
            if isinstance(l, Not):
                props_list.append(~prop(str(l.args[0])))   # it should print its name..
            else:
                props_list.append(prop(str(l)))  # it should print its name..
        cubes_list.append(props_list)
    return cubes_list


def _get_cubes(dnf_expr) -> tuple:
    assert dnf_expr not in (sympy_true, sympy_false)
    if isinstance(dnf_expr, Or):
        return dnf_expr.args
    return dnf_expr,


def _get_literals(expr) -> tuple:
    if isinstance(expr, Or) or isinstance(expr, And):
        return expr.args
    assert isinstance(expr, (Not, Symbol)), str(expr.__class__)
    return expr,  # tuple
