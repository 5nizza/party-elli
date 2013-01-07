from itertools import chain
import unittest
import os
from interfaces.spec import SpecProperty
from optimizations import strengthen, localize, _reduce_quantifiers, _get_conjuncts, _denormalize, _fix_indices, _replace_indices
from interfaces.parser_expr import QuantifiedSignal, ForallExpr, UnaryOp, BinOp, Signal, Expr, Number, Bool
from parsing.par_lexer_desc import PAR_GUARANTEES
from parsing.par_parser_desc import par_parser
from translation2uct.ltl2automaton import Ltl2UCW


def _get_is_true(signal_name:str, *binding_indices):
    if len(binding_indices) == 0:
        signal = Signal(signal_name)
    else:
        signal = QuantifiedSignal(signal_name, *binding_indices)
    return BinOp('=', signal, Number(1))


def _parse(expr_as_text:str) -> Expr:
    whole_text = '''
    [INPUT_VARIABLES]
    [OUTPUT_VARIABLES]
    [ASSUMPTIONS]
    [GUARANTEES]
    {0};
    '''.format(expr_as_text)

    return dict(par_parser.parse(whole_text))[PAR_GUARANTEES][0]



class TestStrengthen(unittest.TestCase):
    def _get_converter(self):
        me_abs_path = str(os.path.abspath(__file__))
        root_dir_toks = me_abs_path.split(os.sep)[:-1]
        root_dir = os.sep.join(root_dir_toks)
        ltl2ba_path = root_dir + '/../lib/ltl3ba/ltl3ba-1.0.1/ltl3ba'

        return Ltl2UCW(ltl2ba_path)


    def test_strengthen1(self):
        """
        Forall(i) GFa_i -> Forall(j) G(b_j)
        replaced by
        'safety': Forall(j) G(b_j)
        'liveness': []
        """

        a_i, b_j = QuantifiedSignal('a', 'i'), QuantifiedSignal('b', 'j')

        liveness_ass = ForallExpr(['i'], UnaryOp('G', UnaryOp('F', a_i)))
        safety_gua = ForallExpr(['j'], UnaryOp('G', b_j))

        property = SpecProperty([liveness_ass], [safety_gua])

        safety_properties, liveness_properties = strengthen(property, self._get_converter())

        assert len(liveness_properties) == 0, str(liveness_properties)
        assert len(safety_properties) == 1, str(safety_properties)

        actual_guarantees = safety_properties[0].guarantees
        assert str(actual_guarantees) == str([safety_gua]), \
        '\n' + str(actual_guarantees) + '\nvs\n' + str([safety_gua])


    def test_strengthen2(self):
        """
        Forall(i) GFa_i -> Forall(j) GF(b_j)
        is left as it is
        """
        a_i, b_j = QuantifiedSignal('a', 'i'), QuantifiedSignal('b', 'j')

        liveness_ass = ForallExpr(['i'], UnaryOp('G', UnaryOp('F', a_i)))
        liveness_gua = ForallExpr(['j'], UnaryOp('G', UnaryOp('F', b_j)))

        property = SpecProperty([liveness_ass], [liveness_gua])

        safety_properties, liveness_properties = strengthen(property, self._get_converter())

        assert len(liveness_properties) == 1, str(liveness_properties)
        assert len(safety_properties) == 0, str(safety_properties)

        actual = liveness_properties[0]
        expected = property
        assert str(actual) == str(expected), str(actual) + ' vs ' + str(expected)


    def test_strengthen2(self):
        """
        Forall(i) GFa_i and G(b_i)  ->  Forall(j) GF(c_j) and G(d_j)
        replaced by
        'liveness': Forall(i) GFa_i and G(b_i)  ->  Forall(j) GF(c_j)
        and
        'safety': Forall(i) G(b_i)  ->  Forall(j) G(d_j)
        """

        a_i, b_i = QuantifiedSignal('a', 'i'), QuantifiedSignal('b', 'i')
        c_j, d_j = QuantifiedSignal('c', 'j'), QuantifiedSignal('d', 'j')

        ass = ForallExpr(['i'],
            BinOp('*',
                UnaryOp('G', UnaryOp('F', a_i)),
                UnaryOp('G', b_i)
            ))
        gua = ForallExpr(['j'],
            BinOp('*',
                UnaryOp('G', UnaryOp('F', c_j)),
                UnaryOp('G', d_j)))

        property = SpecProperty([ass], [gua])

        safety_properties, liveness_properties = strengthen(property, self._get_converter())

        assert len(liveness_properties) == 1, str(liveness_properties)
        assert len(safety_properties) == 1, str(safety_properties)


        expected_liveness_gua = ForallExpr(['j'], UnaryOp('G', UnaryOp('F', c_j)))

        #: :type: SpecProperty
        liveness_prop = liveness_properties[0]
        assert str(liveness_prop.assumptions) == str([ass]), str(liveness_prop)
        assert str(liveness_prop.guarantees) == str([expected_liveness_gua])


        safety_prop = safety_properties[0]
        expected_safety_ass = ForallExpr(['i'], UnaryOp('G', b_i))
        expected_safety_gua = ForallExpr(['j'], UnaryOp('G', d_j))
        expected_safety_prop = SpecProperty([expected_safety_ass], [expected_safety_gua])
        assert str(expected_safety_prop) == str(safety_prop), str(safety_prop)


    def test_strengthen3(self):
        """
        Forall(i,j) GFa_i * GFb_i_j * Gc_i_j -> Forall(k,m) GF(d_k_m) * G(e_k)
        replaced by
        'safety':   Forall(i) Gc_i_j  ->  Forall(k) G(e_k)
        'liveness': Forall(i,j) GFa_i * GFb_i_j * Gc_i  ->  Forall(k,m) GF(d_k_m)
        """
        a_i, b_i_j, c_i_j = _get_is_true('a', 'i'), _get_is_true('b', 'i', 'j'), _get_is_true('c', 'i', 'j')
        ass = ForallExpr(['i', 'j'],
            BinOp('*', UnaryOp('G', UnaryOp('F', a_i)),
                       BinOp('*', UnaryOp('G', UnaryOp('F', b_i_j)),
                                  UnaryOp('G', c_i_j))))

        d_k_m = _get_is_true('d', 'k','m')
        e_k = _get_is_true('e', 'k')
        gua = ForallExpr(['k', 'm'],
            BinOp('*',
                UnaryOp('G', UnaryOp('F', d_k_m)),
                UnaryOp('G', e_k)))

        property = SpecProperty([ass], [gua])
        safety_properties, liveness_properties = strengthen(property, self._get_converter())

        #lazy..
        print('safety_properties', safety_properties)
        assert len(safety_properties) == 1, str(safety_properties)
        assert len(list(chain(*[sp.assumptions for sp in safety_properties]))) == 1
        assert len(list(chain(*[sp.guarantees for sp in safety_properties]))) == 1

        print('liveness_properties', liveness_properties)



