from functools import lru_cache
from itertools import chain, product
from helpers.automata_helper import is_safety_automaton
from helpers.python_ext import index_of
from interfaces.spec import SpecProperty
from parsing.helpers import Visitor, ConverterToLtl2BaFormatVisitor
from interfaces.parser_expr import ForallExpr, BinOp, Signal, Expr, Bool, QuantifiedSignal, UnaryOp, and_expressions
from parsing.par_parser import QuantifiedSignalsFinderVisitor


def _get_indices(normalized_ass:Expr):
    if not _is_quantified_expr(normalized_ass):
        return []

    assert isinstance(normalized_ass, ForallExpr)
    return normalized_ass.arg1


def _is_quantified_property(property:SpecProperty) -> Bool: #TODO: does not allow embedded forall quantifiers
    """ Return True iff the property has quantified indices.
        Numbers cannot be used as quantification indices.
    """
    for e in property.assumptions + property.guarantees:
        if isinstance(e, ForallExpr):
            binding_indices = e.arg1
            if index_of(lambda bi: isinstance(bi, str), binding_indices) is not None:
                return True
        else:
            assert e.__class__ in [ForallExpr, BinOp, UnaryOp, Bool], 'unknown class'

    return False


def _is_quantified_expr(expr:Expr):
    return _is_quantified_property(SpecProperty([], [expr]))


@lru_cache()
def is_safety(expr:Expr, ltl2ba_converter) -> bool:
    print('is: is_safety')
    print('is:', expr)

    expr_to_ltl2ba_converter = ConverterToLtl2BaFormatVisitor()
    ltl2ba_formula = expr_to_ltl2ba_converter.dispatch(expr)
    automaton = ltl2ba_converter.convert(ltl2ba_formula)
    res = is_safety_automaton(automaton)
    print('is: res =', res)
    print()
    return res


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

    def _replace(self, old_indices):
        new_indices = []
        for i in old_indices:
            new = self._new_by_old_index.get(i, i)
            new_indices.append(new)

        return new_indices


    def visit_tuple(self, indices:tuple):
        new_indices = self._replace(indices)
        return new_indices


    def visit_signal(self, signal:Signal):
        if not isinstance(signal, QuantifiedSignal):
            return signal

        #noinspection PyUnresolvedReferences
        new_indices = self._replace(signal.binding_indices)

        new_signal = QuantifiedSignal(signal.name, *new_indices)
        return new_signal


    def _get_index_name(self, signal:QuantifiedSignal)-> (int, str):
        old_indices = self._new_by_old_index.keys()
        for index in old_indices:
            if signal.name.endswith('_'+index):
                original_name = '_'.join(signal.name.split('_')[:-2])
                return index, original_name

        return None, None


def _replace_indices(newindex_by_oldindex:dict, expr:Expr):
    if len(newindex_by_oldindex) == 0:
        return expr

    replacer = SignalsReplacerVisitor(newindex_by_oldindex)
    replaced_expr = replacer.dispatch(expr)

    return replaced_expr


def _fix_indices(value_by_index:dict, expr:Expr):
    """ if 'index' is not in the value_by_index therefore leave it as is """

    if not _is_quantified_expr(expr):
        return expr

    newindex_by_oldindex = dict((i,i) for i in _get_indices(expr))
    newindex_by_oldindex.update(value_by_index)

    replaced_expr = _replace_indices(newindex_by_oldindex, expr)

    indices = _get_indices(replaced_expr)
    new_indices = list(filter(lambda i: isinstance(i, str), indices))

    if len(new_indices) == 0:
        return replaced_expr.arg2
    else:
        assert isinstance(expr, ForallExpr)
        return ForallExpr(new_indices, replaced_expr.arg2)


