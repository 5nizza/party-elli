from functools import lru_cache
from itertools import chain, permutations
import math
from architecture.scheduler import InterleavingScheduler
from helpers.automata_helper import is_safety_automaton
from helpers.python_ext import bin_fixed_list
from interfaces.spec import SpecProperty
from parsing.helpers import Visitor
from interfaces.parser_expr import ForallExpr, BinOp, Signal, Expr, Bool, QuantifiedSignal, and_expressions, Number, is_quantified_property
from parsing.par_lexer_desc import PAR_GUARANTEES
from parsing.par_parser import QuantifiedSignalsFinderVisitor
from parsing.par_parser_desc import par_parser


# TODO: split into several files

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


def normalize_conjuncts(conjuncts:list) -> Expr:
    """ sound, complete
    forall(i,j) a_i_j and forall(i) b_i  ----> forall(i,j) (a_i_j and b_i)
    forall(i) a_i and forall(j) b_j      ----> forall(i) (a_i and b_i)
    """
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
        'safety' properties (a_s -> g_s),
        'liveness' properties (a_s and a_l -> g_l)
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
    """
    pseudo_safety_properties, pseudo_liveness_properties = [], []
    for p in properties:
        safety_props, liveness_props = strengthen(p, ltl2ucw_converter)
        pseudo_safety_properties += safety_props
        pseudo_liveness_properties += liveness_props

    return pseudo_safety_properties, pseudo_liveness_properties


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


class RemoveSchedulerSignalsVisitor(Visitor):
    def __init__(self, scheduler:InterleavingScheduler):
        self._scheduler = scheduler

    def visit_binary_op(self, binary_op:BinOp):
        if binary_op.name == '=':
            if _get_sched_signal(binary_op.arg1, self._scheduler) or _get_sched_signal(binary_op.arg2, self._scheduler):
                return Bool(True)

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
















