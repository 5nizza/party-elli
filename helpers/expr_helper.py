from typing import Set, Tuple

from interfaces.expr import Signal, Expr, BinOp, Bool, UnaryOp, Number
from parsing.visitor import Visitor


def get_signal_names(e:Expr) -> Set[str]:
    class NamesCollectorVisitor(Visitor):
        def __init__(self):
            self.names = set()

        def visit_signal(self, signal:Signal):
            self.names.add(signal.name)
            return super().visit_signal(signal)
    # end of NamesCollectorVisitor

    collector = NamesCollectorVisitor()
    collector.dispatch(e)
    return collector.names


def and_expr(conjuncts):
    conjuncts = [c for c in conjuncts if c != Bool(True)]

    if len(conjuncts) == 0:
        return Bool(True)

    if len(conjuncts) == 1:
        return conjuncts[0]

    res = conjuncts[0]
    for c in conjuncts[1:]:
        res &= c

    return res


class PropNormalizer(Visitor):  # TODO: remove? (not used)
    """ Translate 'sig=0' into '!(sig=1)' """

    def visit_binary_op(self, binary_op: BinOp):
        if binary_op.name != '=':
            return super().visit_binary_op(binary_op)

        # translate sig=0 into !(sig=1)
        sig_arg, number_arg = binary_op.arg1, binary_op.arg2
        if not isinstance(sig_arg, Number):
            sig_arg, number_arg = number_arg, sig_arg

        assert number_arg in (Number(0), Number(1)), str(number_arg)

        if number_arg == Number(0):
            return ~BinOp('=', sig_arg, Number(1))
        return binary_op
    #
# end of PropNormalizer


class Normalizer(Visitor):
    """ Translate the formula into the normalized form. """

    def _get_dual_op_name(self, op_name:str) -> str:
        mapping = (
            ('A', 'E'),
            ('G', 'F'),
            ('U', 'R'),
            ('*', '+'),
            ('X', 'X'),
            ('=', '=')
        )
        mapping_dict = dict(mapping +
                            tuple(map(lambda a_b: (a_b[1], a_b[0]), mapping)))
        return mapping_dict[op_name]

    def visit_unary_op(self, unary_op:UnaryOp):
        if unary_op.name != '!':
            return UnaryOp(unary_op.name, self.dispatch(unary_op.arg))

        # Check if the negation is in front of the proposition...
        arg = unary_op.arg
        if arg.name == '=':
            return unary_op

        # ... and if not, then propagate the negation downwards:
        if arg.name in 'UR*+':
            return BinOp(self._get_dual_op_name(arg.name),
                         self.dispatch(~arg.arg1),
                         self.dispatch(~arg.arg2))

        if arg.name in 'AEGFX':
            return UnaryOp(self._get_dual_op_name(arg.name),
                           self.dispatch(~arg.arg))

        assert 0, str(unary_op)

    def visit_signal(self, signal): return signal
    def visit_number(self, number): return number
# end of Normalizer


def get_sig_number(binary_op:BinOp) -> Tuple[Signal, Number]:
    assert binary_op.name == '=', str(binary_op)
    sig_arg, number_arg = binary_op.arg1, binary_op.arg2
    if not isinstance(sig_arg, Signal):
        sig_arg, number_arg = number_arg, sig_arg
    return sig_arg, number_arg
