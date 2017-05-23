import unittest

from automata.automata_classifier import is_final_sink
from interfaces.automaton import Node, Label


class ClassifierTest(unittest.TestCase):
    def test_is_not_absorbing(self):
        node = Node('node')

        true_label = Label({})
        node.add_transition(true_label, [('dst1', True)])

        assert not is_final_sink(node)

    def test_is_not_absorbing2(self):
        node = Node('node')

        true_label = Label({})
        node.add_transition(true_label, [('dst1', True)])

        node.add_transition(Label({'r':True}), [(node, True)])

        assert not is_final_sink(node)

    def test_is_absorbing(self):
        node = Node('node')

        true_label = Label({})
        node.add_transition(true_label, [(node, True)])
        node.add_transition(Label({'r':True}), [(node, True)])

        assert is_final_sink(node)
