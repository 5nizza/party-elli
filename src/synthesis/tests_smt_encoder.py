import unittest

from helpers.boolean import *
from interfaces.automata import Automaton
from synthesis.smt_encoder import Encoder
from synthesis.smt_logic import Logic, UFBV
from translation2uct.ltl2acw import parse_ltl3ba_aa

class Test(unittest.TestCase):
    def test(self):
        _20, _29, _4, _7 = symbols("20", "29", "4", '7')

        and_arg1 = _20*_4*_29*_7
        and_arg2 = _29*_7

        print(normalize(OR, TRUE))

#        ors = [and_arg1, and_arg2, and_arg3, and_arg4]
#
#        OR(*ors)


#    def test_get_possible_labels(self):
#        signals = Signals(['r'], ['g'])
#
#        spec_state_clause = None
#        labels = _get_possible_labels(spec_state_clause)
#
#        assert len(labels) == 121212


#    def test_make_state_transition_assertions(self):
#        text = """
#
#        """
#
#        init_list_of_sets, rejecting_states, states = parse_ltl3ba_aa(text)
#        automaton = Automaton(init_list_of_sets, rejecting_states, states)
#
#        inputs = ['r']
#        outputs = ['g']
#        encoder = Encoder(automaton, inputs, outputs, UFBV())
#
#        encoder._make_state_transition_assertions()









