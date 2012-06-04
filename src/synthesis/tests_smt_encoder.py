# coding=utf-8
import unittest

from helpers.boolean import *

x, y, z = symbols("x", "y", "z")

print(normalize(AND, x*((x*y)+(x*z))))
print((x*((x*y)+(x*z))).distributive())

class Test(unittest.TestCase):
    pass
#    def test_make_dnf(self):
#        clause = Clause(Clause.OR,
#            [Clause(Clause.TERM, '1'),
#             Clause(Clause.AND,
#                [Clause(Clause.TERM, '2'),
#                 Clause(Clause.OR,
#                    [Clause(Clause.TERM, '3'),
#                     Clause(Clause.TERM, '4')])])
#            ])
#
#        assert str(clause) == '(1 + 2·(3 + 4))', str(clause)
#
#        dnf_clause = make_dnf(clause)
#        assert str(dnf_clause) == '(1 + 2·3 + 2·4)', str(dnf_clause)


#    def test_generate_transitions(self):
#        automaton = None
#        inputs = None
#        outputs = None
#        encoder = Encoder(automaton, inputs, outputs, UFLIA)
#
#        src_root_clause = None
#        label = None
#        list_of_states, sources = \
#            encoder._make_transition(src_joint_state, label)
