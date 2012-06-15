from itertools import chain
import unittest
from helpers import boolean
from interfaces.automata import Automaton, Node, Label, DEAD_END
from synthesis.alternating_to_universal import convert_acw_to_ucw, _is_rejecting_transition

class Test(unittest.TestCase):
    def test_ucw_to_ucw_no_rej(self):
        #alternating: init -> {node1,node2}, node1 -> node2
        #universal: the same + dead states
        init = Node('init')
        node1 = Node('node1')
        node2 = Node('node2')

        init.add_transition({'g': True}, {node1, node2})
        node1.add_transition({'g': True}, {node2})

        nodes = {init, node1, node2}
        init_list_of_sets = [{init}]

        acw = Automaton(init_list_of_sets, [], nodes)

        universal = convert_acw_to_ucw(acw, set(), {'g'})

        assert len(universal.nodes) == len(acw.nodes) + 1, str(acw.nodes) #+dead node
        assert len(universal.rejecting_nodes) == 0
        assert len(list(chain(*universal.initial_sets_list))) == 1

        init_universal = list(universal.initial_sets_list[0])[0]
        assert init_universal.transitions[Label({'g': False})] == [{(DEAD_END, False)}]
        assert len(init_universal.transitions.keys()) == 2 #g, !g

        other_node = list(filter(lambda n: n.name != init_universal, universal.nodes))[0]
        assert len(other_node.transitions.keys()) == 2 #g, !g


    def test_acw_to_ucw_no_rej(self):
        #alternating: init -> {node1}{node2}, node1 -> node2
        #universal: init -> (node1+node2), (node1+node2) -> node2

        init = Node('init')
        node1 = Node('node1')
        node2 = Node('node2')

        init.add_transition({'g': True}, {node1})
        init.add_transition({'g': True}, {node2})
        node1.add_transition({'g': True}, {node2})

        nodes = {init, node1, node2}
        init_list_of_sets = [{init}]

        acw = Automaton(init_list_of_sets, [], nodes)

        universal = convert_acw_to_ucw(acw, set(), {'g'})

        assert len(universal.nodes) == 4, str(universal.nodes) #init, node1_node2, node2, dead
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
        term_clauses = {state_a:a, state_b:b, state_c:c}

        assert _is_rejecting_transition(state_a_or_b, state_a_or_b_or_c,
                                        clause_to_node,
                                        term_clauses,
                                        {state_a, state_b})

        assert _is_rejecting_transition(state_a_or_b_or_c, state_a_or_b,
                                        clause_to_node,
                                        term_clauses,
                                        {state_a, state_b})

        assert not _is_rejecting_transition(state_a_or_b, state_a_or_b_or_c,
                                            clause_to_node,
                                            term_clauses,
                                            {state_a})

        assert not _is_rejecting_transition(state_a_or_b, state_a_or_b_or_c,
                                            clause_to_node,
                                            term_clauses,
                                            {state_b})

        assert not _is_rejecting_transition(state_a_or_b, state_a_or_b_or_c,
                                            clause_to_node,
                                            term_clauses,
                                            {state_c})

