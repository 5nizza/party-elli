from helpers.automata_helper import is_safety_automaton
from interfaces.spec import SpecProperty
from parsing.helpers import Visitor, ConverterToLtl2BaFormatVisitor
from parsing.interface import ForallExpr, BinOp, Signal, Expr, Bool, QuantifiedSignal, UnaryOp
from translation2uct.ltl2automaton import Ltl2UCW


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


def _normalize_conjuncts(expressions:list) -> Expr:
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
        old_index, original_signal_name = self._get_index_name(signal)

        if old_index is None:
            return signal

        return Signal(original_signal_name + '_' + str(self._new_by_old_index[old_index])) #TODO: use ParameterizedSignal and don't use this hack


    def _get_index_name(self, signal:Signal):
        old_indices = self._new_by_old_index.keys()
        for index in old_indices:
            if signal.name.endswith('_'+index): #TODO: hack: use class ParameterizedSignal
                original_name = '_'.join(signal.name.split('_')[:-2]) #TODO: current: problems with _i_j, _j_i, etc..
                return index, original_name

        return None, None



def _replace_indices(newindex_by_oldindex:dict, expr):
    if len(newindex_by_oldindex) == 0:
        return expr

    if not isinstance(expr, ForallExpr):
        return expr

    assert isinstance(expr, ForallExpr)
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

    normalized_ass = _normalize_conjuncts(property.assumptions)
    normalized_gua = _normalize_conjuncts(property.guarantees)

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

    replaced_underlying_ass = _replace_indices(ass_newindex_by_old, normalized_ass)
    replaced_underlying_gua = _replace_indices(gua_newindex_by_old, normalized_gua)

    new_gua = ForallExpr(max_binding_indices,
                         BinOp('->', replaced_underlying_ass, replaced_underlying_gua))

    new_property = SpecProperty([Bool(True)], [new_gua])

    return new_property


def strengthen(properties:list, ltl2ucw_converter) -> (list, list):
    """
    Return:
        'safety' properties (a_s -> g_s),
        'liveness' properties (a_s and a_l -> g_l)
    """

    safety_properties = []
    liveness_properties = []
    for p_ in properties:
        #: :type: SpecProperty
        p = p_
        safety_assumptions = [a for a in p.assumptions if is_safety(a, ltl2ucw_converter)]
        liveness_assumptions = [a for a in p.assumptions if a not in safety_assumptions]

        for g in p.guarantees:
            if is_safety(g, ltl2ucw_converter):
                safety_p = SpecProperty(safety_assumptions, [g])
                safety_properties.append(safety_p)
            else:
                liveness_p = SpecProperty(safety_assumptions+liveness_assumptions, [g])
                liveness_properties.append(liveness_p)

    return safety_properties, liveness_properties





import unittest
import os

class TestStrengthen(unittest.TestCase):
    def _get_converter(self):
        me_abs_path = str(os.path.abspath(__file__))
        root_dir_toks = me_abs_path.split(os.sep)[:-1]
        root_dir = os.sep.join(root_dir_toks)
        ltl2ba_path = root_dir + '/../lib/ltl3ba/ltl3ba-1.0.1/ltl3ba'

        return Ltl2UCW(ltl2ba_path)


    def test_strengthen1(self):
        #TODO: should it work with parameterized properties?
        """ GFa -> G(b * c)"""

        a, b, c = Signal('a'), Signal('b'), Signal('c')

        liveness_ass = UnaryOp('G', UnaryOp('F', a))
        safety_gua = UnaryOp('G', BinOp('*', b, c))

        property = SpecProperty([liveness_ass], [safety_gua])

        safety_properties, liveness_properties = strengthen([property], self._get_converter())

        assert len(liveness_properties) == 0, str(liveness_properties)
        assert len(safety_properties) == 1, str(safety_properties)

        actual = safety_properties[0]
        expected = SpecProperty([], [safety_gua])
        assert str(actual) == str(expected), str(actual) + ' vs ' + str(expected)


    def test_strengthen2(self):
        pass


