from interfaces.expr import BinOp, UnaryOp
from parsing.visitor import Visitor


class WeakToUntilConverterVisitor(Visitor):
    def visit_binary_op(self, binary_op:BinOp):
        if binary_op.name == 'W':
            bin_op_expr = BinOp('+',
                                BinOp('U', binary_op.arg1, binary_op.arg2),
                                UnaryOp('G', binary_op.arg1))
            return self.dispatch(bin_op_expr)
        else:
            return super().visit_binary_op(binary_op)
