from itertools import chain
import unittest
import os
import sys
from architecture.scheduler import InterleavingScheduler
from architecture.tok_ring import TokRingArchitecture
from interfaces.spec import SpecProperty
from optimizations import strengthen, localize, _reduce_quantifiers, _get_conjuncts, _denormalize, _fix_indices, _replace_indices, _instantiate_expr, inst_property, _apply_log_bit_optimization, normalize_conjuncts, parse_expr
from interfaces.parser_expr import QuantifiedSignal, ForallExpr, UnaryOp, BinOp, Signal, Expr, Number, Bool, and_expressions
from translation2uct.ltl2automaton import Ltl2UCW


def _get_is_value(signal_name:str, value:Number, *binding_indices):
    if len(binding_indices) == 0:
        signal = Signal(signal_name)
    else:
        signal = QuantifiedSignal(signal_name, *binding_indices)
    return BinOp('=', signal, value)


def _get_is_true(signal_name:str, *binding_indices):
    return _get_is_value(signal_name, Number(1), *binding_indices)


def _get_is_false(signal_name:str, *binding_indices):
    return _get_is_value(signal_name, Number(0), *binding_indices)


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

        prop = SpecProperty([parse_expr('Forall (i) a_i=1')], [parse_expr('Forall (j) b_j=1')])

        localized_prop = localize(prop)
        expected_prop_i = SpecProperty([Bool(True)], [parse_expr('Forall (i) a_i=1 -> b_i=1')])
        expected_prop_j = SpecProperty([Bool(True)], [parse_expr('Forall (j) a_j=1 -> b_j=1')])

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
        expr = parse_expr('Forall (i,j) (a_i_j=1 * b_j=1)')
        result = _replace_indices({'i':'k','j':'m'}, expr)
        expected = parse_expr('Forall (k,m) (a_k_m=1 * b_m=1)')

        self.assertEqual(str(expected), str(result))


class FixIndicesTests(unittest.TestCase):
    def test_fix_indices_main(self):
        expr = parse_expr('Forall(i,j,k,m) (a_i_j_k=1 * b_i_m=1)')

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


def _get_sorted_conjuncts_str(expr:Expr) -> str:
    list = [t.strip() for t in str(expr).split('*') if t.strip() != '']
    return str(sorted(list))


def _convert_conjunction_to_str(property:SpecProperty) -> str:
    result_str = _get_sorted_conjuncts_str(and_expressions(property.assumptions)) +\
                 _get_sorted_conjuncts_str(and_expressions(property.guarantees))
    return result_str


class TestInstantiate(unittest.TestCase):
    def test_instantiate_expr_one_index(self):
        result = _instantiate_expr(parse_expr('Forall (i) a_i=1'), 2, False)
        expected = parse_expr('a_0=1 * a_1=1')

        self.assertEqual(str(expected), str(result))


    def test_instantiate_expr_two_indices(self):
        result = _instantiate_expr(parse_expr('Forall (i,j) a_i_j=1'), 2, False)
        expected = parse_expr('a_0_1=1 * a_1_0=1')

        result_data = _get_sorted_conjuncts_str(result)
        expected_data = _get_sorted_conjuncts_str(expected)
        self.assertEqual(expected_data, result_data)


    def test_instantiate_expr_not_quantified(self):
        result = _instantiate_expr(parse_expr('a_1=1'), 2, False)
        expected = parse_expr('a_1=1')

        self.assertEqual(str(expected), str(result))


    def test_instantiate_property_cutoff4(self):
        property = SpecProperty([parse_expr('Forall (i) a_i = 1')], [parse_expr('Forall(j) b_j=1')])

        result, cutoff = inst_property(TokRingArchitecture(), property, False)

        expected = SpecProperty([parse_expr('a_0=1 * a_1=1 * a_2=1 * a_3=1')], [parse_expr('b_0=1')])

        result_data = _convert_conjunction_to_str(result)
        expected_data = _convert_conjunction_to_str(expected)

        self.assertEqual(4, cutoff)
        self.assertEqual(expected_data, result_data)


    def test_instantiate_property_cutoff2(self):
        property = SpecProperty([Bool(True)], [parse_expr('Forall(j) b_j=1')])

        result, cutoff = inst_property(TokRingArchitecture(), property, sys.maxsize)

        expected = SpecProperty([Bool(True)], [parse_expr('b_0=1')])

        result_data = _convert_conjunction_to_str(result)
        expected_data = _convert_conjunction_to_str(expected)

        self.assertEqual(2, cutoff)
        self.assertEqual(expected_data, result_data)


    def test_instantiate_property_cutoff_another_4(self):
        property = SpecProperty([Bool(True)], [parse_expr('Forall(j,k) b_j=1 -> c_k=1')])

        result, cutoff = inst_property(TokRingArchitecture(), property, sys.maxsize)

        expected = SpecProperty([Bool(True)], [parse_expr('(b_0=1 -> c_1=1) * (b_0=1 -> c_2=1) * (b_0=1 -> c_3=1)')])

        result_data = _convert_conjunction_to_str(result)
        expected_data = _convert_conjunction_to_str(expected)

        self.assertEqual(4, cutoff)
        self.assertEqual(expected_data, result_data)


class TestSchedulerOptimization(unittest.TestCase):
    def setUp(self):
        assert len(InterleavingScheduler().assumptions) == 1


    def test_sched_optimization(self):
        scheduler = InterleavingScheduler()

        forall_expr = scheduler.assumptions[0] # Forall(i) GFsched_i=1

        instantiated_expr = _instantiate_expr(forall_expr, 2, False) # GFsched_0=1 * GFsched_1=1

        result_expr = _apply_log_bit_optimization('sch', instantiated_expr, 2, scheduler)
        expected_expr = BinOp('*',
                                UnaryOp('G', UnaryOp('F', _get_is_true('sch', 0))),
                                UnaryOp('G', UnaryOp('F', _get_is_false('sch', 0))))

        result_str = _get_sorted_conjuncts_str(result_expr)
        expected_str = _get_sorted_conjuncts_str(expected_expr)

        self.assertEqual(expected_str, result_str)


    def test_sched_visual(self):
        scheduler = InterleavingScheduler()
        forall_expr = normalize_conjuncts([parse_expr('Forall(i) a_i=1'), scheduler.assumptions[0]])

        instantiated_expr = _instantiate_expr(forall_expr, 4, False) # GFsched_0=1 * GFsched_1=1

        result_expr = _apply_log_bit_optimization('sch', instantiated_expr, 4, scheduler)
        print('''::test_sched_visual::
Check visually the correctness.
The original expr is Forall(i) a_i=1 * GFfair_sched_i=1,
 after scheduler_log_bit optimization and instantiation with cutoff=4
 it is expected to receive
  a_0=1 * a_1=1 * a_2=1 * a_3=1 *
  GF(sch0=0 * sch1=0) *
  GF(sch0=0 * sch1=1) *
  GF(sch0=1 * sch1=0) *
  GF(sch0=1 * sch1=1)
        ''', result_expr)
        print('The result is')
        print(result_expr)



















