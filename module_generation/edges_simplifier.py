from unittest import TestCase
import sympy
from sympy.logic.boolalg import Or
from sympy.logic.boolalg import simplify_logic
from interfaces.automaton import LABEL_TRUE, Label
from interfaces.expr import Signal


def _to_expr(l:Label, sig_by_name:dict):
    expr = sympy.true
    for sig, val in l.items():
        sig_by_name[sig.name] = sig
        s = sympy.Symbol(str(sig))
        expr = (expr & s) if val else (expr & ~s)
    return expr


def _to_label(cube, sig_by_name:dict) -> Label or None:
    if cube == sympy.true:
        return LABEL_TRUE
    if cube == sympy.false:
        return None

    label = dict()
    if len(cube.atoms()) == 1:
        sig_name = tuple(cube.atoms())[0].name
        label[sig_by_name[sig_name]] = not isinstance(cube, sympy.Not)
    else:
        for l in cube.args:
            assert len(l.atoms()) == 1, str(l.atoms())
            sig_name = tuple(l.atoms())[0].name
            label[sig_by_name[sig_name]] = not isinstance(l, sympy.Not)
    return Label(label)


def _clauses(dnf_expr) -> tuple:
    if isinstance(dnf_expr, Or):
        return dnf_expr.args
    return dnf_expr,


def simplify_edge_labels(edge_labels:dict) -> dict:
    simplified_edge_labels = dict()
    sig_by_name = dict()
    for (src, dst), labels in edge_labels.items():
        labels_as_exprs = [_to_expr(l, sig_by_name) for l in labels]

        labels_as_dnf = sympy.false
        for le in labels_as_exprs:
            labels_as_dnf |= le

        assert labels_as_dnf != sympy.false

        simplified_expr = simplify_logic(labels_as_dnf, form='dnf')
        clauses = _clauses(simplified_expr)

        simplified_labels = [_to_label(e, sig_by_name) for e in clauses]
        simplified_edge_labels[(src, dst)] = simplified_labels

    return simplified_edge_labels


class TestSympyUsage(TestCase):
    def test__clauses_base1(self):
        a, b, c, x, y, z = sympy.symbols('a, b, c, x, y, z')
        assert _clauses(sympy.true) == (sympy.true,)
        assert _clauses(sympy.false) == (sympy.false,)
        assert _clauses(x) == (x,)
        assert _clauses(~x) == (~x,)
        assert _clauses(x&y) == (x&y,)
        assert _clauses(x&y&~z) == (x&y&~z,)

    def test__clauses1(self):
        x, y, z = sympy.symbols('x, y, z')
        expr = ~x | y&z
        clauses = _clauses(expr)
        self.assertSetEqual(set(clauses), {~x, y&z})

    def test__clauses2(self):
        a, b, c, x, y, z = sympy.symbols('a, b, c, x, y, z')
        expr = ~x | y&z | ~a&~b&~c
        clauses = _clauses(expr)
        self.assertSetEqual(set(clauses), {~x, y&z, ~a&~b&~c})

    def test__to_label_base(self):
        self.assertDictEqual(LABEL_TRUE,
                             _to_label(sympy.true, dict()))

        assert _to_label(sympy.false, dict()) is None

    def test__to_label(self):
        a, b, c, x, y, z = sympy.symbols('a, b, c, x, y, z')
        sig_by_name = dict([(n,n) for n in 'abcxyz'])

        self.assertDictEqual({'a':True},
                             _to_label(a, sig_by_name))
        self.assertDictEqual({'a':False},
                             _to_label(~a, sig_by_name))
        self.assertDictEqual({'a':True, 'b':True},
                             _to_label(a&b, sig_by_name))
        self.assertDictEqual({'a':True, 'b':False},
                             _to_label(a&~b, sig_by_name))
        self.assertDictEqual({'a':True, 'b':False, 'c':True},
                             _to_label(a&~b&c, sig_by_name))


