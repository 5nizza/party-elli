from collections import defaultdict, Iterable
from functools import lru_cache
from itertools import chain, permutations
import logging
import math
from architecture.scheduler import InterleavingScheduler, ACTIVE_NAME
from helpers.automata_helper import is_safety_automaton
from helpers.console_helpers import print_green, print_red
from helpers.python_ext import bin_fixed_list, separate, add_dicts
from interfaces.spec import SpecProperty
from parsing.visitor import Visitor
from interfaces.parser_expr import ForallExpr, BinOp, Signal, Expr, Bool, QuantifiedSignal, and_expressions, Number, \
    is_quantified_property, UnaryOp
from parsing.par_lexer_desc import PAR_GUARANTEES
from parsing.par_parser import QuantifiedSignalsFinderVisitor
from parsing.par_parser_desc import par_parser


# TODO: split into several files
from synthesis import smt_helper
from synthesis.func_description import FuncDescription
from synthesis.gr1_encoder import _next


def is_quantified_expr(expr:Expr):
    return is_quantified_property(SpecProperty([], [expr]))


def _get_indices(normalized_ass:Expr):
    if not is_quantified_expr(normalized_ass):
        return []

    assert isinstance(normalized_ass, ForallExpr)
    return normalized_ass.arg1


@lru_cache()
def is_safety(expr:Expr, ltl2ba_converter) -> bool:
    automaton = ltl2ba_converter.convert(expr)
    res = is_safety_automaton(automaton)
    return res


def _is_propositional(a):
    class Found(BaseException):
        pass

    class TemporalOperatorFinder(Visitor):
        def visit_binary_op(self, binary_op:BinOp):
            if binary_op.name in ['W', 'U']:
                raise Found()  # interrupts immediately
            return BinOp(binary_op.name, self.dispatch(binary_op.arg1), self.dispatch(binary_op.arg2))

        def visit_unary_op(self, unary_op:UnaryOp):
            if unary_op.name in ['G', 'F']:
                raise Found()  # interrupts immediately
            return UnaryOp(unary_op.name, self.dispatch(unary_op.arg))

    try:
        TemporalOperatorFinder().dispatch(a)
        return True
    except Found:
        return False


def _split_conjuncts(expr:Expr) -> list:
    if expr.name != '*':
        return [expr]
    return _split_conjuncts(expr.arg1) + _split_conjuncts(expr.arg2)


def _add_quantifiers(expr_with_free_vars:Expr):
    quantified_signals = QuantifiedSignalsFinderVisitor().find_quantified_signals(expr_with_free_vars)
    indices = set()
    for qs in quantified_signals:
        indices.update(set(qs.binding_indices))

    return ForallExpr(indices, expr_with_free_vars)


def param_optimize_assume_guarantee(expr:Expr, ltl2ucw_converter, return_formulae_for_gr1:bool) -> (list, Expr, Expr):
    """
    This version returns env_ass_funcs, env_gua_funcs instead of turning them into properties.
    """
    if expr == Bool(True) or expr == Bool(False):
        return expr

    assert isinstance(expr, ForallExpr), str(expr.name)

    implication = expr.arg2
    assert implication.name == '->', str(implication.name)

    assumptions = _split_conjuncts(implication.arg1)
    if assumptions == [Bool(True)]:
        assumptions = []
    guarantees = _split_conjuncts(implication.arg2)

    init_ass, init_gua, saf_ass, saf_gua, liv_ass, liv_gua = extract_spec_components(assumptions, guarantees, ltl2ucw_converter)
    interm_properties, env_ass_formula, sys_gua_formula = optimize_assume_guarantee(init_ass, init_gua,
                                                                                    saf_ass, saf_gua,
                                                                                    liv_ass, liv_gua,
                                                                                    return_formulae_for_gr1)
    env_ass_formula = _add_quantifiers(env_ass_formula)
    sys_gua_formula = _add_quantifiers(sys_gua_formula)

    properties = []
    for p in interm_properties:
        new_expr = BinOp('->', and_expressions(p.assumptions), and_expressions(p.guarantees))
        new_p = SpecProperty([], [_add_quantifiers(new_expr)])
        properties.append(new_p)

    return properties, env_ass_formula, sys_gua_formula


