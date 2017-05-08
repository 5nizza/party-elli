from interfaces.expr import BinOp, UnaryOp
from parsing.visitor import Visitor


class NNFNormalizer(Visitor):
    """
    Translate the formula into positive normal form.
    Uses Release operator!
    """

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