class Test(TestCase):
    def test_simplify_edge_labels___basic1(self):
        r = Signal('r')
        g = Signal('g')

        edge_labels = dict()
        edge_labels[('t0', 't1')] = [{r: True, g: False},
                                     {r: False, g: False}]

        simplified_edge_labels = simplify_edge_labels(edge_labels)

        self.assertDictEqual(simplified_edge_labels,
                             {('t0', 't1'): [{g: False}]})

    def test_simplify_edge_labels___basic2(self):
        r = Signal('r')
        g = Signal('g')
        edge_labels = dict()

        edge_labels[('t0', 't1')] = [{r: True, g: False}]

        edge_labels[('t0', 't2')] = [{r: False, g: False}]

        simplified_edge_labels = simplify_edge_labels(edge_labels)

        self.assertDictEqual(simplified_edge_labels,
                             edge_labels)

    def test_simplify_edge_labels___complex(self):
        r = Signal('r')
        g = Signal('g')
        x = Signal('x')

        edge_labels = dict()

        edge_labels[('t0', 't1')] = [{r: True, g: False},
                                     {r: True, g: True}]

        edge_labels[('t0', 't2')] = [{r: True, g: False}]

        edge_labels[('t2', 't0')] = [{r: True, g: True}]

        edge_labels[('t0', 't0')] = [{r: True, g: True},
                                     {r: True, g: False, x: False}]

        simplified_edge_labels = simplify_edge_labels(edge_labels)

        self.assertDictEqual(simplified_edge_labels,
                             {('t0', 't1'): [{r: True}],
                              ('t0', 't1'): [{r: True}],
                              ('t0', 't2'): [{r: True, g: False}],
                              ('t2', 't0'): [{r: True, g: True}],
                              ('t0', 't0'): [{r: True, g: True},
                                             {r: True, x: False}],
                              })

    def test_simplify_edge_labels___bug(self):
        # ('t2', 't5') :
        #[{prev_0: True, mlocked_0: True, sready_0: True, mbusreq_0: True},
        # {prev_0: True, mlocked_0: True, sready_0: False, mbusreq_0: True},
        # {prev_0: True, mlocked_0: False, sready_0: True, mbusreq_0: False},
        # {prev_0: True, mlocked_0: True, sready_0: True, mbusreq_0: False},
        # {prev_0: True, mlocked_0: True, sready_0: False, mbusreq_0: False},
        # {prev_0: True, mlocked_0: False, sready_0: False, mbusreq_0: False},
        # {prev_0: True, mlocked_0: False, sready_0: False, mbusreq_0: True},
        # {prev_0: True, mlocked_0: False, sready_0: True, mbusreq_0: True}]
        # was simplified into:
        #[{prev_0: True, sready_0: True},
        # {prev_0: True, mbusreq_0: True},
        # {prev_0: True, mlocked_0: False}]
        # but the right solution is:
        # [{prev_0: True}]
        # ------------------------------------------------
        edge_labels = dict()
        edge_labels[('t2', 't5')] = [
            {Signal('prev'): True, Signal('mlocked'): True, Signal('sready'): True, Signal('mbusreq'): True},
            {Signal('prev'): True, Signal('mlocked'): True, Signal('sready'): False,Signal('mbusreq'): True},
            {Signal('prev'): True, Signal('mlocked'): False,Signal('sready'): True, Signal('mbusreq'): False},
            {Signal('prev'): True, Signal('mlocked'): True, Signal('sready'): True, Signal('mbusreq'): False},
            {Signal('prev'): True, Signal('mlocked'): True, Signal('sready'): False,Signal('mbusreq'): False},
            {Signal('prev'): True, Signal('mlocked'): False,Signal('sready'): False,Signal('mbusreq'): False},
            {Signal('prev'): True, Signal('mlocked'): False,Signal('sready'): False,Signal('mbusreq'): True},
            {Signal('prev'): True, Signal('mlocked'): False,Signal('sready'): True, Signal('mbusreq'): True}]

        simplified_edge_labels = simplify_edge_labels(edge_labels)

        # kinda hack - returns strings instead of Signals..
        self.assertDictEqual(simplified_edge_labels, {('t2', 't5'): [{Signal('prev'): True}]})
