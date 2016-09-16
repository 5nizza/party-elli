from interfaces.expr import Number, UnaryOp, BinOp, Bool, Signal
from parsing.visitor import Visitor


class ConverterToWringVisitor(Visitor):
    def visit_number(self, number:Number):
        return str(number)

    def visit_unary_op(self, unary_op:UnaryOp):
        arg = self.dispatch(unary_op.arg)

        return '({op}({arg}))'.format(op=unary_op.name, arg=arg)

    def visit_binary_op(self, binary_op:BinOp):
        arg1, arg2 = self.dispatch(binary_op.arg1), self.dispatch(binary_op.arg2)

        if binary_op.name == '=':
            #don't add spaces around '=' -- Acacia cannot recognize this
            return '({arg1}{op}{arg2})'.format(arg1=arg1, arg2=arg2, op=binary_op.name)
        else:
            return '({arg1} {op} {arg2})'.format(arg1=arg1, arg2=arg2, op=binary_op.name)

    def visit_tuple(self, node:tuple):
        assert 0

    def visit_bool(self, bool_const:Bool):
        return str(bool_const).upper()

    def visit_signal(self, signal:Signal):
        # assert signal.name != ACTIVE_NAME, 'not supported:' + str(signal.name)
        # assert signal.name != HAS_TOK_NAME, 'not supported:' + str(signal.name)

        return str(signal)