class TestDenormalize(unittest.TestCase):
    def test_denormalize(self):
        a_i, b_i = _get_is_true('a', 'i'), _get_is_true('b', 'i')

        expr = ForallExpr(['i'], BinOp('*', a_i, b_i))

        denormalized_expressions = _denormalize(expr)
        assert len(denormalized_expressions) == 2, str(denormalized_expressions)


class TestGetConjucts(unittest.TestCase):
    def test_get_conjuncts_and_op(self):
        a, b = Signal('a'), Signal('b')
        conjunction_expr = BinOp('*', a, b)
        conjuncts = _get_conjuncts(conjunction_expr)

        assert len(conjuncts) == 2
        assert a in conjuncts
        assert b in conjuncts


    def test_get_conjuncts_no_conjuncts(self):
        a, b = Signal('a'), Signal('b')
        conjunction_expr = BinOp('+', a, b)
        conjuncts = _get_conjuncts(conjunction_expr)

        assert conjuncts== [conjunction_expr], str(conjunction_expr)


    def test_get_conjuncts_recursion(self):
        a, b, c = Signal('a'), Signal('b'), Signal('c')
        conjunction_expr = BinOp('*', a, BinOp('*', b, c))
        conjuncts = _get_conjuncts(conjunction_expr)

        assert len(conjuncts) == 3


