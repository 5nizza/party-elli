import unittest
from translation2uct.ltl2ba import parse_ltl2ba_output


class Test(unittest.TestCase):
    def test_parse_ltl2ba_output(self):
        text = """
            never { /* !([](r -> <>g)) */
            T0_init :    /* init */
                if
                :: (1) -> goto T0_init
                :: (!g && r) -> goto accept_S2
                fi;
            accept_S2 :    /* 1 */
                if
                :: (!g) -> goto accept_S2
                fi;
            }"""

        initial_nodes, nodes = parse_ltl2ba_output(text)

        assert len(initial_nodes) == 1, str(len(initial_nodes))
        assert len(nodes) == 2, str(nodes)
        print('\n'.join([str(x) for x in nodes]))

        for n in nodes:
            if n.name == 'T0_init':
                assert not n.is_rejecting
                assert n in initial_nodes
                assert len(n.transitions) == 2

                for dst, label in n.transitions:
                    assert (dst.name == 'T0_init' and label == {}) or\
                           (dst.name == 'accept_S2' and label == {'g':False, 'r':True}),\
                            'unknown transition: {0} {1}'.format(label, str(dst))

            elif n.name == 'accept_S2':
                assert n.is_rejecting
                assert not n in initial_nodes
                assert len(n.transitions) == 1

                for dst, label in n.transitions:
                    assert dst.name == 'accept_S2' and label == {'g':False}
            else:
                assert False, 'unknown node: {0}'.format(str(n))


if __name__ == "__main__":
    #import sys;sys.argv = ['', 'Test.testName']
    unittest.main()
