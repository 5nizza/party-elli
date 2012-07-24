from itertools import chain
import unittest
from helpers import boolean
from interfaces.automata import Automaton, Node, Label, DEAD_END, LIVE_END
from synthesis.alternating_to_universal import convert_acw_to_ucw, _is_rejecting_transition


class Test(unittest.TestCase):
    def test_ucw_to_ucw_no_rej(self):
        #alternating: init -> {node1,node2}, node1 -> node2
        #universal: the same + dead states
        init = Node('init')
        node1 = Node('node1')
        node2 = Node('node2')

        _ = False
        init.add_transition({'g': True}, {(node1,_), (node2,_)})
        node1.add_transition({'g': True}, {(node2,_)})

        nodes = {init, node1, node2}
        init_list_of_sets = [{init}]

        acw = Automaton(init_list_of_sets, [], nodes)

        universal = convert_acw_to_ucw(acw, set(), {'g'})

        #+dead+live nodes
        assert len(universal.nodes) == len(acw.nodes) + 2, '{0} -> {1}'.format(universal.nodes, acw.nodes)

        assert len(universal.rejecting_nodes) == 0

        assert len(list(chain(*universal.initial_sets_list))) == 1

        init_universal = list(universal.initial_sets_list[0])[0]
        assert init_universal.transitions[Label({'g': False})] == [{(DEAD_END, False)}]
        assert len(init_universal.transitions.keys()) == 2 #g, !g

        other_node = list(filter(lambda n: n.name != init_universal and n is not LIVE_END and n is not DEAD_END,
                                universal.nodes))[0]
        assert len(other_node.transitions.keys()) == 2, str(other_node.transitions) #g, !g


    def test_acw_to_ucw_no_rej(self):
        #alternating: init -> {node1}{node2}, node1 -> node2
        #universal: init -> (node1+node2), (node1+node2) -> node2

        init = Node('init')
        node1 = Node('node1')
        node2 = Node('node2')

        init.add_transition({'g': True}, {(node1,False)})
        init.add_transition({'g': True}, {(node2,False)})
        node1.add_transition({'g': True}, {(node2,False)})

        nodes = {init, node1, node2}
        init_list_of_sets = [{init}]

        acw = Automaton(init_list_of_sets, [], nodes)

        universal = convert_acw_to_ucw(acw, set(), {'g'})

        assert len(universal.nodes) == 5, str(universal.nodes) #init, node1_node2, node2, dead, live
        assert len(universal.rejecting_nodes) == 0


    def test_is_rejecting(self):
        state_a_or_b = Node('a_or_b')
        state_a_or_b_or_c = Node('a_or_b_or_c')
        a, b, c = boolean.symbols('a', 'b', 'c')

        clause_to_node = {(a + b): state_a_or_b,
                          (a + b + c): state_a_or_b_or_c}

        state_a = Node('a')
        state_b = Node('b')
        state_c = Node('c')

        #currently it ignores rejecting edges and considers rejecting nodes only
        state_a.add_transition({}, {(state_a, False)})
        state_a.add_transition({}, {(state_b, False)})

        state_b.add_transition({}, {(state_b, False)})
        state_b.add_transition({}, {(state_c, False)})

        term_clauses = {state_a:a, state_b:b, state_c:c}

        assert not _is_rejecting_transition(state_a_or_b,
                                            Label({}),
                                            clause_to_node,
                                            term_clauses,
                                            {})

        assert not _is_rejecting_transition(state_a_or_b,
                                            Label({}),
                                            clause_to_node,
                                            term_clauses,
                                            {state_a})

        assert not _is_rejecting_transition(state_a_or_b,
                                            Label({}),
                                            clause_to_node,
                                            term_clauses,
                                            {state_b})

        assert _is_rejecting_transition(state_a_or_b,
                                        Label({}),
                                        clause_to_node,
                                        term_clauses,
                                        {state_a, state_b})