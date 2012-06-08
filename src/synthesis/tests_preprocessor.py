from itertools import chain
import unittest
from interfaces.automata import Node, Label, Automaton
from synthesis.preprocessor import extend_rejecting_states, _extend_node_inplace

class Test(unittest.TestCase):
    def test_extend_node(self):
        # node->other => node1->(other,node2), node2->{other}

        node = Node('node')
        other_node = Node('other')
        label = Label({'r': True})
        node.add_transition(label, {node, other_node})

        new_nodes = _extend_node_inplace(node, 1)
        assert len(new_nodes) == 1, str(new_nodes)

        node1 = node
        node1_list_of_sets = node1.transitions[label]
        node1_transition_states = list(chain(*node1_list_of_sets))

        assert len(node1_transition_states) == 2, str(node1_list_of_sets)
        assert node1 not in node1_transition_states
        assert other_node in node1_transition_states, str(node1)

        node2 = list(filter(lambda n: n.name == 'node_2', new_nodes))[0]

        node2_list_of_sets = node2.transitions[label]
        node2_transition_states = list(chain(*node2_list_of_sets))

        assert len(node2_transition_states) == 1, str(node2)
        assert other_node in node2_transition_states


    #TODO:
    def test_extend_rejecting_states_by_0(self):
        assert False


    def test_extend_rejecting_states_by_1(self):
        # init -> rej => init -> rej1
        init = Node('init')
        rej = Node('rej')
        label = Label({'r': True})
        init.add_transition(label, {rej})

        automaton = Automaton([{init}], {rej}, {rej, init})
        extended_automaton = extend_rejecting_states(automaton, 1)

        assert len(extended_automaton.nodes) == 3, str(extended_automaton.nodes)
        assert len(extended_automaton.rejecting_nodes) == 0


    def test_extend_rejecting_states_by_2(self):
        # node -> rej => node -> rej1 -> rej2 -> rej3

        node = Node('node')
        label = Label({'r': False})
        node_rej = Node('rej')

        node.add_transition(label, {node_rej})
        node_rej.add_transition(label, {node_rej})

        automaton = Automaton([{node}], {node_rej}, [node, node_rej])
        extended_automaton = extend_rejecting_states(automaton, 2)

        assert len(extended_automaton.nodes) == 4, str(extended_automaton.nodes)
        assert len(extended_automaton.rejecting_nodes) == 0
        assert len(list(chain(*extended_automaton.initial_sets_list))) == 1


    def test_extend_rejecting_states_deepcopy(self):
        # init -> rej => init -> rej1
        init = Node('init')
        rej = Node('rej')
        label = Label({'r': True})
        init.add_transition(label, {rej})

        automaton = Automaton([{init}], {rej}, {rej, init})
        extended_automaton = extend_rejecting_states(automaton, 5)

        assert len(extended_automaton.nodes) == len(automaton.nodes) + 5

        for old_node in automaton.nodes:
            assert old_node not in extended_automaton.nodes

