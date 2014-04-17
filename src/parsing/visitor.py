import math
from interfaces.parser_expr import Number, BinOp, UnaryOp, Bool, Signal, ForallExpr


class Visitor:
    def dispatch(self, node):  # TODO: clear: should accept Expr and return Expr
        if isinstance(node, BinOp):
            return self.visit_binary_op(node)

        if isinstance(node, UnaryOp):
            return self.visit_unary_op(node)

        if isinstance(node, Bool):
            return self.visit_bool(node)

        if isinstance(node, Signal):
            return self.visit_signal(node)

        if isinstance(node, Number):
            return self.visit_number(node)

        if isinstance(node, tuple):
            return self.visit_tuple(node)

        if isinstance(node, ForallExpr):
            return self.visit_forall(node)

        assert 0, 'unknown node type ' + str(node.__class__) + ': ' + str(node)

    def visit_binary_op(self, binary_op:BinOp):
        return BinOp(binary_op.name, self.dispatch(binary_op.arg1), self.dispatch(binary_op.arg2))

    def visit_unary_op(self, unary_op:UnaryOp):
        return UnaryOp(unary_op.name, self.dispatch(unary_op.arg))

    def visit_bool(self, bool_const:Bool):
        return bool_const

    def visit_signal(self, signal:Signal):
        return signal

    def visit_number(self, number:Number):
        return number

    def visit_tuple(self, node:tuple):
        return node

    def visit_forall(self, node:ForallExpr):
        #: :type: tuple
        binding_indices_visited = self.dispatch(node.arg1)
        #: :type: Expr
        quantified_expr_visited = self.dispatch(node.arg2)

        return ForallExpr(binding_indices_visited, quantified_expr_visited)


def get_log_bits(nof_processes:int) -> int:
    return int(max(1, math.ceil(math.log(nof_processes, 2))))


class WeakToUntilConverterVisitor(Visitor):
    def visit_binary_op(self, binary_op:BinOp):
        if binary_op.name == 'W':
            bin_op_expr = BinOp('+',
                                BinOp('U', binary_op.arg1, binary_op.arg2),
                                UnaryOp('G', binary_op.arg1))
            return self.dispatch(bin_op_expr)
        else:
            return super().visit_binary_op(binary_op)