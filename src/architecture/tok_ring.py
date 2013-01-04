from interfaces.parser_expr import UnaryOp, QuantifiedSignal, BinOp, ForallExpr

SENDS_NAME_MY, SENDS_PREV_NAME_MY, HAS_TOK_NAME_MY= 'sends', 'prev', 'tok'


class TokRingArchitecture:
    @property
    def spec_rank(self): #TODO: dirty
        return 1

    def guarantees(self):
        #TODO: dirty -- introduce Globally/Finally class
        expr = UnaryOp('G', BinOp('->', QuantifiedSignal(HAS_TOK_NAME_MY, 'i'),
            UnaryOp('F', QuantifiedSignal(SENDS_NAME_MY, 'i'))))
        tok_released = ForallExpr(['i'], expr)
        return [tok_released]

    def implications(self):
        expr = UnaryOp('G', UnaryOp('F', QuantifiedSignal(HAS_TOK_NAME_MY, 'i')))
        fair_tok_sched = ForallExpr(['i'], expr)
        return [fair_tok_sched]

    def get_cutoff(self, rank:int):
        assert 0
