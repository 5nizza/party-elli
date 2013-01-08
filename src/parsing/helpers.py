from interfaces.parser_expr import Number, BinOp, UnaryOp, Bool, Signal, ForallExpr, QuantifiedSignal


class Visitor:
    def dispatch(self, node): #TODO: clear: should accept Expr and return Expr
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


class ConverterToLtl2BaFormatVisitor(Visitor):
    def __init__(self):
        self.signal_by_name = dict()


    def visit_binary_op(self, binary_op:BinOp):
        arg1 = self.dispatch(binary_op.arg1)
        arg2 = self.dispatch(binary_op.arg2)

        if binary_op.name == '*':
            return '({arg1}) && ({arg2})'.format(arg1 = arg1, arg2 = arg2)

        if binary_op.name == '=':
            if isinstance(arg1, Number):
                number_arg, signal_arg = arg1, arg2
            else:
                number_arg, signal_arg = arg2, arg1
            return '{neg}{signal}'.format(signal = signal_arg, neg = ['', '!'][number_arg == Number(0)])

        if binary_op.name == '+':
            return '({arg1}) || ({arg2})'.format(arg1 = arg1, arg2 = arg2)

        if binary_op.name == 'U' or binary_op.name == '->' or binary_op.name == '<->':
            return '({arg1}) {op} ({arg2})'.format(arg1 = arg1, arg2 = arg2, op = binary_op.name)

        assert 0, 'unknown binary operator: ' + "'" + str(binary_op.name) + "'"


    def visit_unary_op(self, unary_op:UnaryOp):
        arg = self.dispatch(unary_op.arg)
        assert unary_op.name in ('G', 'F', 'X', '!'), 'unknown unary operator: ' + str(unary_op.name)
        return '{op}({arg})'.format(op = unary_op.name, arg = arg)


    def visit_bool(self, bool_const):
        return bool_const.name.lower()


    def visit_signal(self, signal):
#        assert '___' not in signal.name, 'current version assumes that there are no "___" in signal names'

        suffix = ''
        if isinstance(signal, QuantifiedSignal) and len(signal.binding_indices) > 0:
#            suffix = '___' + '___'.join(map(str, signal.binding_indices))
            suffix = '_'.join(map(str, signal.binding_indices))

        name = (signal.name + suffix).lower() #ltl3ba treats upper letter wrongly
        self.signal_by_name[name] = signal

        return name


    def visit_number(self, number:Number):
        return number


    def visit_forall(self, node:ForallExpr):
        return self.dispatch(node.arg2) #TODO: default behaviour of this visitor is to ignore Forall


def _and_ltl2ba_properties(properties):
    properties = list(properties)
    if len(properties) == 0:
        return 'true'

    return ' && '.join(['(' + str(p) + ')' for p in properties])


def convert_asts_to_ltl3ba_format(asts):
    properties = list(map(lambda a: convert_ast_to_ltl3ba_format(a), asts)) +\
                 list(map(lambda a: convert_ast_to_ltl3ba_format(a), asts))
    property = _and_ltl2ba_properties(properties)

    return property


def convert_ast_to_ltl3ba_format(property_ast):
    result = ConverterToLtl2BaFormatVisitor().dispatch(property_ast)
    return result