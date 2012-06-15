from itertools import chain
import unittest
from interfaces.automata import Node, Label, Automaton
from synthesis.states_extender import extend_self_looped_rejecting_states, _extend_node_inplace

class Test(unittest.TestCase):
    def test_extend_node__rej_with_link(self):
        # rej->[rej or other] => rej1->[other or rej2], rej2->other

        rej = Node('rej')
        other = Node('other')
        label = Label({'r': True})
        rej.add_transition(label, {rej})
        rej.add_transition(label, {other})

        new_nodes = _extend_node_inplace(rej, 1)
        assert len(new_nodes) == 1, str(new_nodes)

        node1 = rej
        node1_list_of_sets = node1.transitions[label]
        assert len(node1_list_of_sets) == 2 # [{rej2}, {other}]
        node1_transition_states = list(chain(*node1_list_of_sets))

        assert len(node1_transition_states) == 2, str(node1_list_of_sets)
        assert node1 not in node1_transition_states
        assert other in node1_transition_states, str(node1)

        node2 = list(filter(lambda n: n.name == 'rej_2', new_nodes))[0]

        node2_list_of_sets = node2.transitions[label]
        node2_transition_states = list(chain(*node2_list_of_sets))

        assert len(node2_transition_states) == 1, str(node2)
        assert other in node2_transition_states


    def test_extend_rejecting_states_by_1(self):
        # init -> rej -> rej => init -> rej1
        init = Node('init')
        rej = Node('rej')
        label = Label({'r': True})
        init.add_transition(label, {rej})
        rej.add_transition(label, {rej})

        automaton = Automaton([{init}], {rej}, {rej, init})
        extended_automaton = extend_self_looped_rejecting_states(automaton, 1)

        assert len(extended_automaton.nodes) == 3, str(extended_automaton.nodes)
        assert len(extended_automaton.rejecting_nodes) == 0


    def test_extend_rejecting_states_by_2(self):
        # node -> rej -> rej  =>  node -> rej1 -> rej2 -> rej3

        node = Node('node')
        label = Label({'r': False})
        rej = Node('rej')

        node.add_transition(label, {rej})
        rej.add_transition(label, {rej})

        automaton = Automaton([{node}], {rej}, [node, rej])
        extended_automaton = extend_self_looped_rejecting_states(automaton, 2)

        assert len(extended_automaton.nodes) == 4, str(extended_automaton.nodes)
        assert len(extended_automaton.rejecting_nodes) == 0
        assert len(list(chain(*extended_automaton.initial_sets_list))) == 1


    def test_extend_rejecting_states_deepcopy(self):
        # init -> rej -> rej => init -> rej1
        init = Node('init')
        rej = Node('rej')
        label = Label({'r': True})
        init.add_transition(label, {rej})
        rej.add_transition(label, {rej})

        automaton = Automaton([{init}], {rej}, {rej, init})
        extended_automaton = extend_self_looped_rejecting_states(automaton, 5)

        assert len(extended_automaton.nodes) == len(automaton.nodes) + 5

        for old_node in automaton.nodes:
            assert old_node not in extended_automaton.nodes

#
#    def test_extend_rejecting_states__rej_with_nondet_link(self):
#        # init -> rej -> [rej or other]  =>  init -> rej1 -> [rej2 or other], rej2 -> other
#        init = Node('init')
#        rej = Node('rej')
#        label = Label({'r': True})
#        init.add_transition(label, {rej})
#
#        automaton = Automaton([{init}], {rej}, {rej, init})
#        extended_automaton = extend_rejecting_states(automaton, 1)
#
#        assert len(extended_automaton.nodes) == 3, str(extended_automaton.nodes)
#        assert len(extended_automaton.rejecting_nodes) == 0
