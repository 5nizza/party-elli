from helpers.spec_helper import and_properties
from parsing.interface import Number, BinOp, UnaryOp, Bool, Signal

__author__ = 'art_haali'

class Visitor:
    def dispatch(self, node):
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

        assert 0, 'unknown node type' + str(node)

    def visit_binary_op(self, binary_op): raise NotImplementedError()
    def visit_unary_op(self, unary_op): raise NotImplementedError()
    def visit_bool(self, bool_const): raise NotImplementedError()
    def visit_signal(self, signal): raise NotImplementedError()
    def visit_number(self, number): raise NotImplementedError()


class ConverterToLtl2BaFormatVisitor(Visitor):
    def visit_binary_op(self, binary_op):
        arg1 = self.dispatch(binary_op._arg1)
        arg2 = self.dispatch(binary_op._arg2)

        if binary_op.name == '*':
            return '({arg1}) && ({arg2})'.format(arg1 = arg1, arg2 = arg2)

        if binary_op.name == '=':
            return '{neg}{arg1}'.format(arg1 = arg1, neg = ['', '!'][arg2 == Number(0)])

        if binary_op.name == '+':
            return '({arg1}) || ({arg2})'.format(arg1 = arg1, arg2 = arg2)

        if binary_op.name == 'U' or binary_op.name == '->' or binary_op.name == '<->':
            return '({arg1}) {op} ({arg2})'.format(arg1 = arg1, arg2 = arg2, op = binary_op.name)

        assert 0, 'unknown binary operator: ' + "'" + str(binary_op.name) + "'"

    def visit_unary_op(self, unary_op):
        arg = self.dispatch(unary_op._arg)
        assert unary_op.name in ('G', 'F', 'X', '!'), 'unknown unary operator: ' + str(unary_op.name)
        return '{op}({arg})'.format(op = unary_op.name, arg = arg)

    def visit_bool(self, bool_const):
        return bool_const.name.lower()

    def visit_signal(self, signal):
        return signal.name.lower() #ltl3ba treats upper letter wrongly

    def visit_number(self, number):
        return number


def convert_asts_to_ltl3ba_format(asts):
    properties = list(map(lambda a: convert_ast_to_ltl3ba_format(a), asts)) +\
                 list(map(lambda a: convert_ast_to_ltl3ba_format(a), asts))
    property = and_properties(properties)

    return property


def convert_ast_to_ltl3ba_format(property_ast):
    result = ConverterToLtl2BaFormatVisitor().dispatch(property_ast)
    return result