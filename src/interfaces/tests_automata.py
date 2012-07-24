import unittest
from interfaces.automata import Node, get_next_states


class Test(unittest.TestCase):
    def test_get_next_states(self):
        state = Node('init')

        _ = False
        dst_set_r = {(Node('r'),_)}
        dst_set_rg = {(Node('rg'),_)}
        dst_set_not_r_g = {(Node('!rg'),_)}

        state.add_transition({'r':True}, dst_set_r)
        state.add_transition({'r':True, 'g':True}, dst_set_rg)
        state.add_transition({'r':False, 'g':True}, dst_set_not_r_g)


        list_of_state_sets = get_next_states(state,
                                             {'r':False, 'g':False})
        assert len(list_of_state_sets) == 0

        list_of_state_sets = get_next_states(state,
                                             {'r':False, 'g':True})
        assert len(list_of_state_sets) == 1
        assert set([x[0] for x in dst_set_not_r_g]) in list_of_state_sets, \
                                                    str(list_of_state_sets)

        list_of_state_sets = get_next_states(state,
                                             {'r':True, 'g':True})
        assert len(list_of_state_sets) == 2
        assert set([x[0] for x in dst_set_rg]) in list_of_state_sets
        assert set([x[0] for x in dst_set_r]) in list_of_state_sets

