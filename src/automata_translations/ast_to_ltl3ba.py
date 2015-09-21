from interfaces.expr import BinOp, Number, UnaryOp, QuantifiedSignal, ForallExpr
from parsing.visitor import Visitor


class ConverterToLtl2BaFormatVisitor(Visitor):
    def __init__(self):
        self.signal_by_name = dict()

    def visit_binary_op(self, binary_op:BinOp):
        arg1 = self.dispatch(binary_op.arg1)
        arg2 = self.dispatch(binary_op.arg2)

        if binary_op.name == '*':
            return '({arg1}) && ({arg2})'.format(arg1=arg1, arg2=arg2)

        if binary_op.name == '=':
            if isinstance(arg1, Number):
                number_arg, signal_arg = arg1, arg2
            else:
                number_arg, signal_arg = arg2, arg1
            return '{neg}{signal}'.format(signal=signal_arg, neg=['', '!'][number_arg == Number(0)])

        if binary_op.name == '+':
            return '({arg1}) || ({arg2})'.format(arg1=arg1, arg2=arg2)

        if binary_op.name == 'U' or binary_op.name == '->' or binary_op.name == '<->':
            return '({arg1}) {op} ({arg2})'.format(arg1=arg1, arg2=arg2, op=binary_op.name)

        assert 0, 'unknown binary operator: ' + "'" + str(binary_op.name) + "'"

    def visit_unary_op(self, unary_op:UnaryOp):
        arg = self.dispatch(unary_op.arg)
        assert unary_op.name in ('G', 'F', 'X', '!'), 'unknown unary operator: ' + str(unary_op.name)
        return '{op}({arg})'.format(op=unary_op.name, arg=arg)

    def visit_bool(self, bool_const):
        return bool_const.name.lower()

    def visit_signal(self, signal):
        suffix = ''
        if isinstance(signal, QuantifiedSignal) and len(signal.binding_indices) > 0:
            suffix = '_' + '_'.join(map(str, signal.binding_indices))

        name = (signal.name + suffix).lower()  # ltl3ba treats upper letters wrongly
        self.signal_by_name[name] = signal

        return name

    def visit_number(self, number:Number):
        return number

    def visit_forall(self, node:ForallExpr):
        return self.dispatch(node.arg2)  # TODO: default behaviour of this visitor is to ignore Forall
