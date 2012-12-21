class Signal:
    def __init__(self, name):
        self.name = name

    def __repr__(self):
        return str(self.name)

    def __eq__(self, other):
        if not isinstance(other, Signal):
            return False
        return str(self) == str(other)


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
        return str(self.arg1) + ' ' + self.name + ' ' + str(self.arg2)


class UnaryOp(Expr):
    def __init__(self, name, arg):
        super().__init__(name)
        self.arg = arg
    def __repr__(self):
        return self.name + str(self.arg)


class ForallExpr(BinOp):
    def __init__(self, binding_indices:'binding indices', expr:Expr):
        super().__init__('Forall', binding_indices, expr)

    def __str__(self):
        return self.name + str(self.arg1) + ' ' + str(self.arg2)

    __repr__ = __str__

