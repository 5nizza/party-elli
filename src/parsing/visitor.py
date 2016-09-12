from interfaces.expr import Number, BinOp, UnaryOp, Bool, Signal


class Visitor:
    def dispatch(self, node):
        assert node

        """ Note that it does not necessary returns object of Expr class """
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

        assert 0, 'unknown node type ' + str(node.__class__) + ': ' + str(node)

    def visit_binary_op(self, binary_op:BinOp):
        return BinOp(binary_op.name,
                     self.dispatch(binary_op.arg1),
                     self.dispatch(binary_op.arg2))

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