def extract_spec_components(assumptions, guarantees, ltl2ucw_converter) -> (list, list, list, list):
    init_ass, init_gua, safe_ass, safe_gua, live_ass, live_gua = [], [], [], [], [], []
    # init is:
    # - safety
    # - does not have temporal operators inside
    # safe is:
    # - is safety and not init
    # live is:
    # - the rest..
    for a in assumptions:
        if is_safety(a, ltl2ucw_converter):
            if _is_propositional(a):
                init_ass.append(a)
            else:
                safe_ass.append(a)
        else:
            live_ass.append(a)

    for g in guarantees:
        if is_safety(g, ltl2ucw_converter):
            if _is_propositional(g):
                init_gua.append(g)
            else:
                safe_gua.append(g)
        else:
            live_gua.append(g)

    return init_ass, init_gua, safe_ass, safe_gua, live_ass, live_gua


def _neg(expr):
    if expr == Bool(True):
        return Bool(False)
    if expr == Bool(False):
        return Bool(True)

    return UnaryOp('!', expr)


def _weak_until(guarantee, not_assumption):
    if not_assumption == Bool(False):
        return UnaryOp('G', guarantee)

    if not_assumption == Bool(True):
        return Bool(True)

    if guarantee == Bool(True):
        return guarantee

    return BinOp('W', guarantee, not_assumption)


class FindAllTemporalOperatorsVisitor(Visitor):
    def __init__(self):
        self.temporal_operators = set()

    def visit_binary_op(self, binary_op:BinOp):
        if binary_op.name in ['W', 'U']:
            self.temporal_operators.add(binary_op.name)

        return super().visit_binary_op(binary_op)

    def visit_unary_op(self, unary_op:UnaryOp):
        if unary_op.name in ['G','F', 'X']:
            self.temporal_operators.add(unary_op.name)

        return super().visit_unary_op(unary_op)

    @staticmethod
    def find_temporal_operators(expr:Expr) -> set:
        impl = FindAllTemporalOperatorsVisitor()
        impl.dispatch(expr)
        return impl.temporal_operators


def _is_ag2(expr:Expr):
    """ Returns True for properties of the form G(bool_formula_without_temporal_operators)

    >>> _is_ag2(parse_expr('G(a=1)'))
    True
    """
    if not expr.name == 'G' or FindAllTemporalOperatorsVisitor.find_temporal_operators(expr.arg) != set():
        return False
    return True


def _is_ag(expr:Expr):
    """ not precise -- it accepts more than just G(..->X..), e.g. it accepts G(a->Xb&XXb)

    >>> _is_ag(parse_expr('G(a=1->X(b=1))'))
    True
    >>> _is_ag(parse_expr('G(a=1->(b=1))'))
    True
    >>> _is_ag(parse_expr('G(a=1 W b=1)'))
    False
    """

    if not expr.name == 'G':
        return False

    stripped = expr.arg

    temporal_ops = FindAllTemporalOperatorsVisitor.find_temporal_operators(stripped)
    if temporal_ops == set() or temporal_ops == {'X'}:
        return True

    return False


class ExprToSmtFormulaVisitor(Visitor):
    def __init__(self):
        self._should_prime = False
        self.max_depth = 0
        self._crt_depth = 0

    def visit_unary_op(self, unary_op:UnaryOp):
        if unary_op.name == 'X':
            self._should_prime = True
            self._crt_depth += 1
            self.max_depth = max(self.max_depth, self._crt_depth)
            res = self.dispatch(unary_op.arg)
            self._should_prime = False
            self._crt_depth -= 1
            return res
        else:
            assert 0, 'impossible: ' + str(unary_op)

    def visit_binary_op(self, binary_op:BinOp):
        if binary_op.name == '*':
            return smt_helper.op_and([self.dispatch(binary_op.arg1), self.dispatch(binary_op.arg2)])

        elif binary_op.name == '+':
            return smt_helper.op_or([self.dispatch(binary_op.arg1), self.dispatch(binary_op.arg2)])

        elif binary_op.name == '->':
            return smt_helper.op_implies(self.dispatch(binary_op.arg1), self.dispatch(binary_op.arg2))

        elif binary_op.name == '<->':
            return smt_helper.op_eq(self.dispatch(binary_op.arg1), self.dispatch(binary_op.arg2))

        elif binary_op.name == '=':
            sig, num = _get_sig_num(binary_op)
            res = str([sig,_next(sig)][self._should_prime])
            if num == Number(0):
                res = smt_helper.op_not(res)
            return res

        else:
            assert 0, 'should not happen: ' + str(binary_op)

    def visit_bool(self, bool_const:Bool):
        return (smt_helper.false(), smt_helper.true())[bool_const.name == str(True)]

    #
    def convert(self, expr:Expr):
        return self.dispatch(expr)


