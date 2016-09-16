import unittest

from interfaces.automata import Node, get_next_states, Label


class Test(unittest.TestCase):
    def _are_equal_sequences(self, seq1, seq2):
        seq1 = set(seq1)
        seq2 = set(seq2)
        self.assertSetEqual(seq1, seq2)

    def test_get_next_states(self):
        state = Node('init')
        r = Node('r')
        rg = Node('rg')
        nr_g = Node('!rg')

        _ = False
        edge_to_r = {(r, _)}
        edge_to_rg = {(rg, _)}
        edge_to_not_r_g = {(nr_g, _)}

        state.add_transition({'r':True}, edge_to_r)
        state.add_transition({'r':True, 'g':True}, edge_to_rg)
        state.add_transition({'r':False, 'g':True}, edge_to_not_r_g)

        next_states = get_next_states(state, Label({'r':False, 'g':False}))
        assert len(next_states) == 0

        next_states = get_next_states(state, Label({'r':False, 'g':True}))
        assert len(next_states) == 1
        self._are_equal_sequences({nr_g}, next_states)

        next_states = get_next_states(state, Label({'r':True, 'g':True}))
        assert len(next_states) == 2
        self._are_equal_sequences({r, rg}, next_states)
