class Signal:
    def __init__(self, name:str):
        self.name = name
        self.__hash_value = hash(self.name)

    def __repr__(self):
        return str(self.name)

    def __eq__(self, other):
        if not isinstance(other, Signal):
            return False
        return self.name == other.name

    def __hash__(self):
        return self.__hash_value


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
    def __init__(self, name:str):
        self.name = name  # type:str

    def __repr__(self):
        return str(self.name)

    def __hash__(self):
        return hash(str(self))

    def __eq__(self, other):
        if other is None:
            return False
        assert issubclass(other.__class__, Expr), str(other.__class__)
        return str(self) == str(other)

    def __and__(self, other) -> 'Expr':
        if self == Bool(True):
            return other
        if other == Bool(True):
            return self
        if other == Bool(False) or self == Bool(False):
            return Bool(False)
        return BinOp('*', self, other)

    def __iand__(self, other) -> 'Expr':
        return self & other

    def __or__(self, other) -> 'Expr':
        if self == Bool(False):
            return other
        if other == Bool(False):
            return self
        if other == Bool(True) or self == Bool(True):
            return Bool(True)
        return BinOp('+', self, other)

    def __ior__(self, other) -> 'Expr':
        return self | other

    def __invert__(self) -> 'Expr':
        if self == Bool(True) or self == Bool(False):
            return Bool(self == Bool(False))  # false becomes true
        return UnaryOp('!', self)

    def __rshift__(self, other) -> 'Expr':
        return ~self | other


class Bool(Expr):
    def __init__(self, value):
        assert isinstance(value, bool)

        super().__init__(str(value))

    def __repr__(self):
        return self.name


class BinOp(Expr):
    def __init__(self, name:str, arg1, arg2):
        """ @:param name:
                logical (*+=), temporal (U, W(?), R(?)),
                but sometimes other flavours appear """
        super().__init__(name)
        assert arg1
        assert arg2
        self.arg1 = arg1
        self.arg2 = arg2

    def __repr__(self):
        if self.name != '=':
            return str(self.arg1) + ' ' + self.name + ' ' + str(self.arg2)
        else:
            return str(self.arg1) + '=' + str(self.arg2)

    @staticmethod
    def W(arg1, arg2):
        return BinOp('W', arg1, arg2)


class UnaryOp(Expr):
    def __init__(self, name, arg):
        super().__init__(name)
        self.arg = arg

    def __repr__(self):
        return self.name + '({0})'.format(self.arg)

    def __invert__(self) -> 'Expr':
        if self.name == '!':
            return self.arg  # cancel out double negations
        return super().__invert__()

    @staticmethod
    def G(a):
        return UnaryOp('G', a)
