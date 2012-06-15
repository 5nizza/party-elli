from itertools import chain
import unittest
from interfaces.automata import Automaton, Node, Label, DEAD_END
from synthesis.alternating_to_universal import convert_acw_to_ucw

class Test(unittest.TestCase):

    def test_ucw_to_ucw_no_rej(self):
        #alternating: init -> {node1,node2}, node1 -> node2
        #universal: the same + dead states
        init = Node('init')
        node1 = Node('node1')
        node2 = Node('node2')

        init.add_transition({'g':True}, {node1, node2})
        node1.add_transition({'g':True}, {node2})

        nodes = {init, node1, node2}
        init_list_of_sets = [{init}]

        acw = Automaton(init_list_of_sets, [], nodes)
        universal = convert_acw_to_ucw(acw, {'g'})

        assert len(universal.nodes) == len(acw.nodes) + 1 #+dead node
        assert len(universal.rejecting_nodes) == 0
        assert len(list(chain(*universal.initial_sets_list))) == 1

        init_universal = list(universal.initial_sets_list[0])[0]
        assert init_universal.transitions[Label({'g':False})] == [{DEAD_END}]
        assert len(init_universal.transitions.keys()) == 2 #g, !g

        other_node = list(filter(lambda n: n.name != init_universal, universal.nodes))[0]
        assert len(other_node.transitions.keys()) == 2 #g, !g


    def test_acw_to_ucw_no_rej(self):
        #alternating: init -> {node1}{node2}, node1 -> node2
        #universal: init -> (node1+node2), (node1+node2) -> node2

        init = Node('init')
        node1 = Node('node1')
        node2 = Node('node2')

        init.add_transition({'g':True}, {node1})
        init.add_transition({'g':True}, {node2})
        node1.add_transition({'g':True}, {node2})

        nodes = {init, node1, node2}
        init_list_of_sets = [{init}]

        acw = Automaton(init_list_of_sets, [], nodes)

        universal = convert_acw_to_ucw(acw, {'g'})

        assert len(universal.nodes) == 4, str(universal.nodes) #init, node1_node2, node2, dead
        assert len(universal.rejecting_nodes) == 0