class TestReduceQuantifiers(unittest.TestCase):
    def test_reduce(self):
        """
        Forall(k,m,l) Gb_k_m
        replaced by
        Forall(k,m) Gb_k_m
        """

        b_k_m = _get_is_true('b', 'k', 'm')

        expr = ForallExpr(['k','m','l'], UnaryOp('G', b_k_m))

        actual_expr = _reduce_quantifiers(expr)
        expected_expr = ForallExpr(['k', 'm'], UnaryOp('G', b_k_m))

        assert str(actual_expr) == str(expected_expr), str(actual_expr)


class TestLocalize(unittest.TestCase):
    def test_localize_one_ass_one_gua(self):
        """ forall(i) a_i -> forall(j) b_j
         replaced by
            forall(i) (a_i -> b_i)
        """

        prop = SpecProperty([_parse('Forall (i) a_i=1')], [_parse('Forall (j) b_j=1')])

        localized_prop = localize(prop)
        expected_prop_i = SpecProperty([Bool(True)], [_parse('Forall (i) a_i=1 -> b_i=1')])
        expected_prop_j = SpecProperty([Bool(True)], [_parse('Forall (j) a_j=1 -> b_j=1')])

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

        a_i_j_is_true, b_j_is_true = _get_is_true('a', 'i', 'j'), _get_is_true('b', 'j')
        b_i_is_true = _get_is_true('b', 'i')

        prop = SpecProperty(
            [ForallExpr(['i', 'j'], a_i_j_is_true)],
            [ForallExpr(['j'], b_j_is_true)])

        localized_prop = localize(prop)
        expected_prop_i_j1 = SpecProperty([Bool(True)], [ForallExpr(['i', 'j'], BinOp('->', a_i_j_is_true, b_j_is_true))])
        expected_prop_i_j2 = SpecProperty([Bool(True)], [ForallExpr(['i', 'j'], BinOp('->', a_i_j_is_true, b_i_is_true))])

        assert str(localized_prop) == str(expected_prop_i_j1) or\
               str(localized_prop) == str(expected_prop_i_j2),\
        str(localized_prop)


    def test_localize_one_ass_two_gua(self):
        """
        forall(i,j) a_i ->  forall(i,j) b_i_j
        replaced by
        forall(i,j) (a_i ->  b_i_j)
        """

        a_i_is_true, a_k_is_true, a_j_is_true = _get_is_true('a', 'i'), _get_is_true('a', 'k'), _get_is_true('a', 'j')
        b_k_j_is_true = _get_is_true('b', 'k', 'j')

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

        b_i_is_true = _get_is_true('b', 'i')

        prop = SpecProperty(
            [Bool(True)],
            [ForallExpr(['i'], b_i_is_true)])

        localized_prop = localize(prop)
        expected_prop = SpecProperty([Bool(True)], [ForallExpr(['i'], BinOp('->', Bool(True), b_i_is_true))])

        assert str(localized_prop) == str(expected_prop), str(localized_prop)


class ReplaceIndicesTests(unittest.TestCase):
    def test_replace_indices(self):
        expr = _parse('Forall (i,j) (a_i_j=1 * b_j=1)')
        result = _replace_indices({'i':'k','j':'m'}, expr)
        expected = _parse('Forall (k,m) (a_k_m=1 * b_m=1)')

        self.assertEqual(str(expected), str(result))


class FixIndicesTests(unittest.TestCase):
    def test_fix_indices_main(self):
        expr = _parse('Forall(i,j,k,m) (a_i_j_k=1 * b_i_m=1)')

        result = _fix_indices({'i':1, 'j':2, 'k':3}, expr)
        expected_result = ForallExpr(['m'], BinOp('*', _get_is_true('a', 1,2,3), _get_is_true('b',1,'m')))

        self.assertEqual(str(expected_result), str(result))


    def test_fix_indices_partially_fixed(self):
        a_i_1 = _get_is_true('a', 'i', 1)
        c_0 = _get_is_true('c', 0)

        expr = ForallExpr(['i'], BinOp('*', a_i_1, c_0))
        result = _fix_indices({'i':2}, expr)

        a_2_1 = _get_is_true('a', 2,1)
        expected_result = BinOp('*', a_2_1, c_0)

        self.assertEqual(str(result), str(expected_result))












