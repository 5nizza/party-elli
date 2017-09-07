from interfaces.expr import Expr, UnaryOp, BinOp
from parsing.visitor import Visitor


def expr_size(e:Expr) -> int:
    """ Counts the number of binary and unary operations. """
    class Walker(Visitor):
        def __init__(self):
            self.size = 0
        def visit_binary_op(self, binary_op:BinOp):
            self.size += 1
            return super().visit_binary_op(binary_op)
        def visit_unary_op(self, unary_op:UnaryOp):
            self.size += 1
            return super().visit_unary_op(unary_op)
    w = Walker()
    w.dispatch(e)
    return w.size
