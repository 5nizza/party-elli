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
    def __init__(self, number):
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
        return self.name + str(self.arg1) + ' ' + str(self.arg2)

    __repr__ = __str__


########################################################################################
# helpers

def and_expressions(conjuncts):
    assert len(conjuncts) > 0

    if len(conjuncts) == 1:
        return conjuncts[0]

    res = conjuncts[0]
    for c in conjuncts[1:]:
        res = BinOp('*', res, c)

    return res