from functools import lru_cache
from itertools import chain
from helpers.automata_helper import is_safety_automaton
from interfaces.spec import SpecProperty
from parsing.helpers import Visitor, ConverterToLtl2BaFormatVisitor
from parsing.interface import ForallExpr, BinOp, Signal, Expr, Bool, QuantifiedSignal, UnaryOp


@lru_cache()
def is_safety(expr:Expr, ltl2ba_converter) -> bool:
    expr_to_ltl2ba_converter = ConverterToLtl2BaFormatVisitor()
    ltl2ba_formula = expr_to_ltl2ba_converter.dispatch(expr)
    automaton = ltl2ba_converter.convert(ltl2ba_formula)
    return is_safety_automaton(automaton)


def get_rank(expr) -> int:
    if not isinstance(expr, ForallExpr):
        return 0

    #: :type: ForallExpr
    expr = expr
    return len(expr.arg1)


def normalize_conjuncts(expressions:list) -> Expr:
    """ sound, complete
    forall(i,j) a_i_j and forall(i) b_i  ----> forall(i,j) (a_i_j and b_i)
    forall(i) a_i and forall(j) b_j      ----> forall(i) (a_i and b_i)
    """
    if len(expressions) == 0:
        return Bool(True)

    if len(expressions) == 1 and isinstance(expressions[0], Bool):
        return expressions[0]

    for e in expressions:
        assert isinstance(e, ForallExpr), 'global non-parameterized properties are not supported'

    max_indices = max(expressions, key=lambda e: len(e.arg1))
    new_indices = max_indices.arg1

    normalized_underlying_expr = None
    for e in expressions:
        assert isinstance(e, ForallExpr), 'global non-parameterized properties are not supported'
        old_indices = e.arg1
        new_by_old = dict((o,new_indices[i]) for i, o in enumerate(old_indices))

        new_underlying_e = _replace_indices(new_by_old, e.arg2)

        if normalized_underlying_expr is None:
            normalized_underlying_expr = new_underlying_e
        else:
            normalized_underlying_expr = BinOp('*', normalized_underlying_expr, new_underlying_e)

    normalized_expr = ForallExpr(new_indices, normalized_underlying_expr)
    return normalized_expr


class SignalsReplacerVisitor(Visitor):
    def __init__(self, new_by_old_index:dict):
        super().__init__()
        self._new_by_old_index = new_by_old_index


    def visit_signal(self, signal:Signal):
        if not isinstance(signal, QuantifiedSignal):
            return signal

        #noinspection PyUnresolvedReferences
        old_indices = signal.binding_indices
        print('dispatching the signal ', str(signal))
        print(old_indices)
        print(self._new_by_old_index)
        new_indices = tuple(self._new_by_old_index[i] for i in old_indices)

        new_signal = QuantifiedSignal(signal.name, new_indices)
        return new_signal


    def _get_index_name(self, signal:QuantifiedSignal)-> (int, str):
        old_indices = self._new_by_old_index.keys()
        for index in old_indices:
            if signal.name.endswith('_'+index):
                original_name = '_'.join(signal.name.split('_')[:-2])
                return index, original_name

        return None, None



def _replace_indices(newindex_by_oldindex:dict, expr):
    if len(newindex_by_oldindex) == 0:
        return expr

    if not isinstance(expr, ForallExpr):
        return expr

    assert len(expr.arg1) <= len(set(newindex_by_oldindex.values()))

    underlying_expr = expr.arg2

    print()
    print(underlying_expr)

    replacer = SignalsReplacerVisitor(newindex_by_oldindex)
    replaced_expr = replacer.dispatch(underlying_expr)
    print(replaced_expr)

    return replaced_expr


def instantiate_exprs(expressions, size):
    assert 0


def _get_indices(normalized_ass:Expr):
    if isinstance(normalized_ass, ForallExpr):
        return normalized_ass.arg1
    else:
        return []


def _is_quantified_property(property:SpecProperty) -> Bool: #TODO: does not allow embedded forall quantifiers
    for i in property.assumptions + property.guarantees:
        if isinstance(i, ForallExpr):
            return True
        else:
            assert i.__class__ in [ForallExpr, BinOp, UnaryOp, Bool], 'unknown class'

    return False