def localize(property:SpecProperty):
    """ sound, but incomplete
    forall(i) a_i -> forall(j) g_j
    =>
    forall(i) (a_i -> g_i)

    forall(i,j) a_i_j -> forall(k) g_k
    =>
    forall(i,j) (a_i_j -> g_i)
    """

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

    assert isinstance(max_expr, ForallExpr)

    max_binding_indices = max_expr.arg1

    ass_newindex_by_old = dict((o, max_binding_indices[i]) for i,o in enumerate(binding_indices_ass))
    gua_newindex_by_old = dict((o, max_binding_indices[i]) for i,o in enumerate(binding_indices_gua))

    replaced_ass = _replace_indices(ass_newindex_by_old, normalized_ass)
    replaced_gua = _replace_indices(gua_newindex_by_old, normalized_gua)

    replaced_underlying_ass = replaced_ass.arg2 if _is_quantified_expr(replaced_ass) else replaced_ass
    replaced_underlying_gua = replaced_gua.arg2 if _is_quantified_expr(replaced_gua) else replaced_gua

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
        return [normalized_conjunct]

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
        print('stre: p=', p_)
        #: :type: SpecProperty
        p = p_

        safety_ass = normalize_conjuncts([a for a in p.assumptions if is_safety(a, ltl2ucw_converter)])
        print('stre: ==================== safety_ass=', safety_ass)

        all_ass = normalize_conjuncts(p.assumptions)

        safety_guarantees = [g for g in p.guarantees if is_safety(g, ltl2ucw_converter)]
        print('stre: ==================== safety_gua=', '\n'.join(map(str,safety_guarantees)))
        liveness_guarantees = [g for g in p.guarantees if not is_safety(g, ltl2ucw_converter)]

        safety_properties += [SpecProperty([safety_ass], [sg])
                             for sg in safety_guarantees]
        liveness_properties += [SpecProperty([all_ass], [lg])
                               for lg in liveness_guarantees]

    return safety_properties, liveness_properties


def _instantiate_expr(expr:Expr, cutoff) -> Expr:
    if not _is_quantified_expr(expr):
        return expr

    binding_indices = _get_indices(expr)
    index_values_tuples = list(product(range(cutoff), repeat=len(binding_indices)))

    expressions = []
    for index_values in index_values_tuples:
        value_by_index = dict((binding_indices[i],v) for i,v in enumerate(index_values))
        expr_with_fixed_indices = _fix_indices(value_by_index, expr)
        expressions.append(expr_with_fixed_indices)

    expressions_conjuncted = and_expressions(expressions)
    return expressions_conjuncted


def _fix_one_index(expr:Expr) -> Expr:
    if not _is_quantified_expr(expr):
        return expr

    binding_indices = _get_indices(expr)

    #TODO: special case of QuantifiedSignal? -- no, the same QuantifiedSignal with numbers instead of letters
    value_by_index = dict([(binding_indices[0], 0)])

    expr_with_fixed_index = _fix_indices(value_by_index, expr)

    return expr_with_fixed_index


def inst_properties(archi, properties):
    """
    forall(i,j) a_i_j -> forall(k) b_k
    =
    (!a_0_0 + !a_0_1 + !a_1_0 + !a_1_1 + ..) + (b_0*b_1*b_2..)
    where maximum values of i,j,k are defined by the cutoff size.

    We optimize instantiations of guarantees by fixing one of the indices. E.g.:
    forall(i,j) a_i_j -> forall(k) b_k
    ~
    forall(i,j) a_i_j -> b_0
    (this is due to isomorphism of processes, TODO: make formal proof)


    NOTE on quantifier reordering:
    In the example above we can reorder quantifiers:
    forall exists (a+b) = exists forall (a+b)

    But in a general case it is not possible to reorder quantifiers --
    it depends on the formula quantified. E.g.:
    forall(k) exists(l) (a_k XOR b_l)
    !=
    exists(l) forall(k) (a_k XOR b_l)


    NOTE on 'forall instantiation' optimization:
    In the case above we can reorder quantifiers, and we assume that for the formulas of the form
     forall(i) a_i
     it is enough to verify a_0 (this assumption is due to symmetry, TODO: prove).
     Therefore we can instantiate only one guarantee:
     forall(i,j) a_i_j -> forall(i) b_i
     ~
     forall(i,j) a_i_j -> b_0
    """
    #TODO: bug: handle scheduler properties _specially

    prop_cutoff_pairs = []
    for p in properties:
        cutoff = archi.get_cutoff(get_rank(p))

        assumptions = p.assumptions
        guarantees = _fix_one_index(p.guarantees)

        inst_assumptions = [_instantiate_expr(a, cutoff) for a in assumptions]
        inst_guarantees = [_instantiate_expr(g, cutoff) for g in guarantees]

        inst_p = SpecProperty(inst_assumptions, inst_guarantees)
        prop_cutoff_pairs.append((inst_p, cutoff))

    return prop_cutoff_pairs




















