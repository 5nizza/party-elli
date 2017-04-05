from typing import Tuple

from interfaces.expr import Signal, BinOp, Bool, Number


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


def get_sig_number(binary_op:BinOp) -> Tuple[Signal, Number]:
    assert binary_op.name == '=', str(binary_op)
    sig_arg, number_arg = binary_op.arg1, binary_op.arg2
    if not isinstance(sig_arg, Signal):
        sig_arg, number_arg = number_arg, sig_arg
    return sig_arg, number_arg
