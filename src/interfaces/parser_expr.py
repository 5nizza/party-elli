from helpers.python_ext import index_of

class Signal:
    def __init__(self, name:str):
        self.name = name

    def __repr__(self):
        return str(self.name)

    def __eq__(self, other):
        if not isinstance(other, Signal):
            return False
        return str(self) == str(other)

    def __hash__(self):
        return hash(str(self))


class QuantifiedSignal(Signal):
    def __init__(self, base_name:str, *binding_indices):
        super().__init__(base_name)
        self.binding_indices = tuple(binding_indices) #binding index: string means parametrization, int - process index

    def __repr__(self):
        return self.name + '_' + '_'.join(map(str, self.binding_indices))

    __str__ = __repr__


class Number:
    def __init__(self, number:int):
        self._number = number

    def __repr__(self):
        return str(self._number)

    def __eq__(self, other):
        if not isinstance(other, Number):
            return False
        return self._number == other._number

    def __ne__(self, other):
        return not self.__eq__(other)


class Expr:
    def __init__(self, name):
        self.name = name
    def __repr__(self):
        return str(self.name)

    def __hash__(self):
        return hash(str(self))

    def __eq__(self, other):
        if not isinstance(other, self.__class__):
            return False
        return str(self) == str(other)


class Bool(Expr):
    def __init__(self, value):
        super().__init__(str(value))
    def __repr__(self):
        return self.name


class BinOp(Expr):
    def __init__(self, name, arg1, arg2):
        super().__init__(name)
        self.arg1 = arg1
        self.arg2 = arg2
    def __repr__(self):
        if self.name != '=':
            return str(self.arg1) + ' ' + self.name + ' ' + str(self.arg2)
        else:
            return str(self.arg1) + self.name + str(self.arg2)


class UnaryOp(Expr):
    def __init__(self, name, arg):
        super().__init__(name)
        self.arg = arg
    def __repr__(self):
        return self.name + '({0})'.format(self.arg)


class ForallExpr(Expr):
    def __init__(self, binding_indices:'binding indices', expr:Expr):
        super().__init__('Forall')
        self.arg1, self.arg2 = tuple(binding_indices), expr #TODO: rename fields

    def __str__(self):
        return self.name + str('({0})'.format(','.join(self.arg1))) + ' ' + str(self.arg2)

    __repr__ = __str__


########################################################################################
# helpers

def and_expressions(conjuncts):
    conjuncts = [c for c in conjuncts if c != Bool(True)]

    if len(conjuncts) == 0:
        return Bool(True)

    if len(conjuncts) == 1:
        return conjuncts[0]

    res = conjuncts[0]
    for c in conjuncts[1:]:
        res = BinOp('*', res, c)

    return res


def is_quantified_property(property) -> Bool: #TODO: does not allow embedded forall quantifiers
    """ Return True iff the property has quantified indices.
        Numbers cannot be used as quantification indices.
    """
    for e in property.assumptions + property.guarantees:
        if isinstance(e, ForallExpr):
            binding_indices = e.arg1
            if index_of(lambda bi: isinstance(bi, str), binding_indices) is not None:
                return True
        else:
            assert e.__class__ in [ForallExpr, BinOp, UnaryOp, Bool], 'unknown class'

    return False
