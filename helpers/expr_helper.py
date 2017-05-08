from typing import Tuple, Set

from interfaces.expr import BinOp, Signal, Number, Expr, Bool
from parsing.visitor import Visitor


def get_sig_number(binary_op:BinOp) -> Tuple[Signal, Number]:
    assert binary_op.name == '=', str(binary_op)
    sig_arg, number_arg = binary_op.arg1, binary_op.arg2
    if not isinstance(sig_arg, Signal):
        sig_arg, number_arg = number_arg, sig_arg
    return sig_arg, number_arg


def get_signals(e:Expr) -> Set[Signal]:
    class SignalsCollectorVisitor(Visitor):
        def __init__(self):
            self.signals = set()  # type: Set[Signal]

        def visit_signal(self, signal:Signal):
            self.signals.add(signal)
            return super().visit_signal(signal)
    # end of NamesCollectorVisitor

    collector = SignalsCollectorVisitor()
    collector.dispatch(e)
    return collector.signals


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