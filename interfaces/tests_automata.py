import unittest

from interfaces.automaton import Node, get_next_states, Label
from interfaces.expr import Signal


class Test(unittest.TestCase):
    def _are_equal_sequences(self, seq1, seq2):
        seq1 = set(seq1)
        seq2 = set(seq2)
        self.assertSetEqual(seq1, seq2)

    def test_get_next_states(self):
        state = Node('init')

        sig_r, sig_g = Signal('r'), Signal('g')
        node_r = Node('r')
        node_rg = Node('rg')
        node_nr_g = Node('!rg')

        _ = False
        edge_to_r = {(node_r, _)}
        edge_to_rg = {(node_rg, _)}
        edge_to_not_r_g = {(node_nr_g, _)}

        state.add_transition({sig_r:True}, edge_to_r)
        state.add_transition({sig_r:True, sig_g:True}, edge_to_rg)
        state.add_transition({sig_r:False, sig_g:True}, edge_to_not_r_g)

        next_states = get_next_states(state, Label({sig_r:False, sig_g:False}))
        assert len(next_states) == 0

        next_states = get_next_states(state, Label({sig_r:False, sig_g:True}))
        assert len(next_states) == 1
        self._are_equal_sequences({node_nr_g}, next_states)

        next_states = get_next_states(state, Label({sig_r:True, sig_g:True}))
        assert len(next_states) == 2
        self._are_equal_sequences({node_r, node_rg}, next_states)
