from interfaces.parser_expr import UnaryOp, QuantifiedSignal, BinOp, ForallExpr, Number, Bool, is_quantified_property, Expr
from interfaces.spec import SpecProperty

SENDS_NAME, SENDS_PREV_NAME, HAS_TOK_NAME= 'sends', 'prev', 'tok'


def is_quantified_expr(expr:Expr):
    return is_quantified_property(SpecProperty([], [expr]))


def _assert_no_single_concrete(expressions):
    if len(expressions) != 1:
        return

    e = expressions[0]
    if e in [Bool(True), Bool(False)]:
        return

    if is_quantified_expr(e):
        return

    assert 0, 'single concrete assumptions/guarantees are not supported now: ' + str(e)


def _get_rank(property:SpecProperty) -> int:
    if not is_quantified_property(property):
        return 0

    #forall(i) a_i -> g_0
    # since the initial token distribution is random
    # <=>
    #forall(i) a_i -> forall(i) g_i, which is 2-indexed

    # a_0 -> forall(i) g_i
    # <=> ???
    # (exists(i) a_i) -> forall(i) g_i, which is 2-indexed
    #
    # Currently we forbid concrete assumptions/guarantees

    ass_max_len = max(map(lambda e: len(e.arg1) if is_quantified_expr(e) else 0, property.assumptions))
    gua_max_len = max(map(lambda e: len(e.arg1) if is_quantified_expr(e) else 0, property.guarantees))
    rank = ass_max_len + gua_max_len

    return rank


class TokRingArchitecture:
    def guarantees(self):
        #TODO: introduce Globally/Finally class
        expr = UnaryOp('G',
            BinOp('->',
                BinOp('=', QuantifiedSignal(HAS_TOK_NAME, 'i'), Number(1)),
                UnaryOp('F', BinOp('=', QuantifiedSignal(SENDS_NAME, 'i'), Number(1)))))

        tok_released = ForallExpr(['i'], expr)
        return [tok_released]

    def implications(self):
        expr = UnaryOp('G', UnaryOp('F', BinOp('=',
            QuantifiedSignal(HAS_TOK_NAME, 'i'),
            Number(1))))
        fair_tok_sched = ForallExpr(['i'], expr)
        return [fair_tok_sched]


    def get_cutoff(self, property:SpecProperty):
        _assert_no_single_concrete(property.assumptions) #TODO: put it somewhere else
        _assert_no_single_concrete(property.guarantees)  #TODO: put it somewhere else

        rank = _get_rank(property)

        return 2*rank



