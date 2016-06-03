import unittest
from itertools import chain

from helpers.rejecting_states_finder import find_rejecting_sccs
from interfaces.automata import Automaton, Node, Label


class Test(unittest.TestCase):
    def test_no_self_loop(self):
        automaton = self._create_automaton({'init', '1', '2'},
                                           'init',
                                           {'init->1':True,
                                            '1->2':False,
                                            '2->1':False})

        rejecting_sccs = find_rejecting_sccs(automaton)

        assert len(rejecting_sccs) == 0, str(rejecting_sccs)

    def test_self_loop(self):
        automaton = self._create_automaton({'init', '1', '2'},
                                           'init',
                                           {'init->1':False, '1->2':False, '2->2':True})

        rejecting_sccs = find_rejecting_sccs(automaton)

        assert len(rejecting_sccs) == 1, str(rejecting_sccs)
        assert set(map(lambda n: n.name, chain(*rejecting_sccs))) == {'2'}

    def test_intermediate_self_loop(self):
        automaton = self._create_automaton({'init', '1', '2'},
            'init',
            {'init->1':False, '1->1':True, '1->2':False, '2->2':False})

        rejecting_sccs = find_rejecting_sccs(automaton)

        assert len(rejecting_sccs) == 1, str(rejecting_sccs)
        assert set(map(lambda n: n.name, chain(*rejecting_sccs))) == {'1'}

    def test_non_rejecting_scc(self):
        automaton = self._create_automaton({'init', '1', '2'},
            'init',
            {'init->1':False, '1->2':False, '2->init':False})

        rejecting_sccs = find_rejecting_sccs(automaton)
        assert len(rejecting_sccs) == 0, str(rejecting_sccs)

    def test_rejecting_scc(self):
        automaton = self._create_automaton({'init', '1', '2'},
            'init',
            {'init->1':False, '1->2':False, '2->1':True})

        rejecting_sccs = find_rejecting_sccs(automaton)

        assert len(rejecting_sccs) == 1, str(rejecting_sccs)
        assert set(map(lambda n: n.name, chain(*rejecting_sccs))) == {'1', '2'}, str(rejecting_sccs)

    def test_tricky_rejecting_scc(self):
        automaton = self._create_automaton({'init', '1', '2'},
            'init',
            {'init->1':True, '1->1':True, '1->2':False, '2->1':False})

        rejecting_sccs = find_rejecting_sccs(automaton)

        assert len(rejecting_sccs) == 1, str(rejecting_sccs)
        assert set(map(lambda n: n.name, chain(*rejecting_sccs))) == {'1', '2'}

    def test_two_rejecting_sccs(self):
        automaton = self._create_automaton({'init', '1', '2'},
            'init',
            {'init->1':False, '1->1':True, '1->2':False, '2->2':True})

        rejecting_sccs = find_rejecting_sccs(automaton)

        assert len(rejecting_sccs) == 2, str(rejecting_sccs)

        assert set(map(lambda s: frozenset(map(lambda n: n.name, s)), rejecting_sccs)) \
                == {frozenset({'1'}), frozenset({'2'})}, str(rejecting_sccs)

    def _create_automaton(self, node_names, init_node_name, transitions_dict):
        name_to_node = {}

        for name in node_names:
            name_to_node[name] = Node(name)

        for trans_desc, is_acc in transitions_dict.items():
            src_node, dst_node = list(map(lambda name: name_to_node[name],
                                          trans_desc.split('->')))

            src_node.add_transition(Label({}), {(dst_node,is_acc)})

        return Automaton({name_to_node[init_node_name]}, set(), set(name_to_node.values()))

