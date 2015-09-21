import unittest
from interfaces.expr import QuantifiedSignal
from automata_translations.ltl3ba_wrapper import _get_hacked_ucw, _unwind_label


def _assert_equal_list_dict(first_list_of_dict, second_list_of_dict):
    assert len(first_list_of_dict) == len(second_list_of_dict)

    for f in first_list_of_dict:
        assert f in second_list_of_dict, \
            '{0} vs {1}'.format(first_list_of_dict, second_list_of_dict)


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

        sig_g = QuantifiedSignal('g')
        sig_r = QuantifiedSignal('r')
        signal_by_name = {'r': sig_r, 'g': sig_g}

        initial_nodes, rejecting_nodes, nodes, _ = _get_hacked_ucw(text, signal_by_name, '')

        assert len(initial_nodes) == 1, str(len(initial_nodes))
        assert len(rejecting_nodes) == 1, str(len(rejecting_nodes))
        assert len(nodes) == 2, str(nodes)

        for n in nodes:
            if n.name == 'T0_init':
                assert n not in rejecting_nodes
                assert n in initial_nodes
                assert len(n.transitions) == 2

                for label, node_flag_pairs in n.transitions.items():
                    for dst, is_rejecting in node_flag_pairs:
                        assert (dst.name == 'T0_init' and label == {}) or \
                               (dst.name == 'accept_S2' and label == {sig_g: False, sig_r: True}), \
                            'unknown transition: {0} {1}'.format(label, str(dst))

            elif n.name == 'accept_S2':
                assert n in rejecting_nodes
                assert n not in initial_nodes
                assert len(n.transitions) == 1

                for label, node_flag_pairs in n.transitions.items():
                    dst, is_rejecting = set(node_flag_pairs).pop()
                    assert dst.name == 'accept_S2' and label == {sig_g: False}
            else:
                assert False, 'unknown node: {0}'.format(str(n))

    def test_parse_ltl2ba_output_names_with_if_fi(self):
        text = """
            never { /* F(r && !g) */
            T0_if_init :    /* init */
                if
                :: (1) -> goto T0_if_init
                :: (r && !g) -> goto accept_if_fi_all
                fi;
            accept_if_fi_all :    /* 1 */
                skip
            }"""
        sig_g = QuantifiedSignal('g')
        sig_r = QuantifiedSignal('r')
        signal_by_name = {'r': sig_r, 'g': sig_g}
        initial_nodes, _, nodes, _ = _get_hacked_ucw(text, signal_by_name, '')

        assert len(initial_nodes) == 1, str(len(initial_nodes))
        assert len(nodes) == 2, str(nodes)

        assert len(list(initial_nodes)[0].transitions) == 2

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
        sig_g = QuantifiedSignal('g')
        sig_r = QuantifiedSignal('r')
        signal_by_name = {'r': sig_r, 'g': sig_g}
        initial_nodes, rejecting_nodes, nodes, _ = _get_hacked_ucw(text, signal_by_name, '')

        assert len(initial_nodes) == 1, str(len(initial_nodes))
        assert len(rejecting_nodes) == 1, str(len(rejecting_nodes))
        assert len(nodes) == 2, str(nodes)

        accept_all_node = [n for n in nodes if n.name == 'accept_all'][0]

        assert rejecting_nodes == {accept_all_node}
        assert len(accept_all_node.transitions) == 1

        label, node_flag_pairs = list(accept_all_node.transitions.items())[0]
        dst, is_rejecting = set(node_flag_pairs).pop()
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
        sig_g = QuantifiedSignal('g')
        sig_r = QuantifiedSignal('r')
        signal_by_name = {'r': sig_r, 'g': sig_g}
        initial_nodes, rejecting_nodes, nodes, _ = _get_hacked_ucw(text, signal_by_name, '')

        assert len(initial_nodes) == 1, str(len(initial_nodes))
        assert len(rejecting_nodes) == 1, str(len(rejecting_nodes))
        assert len(nodes) == 2, str(nodes)

        init_node = [n for n in nodes if n.name == 'T0_init'][0]

        assert len(init_node.transitions) == 3, len(init_node.transitions)

        for label, node_flag_pairs in init_node.transitions.items():
            for dst, is_rejecting in node_flag_pairs:
                assert (label == {} and dst == init_node) \
                           or (label == {sig_r: True} and dst != init_node) \
                           or (label == {sig_g: False} and dst != init_node)

    def test_unwind_labels__true_lbl(self):
        pattern_lbl = {}
        vars = {'r', 'g'}

        concrete_labels = _unwind_label(pattern_lbl, vars)
        _assert_equal_list_dict(
            concrete_labels,
            [{'r': True, 'g': True}, {'r': True, 'g': False},
             {'r': False, 'g': True}, {'r': False, 'g': False}])

    def test_unwind_labels__concrete_lbl(self):
        pattern_lbl = {'r': True}
        vars = {'r'}

        concrete_labels = _unwind_label(pattern_lbl, vars)
        assert concrete_labels == [{'r': True}]

    def test_unwind_labels__main_case(self):
        pattern_lbl = {'r': True}
        vars = {'r', 'g'}

        concrete_labels = _unwind_label(pattern_lbl, vars)

        _assert_equal_list_dict(
            concrete_labels,
            [{'r': True, 'g': True}, {'r': True, 'g': False}])


if __name__ == "__main__":
    #import sys;sys.argv = ['', 'Test.testName']
    unittest.main()