def localize(property:SpecProperty):
    """ sound, but incomplete """
    ## forall(i) a_i -> forall(j) g_j
    # forall(i) (a_i -> g_i)
    ## forall(i,j) a_i_j -> forall(k) g_k
    # forall(i,j) (a_i_j -> g_i)
    ## forall(i) a_i -> forall(k,m) g_k_m
    #
    ## forall(i,j) a_i_j -> forall(k,m) g_k_m

    if not _is_quantified_property(property):
        return property

    normalized_ass = normalize_conjuncts(property.assumptions)
    normalized_gua = normalize_conjuncts(property.guarantees)

    binding_indices_ass = _get_indices(normalized_ass)
    binding_indices_gua = _get_indices(normalized_gua)

    if len(binding_indices_ass) > len(binding_indices_gua):
        max_expr, other_expr = normalized_ass, normalized_gua
    else:
        max_expr, other_expr = normalized_gua, normalized_ass

    if isinstance(max_expr, ForallExpr):
        max_binding_indices = max_expr.arg1
    else:
        max_binding_indices = []

    ass_newindex_by_old = dict((o, max_binding_indices[i]) for i,o in enumerate(binding_indices_ass))
    gua_newindex_by_old = dict((o, max_binding_indices[i]) for i,o in enumerate(binding_indices_gua))

    print('ass')
    print(normalized_ass)
    print(binding_indices_ass)
    print(ass_newindex_by_old)
    replaced_underlying_ass = _replace_indices(ass_newindex_by_old, normalized_ass)
    print('gua')
    print(normalized_gua)
    print(binding_indices_gua)
    print(gua_newindex_by_old)
    replaced_underlying_gua = _replace_indices(gua_newindex_by_old, normalized_gua)

    new_gua = ForallExpr(max_binding_indices,
                         BinOp('->', replaced_underlying_ass, replaced_underlying_gua))

    new_property = SpecProperty([Bool(True)], [new_gua])

    return new_property


def _get_conjuncts(conjunction_expr:Expr) -> list:
    if not isinstance(conjunction_expr, BinOp):
        return [conjunction_expr]

    if not conjunction_expr.name == '*':
        return [conjunction_expr]

    conjuncts = list(chain(_get_conjuncts(conjunction_expr.arg1), _get_conjuncts(conjunction_expr.arg2)))
    return conjuncts


class QuantifiedSignalsFinderVisitor(Visitor):
    def __init__(self):
        self.quantified_signals = set()

    def visit_signal(self, signal:Signal):
        if isinstance(signal, QuantifiedSignal):
            self.quantified_signals.add(signal)
        return super().visit_signal(signal)


def _reduce_quantifiers(expr:ForallExpr) -> Expr:
    """ Remove useless binding indices """
    quantified_signals_finder = QuantifiedSignalsFinderVisitor()
    quantified_signals_finder.dispatch(expr)
    quantified_signals = quantified_signals_finder.quantified_signals

    indices_used = set(chain(*[qs.binding_indices for qs in quantified_signals]))

    return ForallExpr(indices_used, expr.arg2)


def _denormalize(conjunct:Expr) -> list:
    """
    Forall(i) a_i and b_i
    replaced by
    Forall(i) a_i and Forall(i) b_i
    """

    normalized_conjunct = normalize_conjuncts([conjunct])

    if not _is_quantified_property(SpecProperty([normalized_conjunct], [])):
        return normalized_conjunct

    #: :type: ForallExpr
    forall_expr = conjunct
    quantified_expr = forall_expr.arg2

    conjunctions = _get_conjuncts(quantified_expr)

    return [_reduce_quantifiers(ForallExpr(forall_expr.arg1, c))
            for c in conjunctions]


def _get_denormalized_property(property:SpecProperty) -> list:
    """
    Property assumption may be of the form: forall(i) (safety_i and liveness_i)
    we introduce 'forall(i)' for each safety_i and liveness_i and therefore get:
    forall(i) safety_i and forall(i) liveness_i
    """

    denormalized_props = []

    denormalized_assumptions = list(chain(*[_denormalize(a) for a in property.assumptions]))
    denormalized_guarantees = list(chain(*[_denormalize(g) for g in property.guarantees]))
    for g in denormalized_guarantees:
        new_p = SpecProperty(denormalized_assumptions, [g])
        denormalized_props.append(new_p)

    return denormalized_props


def strengthen(property:SpecProperty, ltl2ucw_converter) -> (list, list):
    """
    Return:
        'safety' properties (a_s -> g_s),
        'liveness' properties (a_s and a_l -> g_l)
    Also removes ground variables that becomes useless.
    """

    safety_properties = []
    liveness_properties = []

    denormalized_props = _get_denormalized_property(property)
    for p_ in denormalized_props:
        #: :type: SpecProperty
        p = p_

        safety_ass = normalize_conjuncts([a for a in p.assumptions if is_safety(a, ltl2ucw_converter)])
        all_ass = normalize_conjuncts(p.assumptions)

        safety_guarantees = [g for g in p.guarantees if is_safety(g, ltl2ucw_converter)]
        liveness_guarantees = [g for g in p.guarantees if not is_safety(g, ltl2ucw_converter)]

        safety_properties += [SpecProperty([safety_ass], [sg])
                             for sg in safety_guarantees]
        liveness_properties += [SpecProperty([all_ass], [lg])
                               for lg in liveness_guarantees]

    return safety_properties, liveness_properties