def build_func_desc_from_formula(bool_expr:Expr, func_name:str, forbid_next:bool) -> FuncDescription:
    """
    # >>> build_func_desc_from_formula(BinOp('*', BinOp('=', QuantifiedSignal('a', 0), Number(0)), \
    #                                              UnaryOp('X', BinOp('=', QuantifiedSignal('b', 0), Number(1)))), \
    #                                   'func_name', False)
    # >>> build_func_desc_from_formula(BinOp('*', BinOp('=', QuantifiedSignal('a', 0), Number(0)), \
    #                                             BinOp('=', QuantifiedSignal('b', 0), Number(1))), \
    #                                  'func_name', True)
    """

    signals = QuantifiedSignalsFinderVisitor().find_quantified_signals(bool_expr)
    smt_converter = ExprToSmtFormulaVisitor()
    smt_formula = smt_converter.convert(bool_expr)

    assert (not forbid_next) or smt_converter.max_depth == 0

    all_args = [(s, 'Bool') for s in signals]
    for d in range(smt_converter.max_depth):
        suffix = 'Next'*(d+1)
        all_args += [(QuantifiedSignal(s.name + suffix, *s.binding_indices), 'Bool') for s in signals]

    return FuncDescription(func_name, dict(all_args), 'Bool', smt_formula)


def optimize_assume_guarantee(init_ass, init_gua,
                              saf_ass, saf_gua,
                              liv_ass, liv_gua,
                              return_formulae_for_gr1:bool) -> (list, Expr, Expr):
    """
    return:
    [ init_ass  ->  init_gua,
      init_ass & inf_sa_ass  ->  G(fin_saf_ass -> fin_saf_gua),
      init_ass & saf_ass  ->  inf_sa_gua,
      init_ass & saf_ass & liv_ass  ->  liv_gua]
    """
    logger = logging.getLogger(__name__)

    logger.debug('init_ass %s', init_ass)
    logger.debug('init_gua %s', init_gua)
    logger.debug('saf_ass %s', saf_ass)
    logger.debug('saf_gua %s', saf_gua)
    logger.debug('liv_ass %s', liv_ass)
    logger.debug('liv_gua %s', liv_gua)

    properties = []

    #
    if init_gua:
        init_part = SpecProperty(init_ass, init_gua)
        properties.append(init_part)

    gr1_sa_ass, inf_sa_ass = separate(_is_ag2, saf_ass)  # TODO: if ass = Ga & Gb then fails..
    gr1_sa_gua, inf_sa_gua = separate(_is_ag, saf_gua)

    if inf_sa_ass:
        logger.debug('Not all safety assumptions are of form G(bool_formula). We will treat them with "->".')
        pass
    if inf_sa_gua:
        logger.debug('Not all safety guarantees are of form G(bool_formulaOneNext). We will treat them with "->". \n %s', str(inf_sa_gua))
        properties.append(SpecProperty(init_ass + inf_sa_ass, inf_sa_gua))  # gr1_sa_ass are encoded on SMT level!

    env_ass_formula = Bool(True)
    if gr1_sa_ass:
        stripped = set(e.arg for e in gr1_sa_ass)   # since G(arg)
        env_ass_formula = and_expressions(stripped)
    sys_gua_formula = Bool(True)
    if gr1_sa_gua:
        stripped = set(e.arg for e in gr1_sa_gua)   # since forall() ( G(arg) )
        sys_gua_formula = and_expressions(stripped)

    logger.info('saf_part\n %s', properties)

    #
    if liv_gua:
        liv_property = SpecProperty(init_ass + inf_sa_ass + liv_ass, liv_gua)  # gr1_sa_ass are encoded on SMT level
        properties.append(liv_property)
        logger.info('liv_part\n %s', liv_property)
    #
    return properties, env_ass_formula, sys_gua_formula


