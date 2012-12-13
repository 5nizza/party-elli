class Signal:
    def __init__(self, name):
        self.name = name

    def __repr__(self):
        return str(self.name)


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
        self._arg1 = arg1
        self._arg2 = arg2
    def __repr__(self):
        return str(self._arg1) + ' ' + self.name + ' ' + str(self._arg2)


class UnaryOp(Expr):
    def __init__(self, name, arg):
        super().__init__(name)
        self._arg = arg
    def __repr__(self):
        return self.name + str(self._arg)


class QuantifiedExpr(BinOp):
    def __init__(self, name, arg1:'binding indices', arg2:Expr):
        super().__init__(name, arg1, arg2)

    def __str__(self):
        return self.name + str(self._arg1) + ' ' + str(self._arg2)

    __repr__ = __str__
