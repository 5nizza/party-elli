import logging
from itertools import chain
from unittest import TestCase

from typing import Iterable

from helpers.python_ext import lfilter
from interfaces.expr import Signal
from parsing.acacia_parser import _parse_part
from parsing.ctl.ctl_parser_desc import ctl_parser, ctl_lexer
from parsing.sanity_checker import check_unknown_signals_in_properties


def _parse_signals_from_lines(signal_lines:list) -> list:
    signals_raw = chain(*[l.split()[1:] for l in signal_lines])

    signals = [Signal(n.strip())
               for n in signals_raw]

    return signals


#TODO: hack: figure out why 'shift-reduce' conflicts arise in the parser
def _add_spec_unit_if_necessary(ctl_ltl_text):
    lines = [l.strip() for l in ctl_ltl_text.split('\n') if l.strip()]
    non_comment_lines = lfilter(lambda l: not l.startswith('#'), lines)

    if non_comment_lines and not non_comment_lines[0].startswith('['):
        lines = ['[spec_unit None]'] + lines

    return '\n'.join(lines)


def parse(ctl_text:str, part_text:str)\
        -> (Iterable[Signal],Iterable[Signal],dict):
    """ :return: inputs, outputs, dict{unit_name -> (assumptions,guarantees)} """
    ctl_text = _add_spec_unit_if_necessary(ctl_text)

    input_signals, output_signals = _parse_part(part_text)
    data_by_unit = dict(ctl_parser.parse(ctl_text, lexer=ctl_lexer))

    known_signals = input_signals + output_signals
    for (assumptions,guarantees) in data_by_unit.values():
        error = check_unknown_signals_in_properties(assumptions+guarantees, known_signals)

        if error:
            logging.error(error)
            return None

    return input_signals, output_signals, data_by_unit


########################################################################
# tests
test_string_part = """
.inputs i r0 r1
.outputs g0 g1
"""

valid_ctl = \
"""[spec_unit u1]
assume A G (!(i=1 * !(X(g0=1)) * !(X(g1=1))) + (X (i=1)));

E G ((!(A X(E g0=1))) + (E r0=1));
A G ((!(X(g1=1))) + (r1=1));
E G (((!(X(g0=1))) + (!(X(g1=1)))) * ((!(X(g1=1))) + (!(X(g0=1)))));

[spec_unit u2]
assume A(G ((!(X(g0=1))) + (X (((!(r0=1)) * (!(i=1))) U ((!(r0=1)) * (i=1))))));
assume E(!(F (G ((r0=1) * (!(X(g0=1)))))));

A(!(F (G (r1=1) * (!(X(g1=1))) ) ));
E(G (  ( (!(X(g0=1))) * (!(X(g1=1))) ) + (i=1)  ));
A(G ((!(r0=1)) + (!(X(g1=1)))));

group_order = (u1 u2);
"""

# invalid because some expressions are path formulas
invalid_ctl = \
    """[spec_unit u1]
    assume A G (!(i=1 * !(X(g0=1)) * !(X(g1=1))) + (X (i=1)));

    G ((!(X(g1=1))) + (r1=1));   # INVALID!
    A G (((!(X(g0=1))) + (!(X(g1=1)))) * ((!(X(g1=1))) + (!(X(g0=1)))));
    """


class Test(TestCase):
    def test_valid_ctl(self):
        input_signals, output_signals, data_by_name = parse(valid_ctl, test_string_part)

        exp_input_signals = [Signal(n) for n in 'i r0 r1'.split()]
        assert set(input_signals) == set(exp_input_signals)

        exp_output_signals = [Signal(n) for n in 'g0 g1'.split()]
        assert set(output_signals) == set(exp_output_signals)

        for (k, v) in data_by_name.items():
            print(k, v)

        u1_assumptions, u1_guarantees = data_by_name['u1']
        assert len(u1_assumptions) == 1
        assert len(u1_guarantees) == 3

        u2_assumptions, u2_guarantees = data_by_name['u2']
        assert len(u2_assumptions) == 2
        assert len(u2_guarantees) == 3

    def test_invalid_ctl(self):
        with self.assertRaises(Exception):
            parse(invalid_ctl, test_string_part)

