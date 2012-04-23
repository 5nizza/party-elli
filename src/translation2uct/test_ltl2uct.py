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

        initial_nodes, rejecting_nodes, nodes = parse_ltl2ba_output(text)

        assert len(initial_nodes) == 1, str(len(initial_nodes))
        assert len(rejecting_nodes) == 1, str(len(rejecting_nodes))
        assert len(nodes) == 2, str(nodes)

        for n in nodes:
            if n.name == 'T0_init':
                assert not n in rejecting_nodes
                assert n in initial_nodes
                assert len(n.transitions) == 2

                for dst, label in n.transitions:
                    assert (dst.name == 'T0_init' and label == {}) or\
                           (dst.name == 'accept_S2' and label == {'g':False, 'r':True}),\
                            'unknown transition: {0} {1}'.format(label, str(dst))

            elif n.name == 'accept_S2':
                assert n in rejecting_nodes
                assert not n in initial_nodes
                assert len(n.transitions) == 1

                for dst, label in n.transitions:
                    assert dst.name == 'accept_S2' and label == {'g':False}
            else:
                assert False, 'unknown node: {0}'.format(str(n))


    def test_parse_ltl2ba_output__skip(self):
        text = """
            never { /* F(r && !g) */
            T0_init :    /* init */
                if
                :: (1) -> goto T0_init
                :: (r && !g) -> goto accept_all
                fi;
            accept_all :    /* 1 */
                skip
            }"""

        initial_nodes, rejecting_nodes, nodes = parse_ltl2ba_output(text)

        assert len(initial_nodes) == 1, str(len(initial_nodes))
        assert len(rejecting_nodes) == 1, str(len(rejecting_nodes))
        assert len(nodes) == 2, str(nodes)

        accept_all_node = [n for n in nodes if n.name == 'accept_all'][0]

        assert rejecting_nodes == {accept_all_node}

        assert len(accept_all_node.transitions) == 1

        dst, label = accept_all_node.transitions[0]
        assert dst == accept_all_node, str(dst)
        assert label == {}, str(label)


    def test_parse_ltl2ba_output__or(self):
        text = """
            never {
            T0_init :    /* init */
                if
                :: (1) -> goto T0_init
                :: (r) || (!g) -> goto accept_all
                fi;
            accept_all :    /* 1 */
                skip
            }"""

        initial_nodes, rejecting_nodes, nodes = parse_ltl2ba_output(text)

        assert len(initial_nodes) == 1, str(len(initial_nodes))
        assert len(rejecting_nodes) == 1, str(len(rejecting_nodes))
        assert len(nodes) == 2, str(nodes)

        init_node = [n for n in nodes if n.name == 'T0_init'][0]

        assert len(init_node.transitions) == 3, len(init_node.transitions)

        for dst, label in init_node.transitions:
            assert (label == {} and dst == init_node)\
                    or (label == {'r':True} and dst != init_node)\
                    or (label == {'g':False} and dst != init_node)


if __name__ == "__main__":
    #import sys;sys.argv = ['', 'Test.testName']
    unittest.main()