class TestLocalize(unittest.TestCase):

    def _get_is_true(self, signal_name:str, *binding_indices):
        if len(binding_indices) == 0:
            signal = Signal(signal_name)
        else:
            signal = QuantifiedSignal(signal_name, binding_indices)
        return BinOp('=', signal, Bool(True))


    def test_localize_one_ass_one_gua(self):
        """ forall(i) a_i -> forall(j) b_j
         replaced by
            forall(i) (a_i -> b_i)
        """

        a_i_is_true, a_j_is_true, b_j_is_true, b_i_is_true = self._get_is_true('a', 'i'), self._get_is_true('a', 'j'), \
                                                             self._get_is_true('b', 'j'), self._get_is_true('b', 'i')

        prop = SpecProperty([ForallExpr(['i'], a_i_is_true)], [ForallExpr(['j'], b_j_is_true)])

        localized_prop = localize(prop)
        expected_prop_i = SpecProperty([Bool(True)], [ForallExpr(['i'], BinOp('->', a_i_is_true, b_i_is_true))])
        expected_prop_j = SpecProperty([Bool(True)], [ForallExpr(['j'], BinOp('->', a_j_is_true, b_j_is_true))])

        expected_prop_str_i = str(expected_prop_i)
        expected_prop_str_j = str(expected_prop_j)
        localized_prop_str = str(localized_prop)

        assert localized_prop_str == expected_prop_str_i\
            or localized_prop_str == expected_prop_str_j, str(localized_prop_str)

    def test_localize_two_ass_one_gua(self):
        """
        forall(i,j) a_i_j ->  forall(i) b_i
        replaced by
        forall(i,j) (a_i_j ->  b_i)
        """

        a_i_j_is_true, b_i_is_true = self._get_is_true('a', 'i', 'j'), self._get_is_true('b', 'i')

        prop = SpecProperty(
            [ForallExpr(['i', 'j'], a_i_j_is_true)],
            [ForallExpr(['j'], b_i_is_true)])

        localized_prop = localize(prop)
        expected_prop_i_j = SpecProperty([Bool(True)], [ForallExpr(['i', 'j'], BinOp('->', a_i_j_is_true, b_i_is_true))])

        assert str(localized_prop) == str(expected_prop_i_j), str('expected {0}, but got {1}'.format(
            str(expected_prop_i_j),
            str(localized_prop)))


    def test_localize_one_ass_two_gua(self):
        """
        forall(i,j) a_i ->  forall(i, j) b_i_j
        replaced by
        forall(i,j) (a_i ->  b_i_j)
        """

        a_i_is_true, a_k_is_true, a_j_is_true = self._get_is_true('a', 'i'), self._get_is_true('a', 'k'), self._get_is_true('a', 'j')
        b_k_j_is_true = self._get_is_true('b', 'k', 'j')

        prop = SpecProperty(
            [ForallExpr(['i'], a_i_is_true)],
            [ForallExpr(['k', 'j'], b_k_j_is_true)])

        localized_prop = localize(prop)
        expected_prop_k_j1 = SpecProperty([Bool(True)], [ForallExpr(['k', 'j'], BinOp('->', a_k_is_true, b_k_j_is_true))])
        expected_prop_k_j2 = SpecProperty([Bool(True)], [ForallExpr(['k', 'j'], BinOp('->', a_j_is_true, b_k_j_is_true))])

        assert str(localized_prop) == str(expected_prop_k_j1)\
            or str(localized_prop) == str(expected_prop_k_j2), str(localized_prop)


    def test_localize_zero_ass(self):
        """
        true -> forall(i) b_i
        replaced by
        forall(i) (true -> b_i)
        """

        b_i_is_true = self._get_is_true('b', 'i')

        prop = SpecProperty(
            [Bool(True)],
            [ForallExpr(['i'], b_i_is_true)])

        localized_prop = localize(prop)
        expected_prop = SpecProperty([Bool(True)], [ForallExpr(['i'], BinOp('->', Bool(True), b_i_is_true))])

        assert str(localized_prop) == str(expected_prop), str(localized_prop)




