def normalize_conjuncts(conjuncts:Iterable) -> Expr:
    """ sound, complete
    forall(i,j) a_i_j and forall(i) b_i  ----> forall(i,j) (a_i_j and b_i)
    forall(i) a_i and forall(j) b_j      ----> forall(i) (a_i and b_i)
    """
    conjuncts = list(conjuncts)

    if len(conjuncts) == 0:
        return Bool(True)

    if len(conjuncts) == 1 and isinstance(conjuncts[0], Bool):
        return conjuncts[0]

    for e in conjuncts:
        assert isinstance(e, ForallExpr), 'global non-parameterized properties are not supported'

    max_indices = max(conjuncts, key=lambda e: len(e.arg1))
    new_indices = max_indices.arg1

    normalized_underlying_expr = None
    for e in conjuncts:
        old_indices = e.arg1
        new_by_old = dict((o, new_indices[i]) for i, o in enumerate(old_indices))

        new_underlying_e = _replace_indices(new_by_old, e.arg2)

        if normalized_underlying_expr is None:
            normalized_underlying_expr = new_underlying_e
        else:
            normalized_underlying_expr = BinOp('*', normalized_underlying_expr, new_underlying_e)

    normalized_expr = ForallExpr(new_indices, normalized_underlying_expr)
    return normalized_expr


class IndexReplacerVisitor(Visitor):
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

    def _get_index_name(self, signal:QuantifiedSignal) -> (int, str):
        old_indices = self._new_by_old_index.keys()
        for index in old_indices:
            if signal.name.endswith('_' + index):
                original_name = '_'.join(signal.name.split('_')[:-2])
                return index, original_name

        return None, None


def _replace_indices(newindex_by_oldindex:dict, expr:Expr):
    if len(newindex_by_oldindex) == 0:
        return expr

    replacer = IndexReplacerVisitor(newindex_by_oldindex)
    replaced_expr = replacer.dispatch(expr)

    return replaced_expr


