import re
import unittest
from parsing.parser import parse_ltl
from parsing.par_parser import reduce_par_ltl


class Test(unittest.TestCase):
    def test_i(self):
        text = """
        INPUT: r
        OUTPUT: g
        PROPERTY: G(r_i -> F g_i)
        """
        size, ltl = reduce_par_ltl(parse_ltl(text))
        assert size == 1, str(size)

        splitted_prop = ltl.property.split('&&')
        assert len(splitted_prop) == 1, splitted_prop
        assert '_i' not in ltl.property
        assert set(ltl.inputs) == {'r'}, str(ltl.inputs)
        assert set(ltl.outputs) == {'g'}, str(ltl.outputs)


    def test_ij(self):
        text = """
        INPUT: r
        OUTPUT: g
        PROPERTY: G(!(g_i && g_j)) && G(r_i -> Fg_i)
        """
        size, ltl = reduce_par_ltl(parse_ltl(text))
        assert size == 4, str(size)

        assert '(g0 && g1)' in ltl.property
        assert '(g0 && g2)' in ltl.property
        assert '(g0 && g3)' in ltl.property

        assert set(ltl.inputs) == {'r'}, str(ltl.inputs)
        assert set(ltl.outputs) == {'g'}, str(ltl.outputs)


    def test_ii1(self):
        text = """
        INPUT: r
        OUTPUT: g
        PROPERTY: G(!(g_i1 && g_i))
        """
        size, ltl = reduce_par_ltl(parse_ltl(text))
        assert size == 3, str(size)

        assert '!(g1 && g0)' in ltl.property, ltl.property
        assert len(re.findall('&&', ltl.property)) == 1, ltl.property

        assert set(ltl.inputs) == {'r'}, str(ltl.inputs)
        assert set(ltl.outputs) == {'g'}, str(ltl.outputs)


    def test_ii1j(self):
        text = """
        INPUT: r
        OUTPUT: g
        PROPERTY: G(!(g_i && g_i1 && g_j))
        """
        size, ltl = reduce_par_ltl(parse_ltl(text))
        assert size == 5, str(size)

        assert '!(g0 && g1 && g1)' in ltl.property, ltl.property
        assert '!(g0 && g1 && g2)' in ltl.property, ltl.property
        assert '!(g0 && g1 && g3)' in ltl.property, ltl.property
        assert '!(g0 && g1 && g4)' in ltl.property, ltl.property
        assert len(re.findall('!', ltl.property)) == 4, ltl.property

        assert set(ltl.inputs) == {'r'}, str(ltl.inputs)
        assert set(ltl.outputs) == {'g'}, str(ltl.outputs)


if __name__ == "__main__":
    #import sys;sys.argv = ['', 'Test.testName']
    unittest.main()