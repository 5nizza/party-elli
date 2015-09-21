from parsing.visitor import Visitor
from interfaces.expr import BinOp, UnaryOp, Signal, Number


class SignalsChecker(Visitor):
    def __init__(self, known_signals):
        self._known_signals = known_signals
        self.unknown_signal = None

    def visit_binary_op(self, binary_op:BinOp):
        if not self.unknown_signal:
            self.dispatch(binary_op.arg1)
        if not self.unknown_signal:
            self.dispatch(binary_op.arg2)

    def visit_signal(self, signal:Signal):
        if signal not in self._known_signals:
            self.unknown_signal = signal


def check_unknown_signals_in_properties(property_asts, known_signals):
    signals_checker = SignalsChecker(known_signals)
    for a in property_asts:
        signals_checker.dispatch(a)
        if signals_checker.unknown_signal:
            error_str = 'found unknown signal "{signal}" in property "{ast}"\nknown_signals are {known}'.format(
                signal=str(signals_checker.unknown_signal),
                ast=str(a),
                known=str(known_signals))

            return error_str