def _fix_indices(value_by_index:dict, expr:Expr):
    """ if 'index' is not in the value_by_index therefore leave it as is """

    if not is_quantified_expr(expr):
        return expr

    newindex_by_oldindex = dict((i, i) for i in _get_indices(expr))
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

    if not is_quantified_property(property):
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

    ass_newindex_by_old = dict((o, max_binding_indices[i]) for i, o in enumerate(binding_indices_ass))
    gua_newindex_by_old = dict((o, max_binding_indices[i]) for i, o in enumerate(binding_indices_gua))

    replaced_ass = _replace_indices(ass_newindex_by_old, normalized_ass)
    replaced_gua = _replace_indices(gua_newindex_by_old, normalized_gua)

    replaced_underlying_ass = replaced_ass.arg2 if is_quantified_expr(replaced_ass) else replaced_ass
    replaced_underlying_gua = replaced_gua.arg2 if is_quantified_expr(replaced_gua) else replaced_gua

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

    if not is_quantified_property(SpecProperty([normalized_conjunct], [])):
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
        'safety-like' properties (a_s -> g_s),
        'liveness-like' properties (a_s and a_l -> g_l)
    Also removes ground variables that becomes useless.
    """

    safety_properties = []
    liveness_properties = []

    denormalized_props = _get_denormalized_property(property)
    for p in denormalized_props:
        #: :type: SpecProperty
        p = p

        safety_ass = normalize_conjuncts([a for a in p.assumptions if is_safety(a, ltl2ucw_converter)])

        all_ass = normalize_conjuncts(p.assumptions)

        safety_guarantees = [g for g in p.guarantees if is_safety(g, ltl2ucw_converter)]
        liveness_guarantees = [g for g in p.guarantees if not is_safety(g, ltl2ucw_converter)]

        safety_properties += [SpecProperty([safety_ass], [sg])
                              for sg in safety_guarantees]
        liveness_properties += [SpecProperty([all_ass], [lg])
                                for lg in liveness_guarantees]

    return safety_properties, liveness_properties


def strengthen_many(properties:list, ltl2ucw_converter) -> (list, list):
    """ Return [a_s -> g_s], [a_s & a_l -> g_l]
    Note that the property ois safety iff the automaton is absorbing.
    """
    safety_part, liveness_part = [], []
    for p in properties:
        safety_props, liveness_props = strengthen(p, ltl2ucw_converter)
        safety_part += safety_props
        liveness_part += liveness_props

    return safety_part, liveness_part


def _instantiate_expr2(expr:Expr, cutoff:int, forbid_zero_index:bool) -> list:
    if not is_quantified_expr(expr):
        return [expr]

    binding_indices = _get_indices(expr)

    assert cutoff >= len(binding_indices), 'impossible to have ' + str(len(binding_indices)) + ' different index values'

    indices_range = range(cutoff) if not forbid_zero_index else range(1, cutoff)
    index_values_tuples = list(permutations(indices_range, len(binding_indices)))

    expressions = []
    for index_values in index_values_tuples:
        value_by_index = dict((binding_indices[i], v) for i, v in enumerate(index_values))
        expr_with_fixed_indices = _fix_indices(value_by_index, expr)
        expressions.append(expr_with_fixed_indices)

    return expressions


def _instantiate_expr(expr:Expr, cutoff: int, forbid_zero_index:bool) -> Expr:
    return and_expressions(_instantiate_expr2(expr, cutoff, forbid_zero_index))


def _set_one_index_to_zero(expr:Expr) -> Expr:
    """ Here QuantifiedSignal is used in a special way -- with numbers instead of letters.
    """
    if not is_quantified_expr(expr):
        return expr

    binding_indices = _get_indices(expr)

    value_by_index = dict([(binding_indices[0], 0)])

    expr_with_fixed_index = _fix_indices(value_by_index, expr)

    return expr_with_fixed_index


def inst_property(property:SpecProperty, cutoff:int) -> SpecProperty:
    """
    forall(i,j) a_i_j -> forall(k) b_k
    =
    (!a_0_0 + !a_0_1 + !a_1_0 + !a_1_1 + ..) + (b_0*b_1*b_2..)
    where maximum values of i,j,k are defined by the min(max_cutoff, actual_cutoff).

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

    NOTE on 'forall optimization' with two and more indices:
    If the property is "Forall(i,j) a_i_j",
     can it be replaced with 'a_0_0'?
    - No. Initially we give the token to a random process (on SMT level we have to tests all the possibilities).
    This means, that if we proved the property a_0 and process 0 is random <=> we proved Forall (i) a_0.
    In case of two indices Forall(i,j) a_i_j
    if we proved Forall(j) a_0_j with the same randomization <=> proved Forall(i,j) a_i_j,
    but it is incorrect to verify a_0_0 because it is equivalent to Forall (i) a_i_i.
    """

    assumptions = property.assumptions
    guarantees = [_set_one_index_to_zero(g) for g in property.guarantees]

    inst_assumptions = [_instantiate_expr(a, cutoff, False) for a in assumptions]
    inst_guarantees = [_instantiate_expr(g, cutoff, True) for g in guarantees]

    inst_p = SpecProperty(inst_assumptions, inst_guarantees)

    return inst_p


class ReplaceSignalsVisitor(Visitor):
    def __init__(self, newsignal_by_oldsignal:dict):
        self.new_by_old = newsignal_by_oldsignal

    def visit_signal(self, signal:Signal):
        if not isinstance(signal, QuantifiedSignal):
            return signal

        if signal not in self.new_by_old:
            return signal

        return self.new_by_old[signal]


def _get_sched_signal(arg, scheduler):
    if isinstance(arg, QuantifiedSignal) and scheduler.is_scheduler_signal(arg):
        return arg
    return None


def _is_active_signal(arg):
    if isinstance(arg, QuantifiedSignal) and arg.name == ACTIVE_NAME:
        return True

    return False


def _get_sig_num(binary_op:BinOp) -> (QuantifiedSignal, Number):
    arg1 = binary_op.arg1
    arg2 = binary_op.arg2

    if isinstance(arg1, Number):
        return arg2, arg1
    elif isinstance(arg2, Number):
        return arg1, arg2
    else:
        assert 0, str(arg1) + ', ' + str(arg2)


class RemoveActiveAndSchedulerSignalsVisitor(Visitor):
    def __init__(self, scheduler:InterleavingScheduler):
        self._scheduler = scheduler

    def visit_binary_op(self, binary_op:BinOp):
        if binary_op.name == '=':
            sig_arg, num_arg = _get_sig_num(binary_op)
            if _get_sched_signal(sig_arg, self._scheduler) or _is_active_signal(sig_arg):
                assert num_arg == Number(1) or num_arg == Number(0)
                return Bool(num_arg == Number(1))   # replace active_i=0 with False and active_i=1 with True

        return super().visit_binary_op(binary_op)

    def do(self, expr:Expr) -> Expr:
        return super().dispatch(expr)


class OptimizeSchedulerSignalsVisitor(Visitor):
    def __init__(self, new_sched_signal_name:str, cutoff:int, scheduler:InterleavingScheduler):
        self._new_sched_signal_name = new_sched_signal_name
        self._cutoff = cutoff
        self._scheduler = scheduler

    def visit_binary_op(self, binary_op:BinOp):
        if binary_op.name == '=':
            old_scheduling_signal = self._get_scheduling_signal(binary_op.arg1, binary_op.arg2)
            old_signal_value = self._get_number(binary_op.arg1, binary_op.arg2)
            if old_scheduling_signal and old_signal_value:
                new_scheduling_underlying_constraint = _get_log_encoded_expr(old_scheduling_signal,
                                                                             self._new_sched_signal_name,
                                                                             self._cutoff)

                return new_scheduling_underlying_constraint

        return super().visit_binary_op(binary_op)

    def _get_scheduling_signal(self, arg1, arg2) -> QuantifiedSignal:
        return _get_sched_signal(arg1, self._scheduler) or _get_sched_signal(arg2, self._scheduler)

    def _get_number(self, arg1, arg2) -> Number:
        if isinstance(arg1, Number):
            return arg1
        if isinstance(arg2, Number):
            return arg2
        return None


def _get_log_encoded_expr(signal:QuantifiedSignal, new_sched_signal_name:str, cutoff:int) -> Expr:
    assert len(signal.binding_indices) == 1

    proc_index = signal.binding_indices[0]

    nof_sched_bits = int(max(1, math.ceil(math.log(cutoff, 2))))
    bits = bin_fixed_list(proc_index, nof_sched_bits)

    #TODO: use quantified signal or signal?
    conjuncts = [BinOp('=',
                       QuantifiedSignal(new_sched_signal_name, bit_index),
                       Number(1 if bit_value else 0))
                 for bit_index, bit_value in enumerate(bits)]

    conjunction = and_expressions(conjuncts)

    return conjunction


def _apply_log_bit_optimization(new_sched_signal_name:str,
                                instantiated_expr:Expr,
                                cutoff:int,
                                scheduler:InterleavingScheduler) -> Expr:
    new_expr = OptimizeSchedulerSignalsVisitor(new_sched_signal_name, cutoff, scheduler).dispatch(instantiated_expr)
    return new_expr


def apply_log_bit_scheduler_optimization(instantiated_property:SpecProperty,
                                         scheduler:InterleavingScheduler,
                                         new_sched_signal_name:str,
                                         cutoff:int) -> SpecProperty:
    new_assumptions = [_apply_log_bit_optimization(new_sched_signal_name, a, cutoff, scheduler) for a in
                       instantiated_property.assumptions]
    new_guarantees = [_apply_log_bit_optimization(new_sched_signal_name, g, cutoff, scheduler) for g in
                      instantiated_property.guarantees]

    return SpecProperty(new_assumptions, new_guarantees)


##############################################################################
#helpers

def parse_expr(expr_as_text:str) -> Expr:
    whole_text = '''
    [INPUT_VARIABLES]
    [OUTPUT_VARIABLES]
    [ASSUMPTIONS]
    [GUARANTEES]
    {0};
    '''.format(expr_as_text)
    return dict(par_parser.parse(whole_text))[PAR_GUARANTEES][0]
















