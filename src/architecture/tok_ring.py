from interfaces.parser_expr import UnaryOp, QuantifiedSignal, BinOp, ForallExpr, Number

SENDS_NAME_MY, SENDS_PREV_NAME_MY, HAS_TOK_NAME_MY= 'sends', 'prev', 'tok'


class TokRingArchitecture:
    @property
    def spec_rank(self): #TODO: dirty
        return 1

    def guarantees(self):
        #TODO: dirty -- introduce Globally/Finally class
        expr = UnaryOp('G',
            BinOp('->',
                BinOp('=', QuantifiedSignal(HAS_TOK_NAME_MY, 'i'), Number(1)),
                UnaryOp('F', BinOp('=', QuantifiedSignal(SENDS_NAME_MY, 'i'), Number(1)))))

        tok_released = ForallExpr(['i'], expr)
        return [tok_released]

    def implications(self):
        expr = UnaryOp('G', UnaryOp('F', BinOp('=',
            QuantifiedSignal(HAS_TOK_NAME_MY, 'i'),
            Number(1))))
        fair_tok_sched = ForallExpr(['i'], expr)
        return [fair_tok_sched]

    def get_cutoff(self, rank:int):
        return 2*rank
