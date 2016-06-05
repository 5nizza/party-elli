import logging
from itertools import chain
from unittest import TestCase

from typing import Iterable

from helpers.python_ext import lfilter
from interfaces.expr import Signal
from parsing.acacia_lexer_desc import acacia_lexer
from parsing.acacia_parser_desc import acacia_parser
from parsing.sanity_checker import check_unknown_signals_in_properties


def _parse_signals_from_lines(signal_lines:list) -> list:
    signals_raw = chain(*[l.split()[1:] for l in signal_lines])

    signals = [Signal(n.strip())
               for n in signals_raw]

    return signals


def _parse_part(acacia_part_text:str):
    #TODO: stupid parser, but this part/ltl format is stupid anyway
    lines = [l.strip() for l in acacia_part_text.split('\n') if l.strip()]

    input_lines = lfilter(lambda l: l.startswith('.inputs'), lines)
    output_lines = lfilter(lambda l: l.startswith('.outputs'), lines)

    input_signals = _parse_signals_from_lines(input_lines)
    output_signals = _parse_signals_from_lines(output_lines)

    return input_signals, output_signals


#TODO: hack: figure out why shift-reduce conflicts arise in the parser
def _add_spec_unit_if_necessary(acacia_ltl_text):
    lines = [l.strip() for l in acacia_ltl_text.split('\n') if l.strip()]
    non_comment_lines = lfilter(lambda l: not l.startswith('#'), lines)

    if non_comment_lines and not non_comment_lines[0].startswith('['):
        lines = ['[spec_unit None]'] + lines

    return '\n'.join(lines)


def parse(acacia_ltl_text:str, acacia_part_text:str)\
        -> (Iterable[Signal],Iterable[Signal],dict):
    """ :return: inputs, outputs, dict{unit_name -> (assumptions,guarantees)} """
    acacia_ltl_text = _add_spec_unit_if_necessary(acacia_ltl_text)

    input_signals, output_signals = _parse_part(acacia_part_text)
    data_by_unit = dict(acacia_parser.parse(acacia_ltl_text, lexer=acacia_lexer))

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
.inputs idle request0 request1
.outputs grant0 grant1
"""

test_string_ltl = """
[spec_unit u1]
assume G (!(idle=1 * !(X(grant0=1)) * !(X(grant1=1))) + (X (idle=1)));

(G ((!(X(grant0=1))) + (request0=1)));
(G ((!(X(grant1=1))) + (request1=1)));
(G (((!(X(grant0=1))) + (!(X(grant1=1)))) * ((!(X(grant1=1))) + (!(X(grant0=1))))));

[spec_unit u2]
assume (G ((!(X(grant0=1))) + (X (((!(request0=1)) * (!(idle=1))) U ((!(request0=1)) * (idle=1))))));
assume (!(F (G ((request0=1) * (!(X(grant0=1)))))));

(!(F (G ((request1=1) * (!(X(grant1=1)))))));
(G (((!(X(grant0=1))) * (!(X(grant1=1)))) + (idle=1)));
(G ((!(request0=1)) + (!(X(grant1=1)))));

group_order = (u1 u2);
"""


class Test(TestCase):
    def tests_all(self):
        input_signals, output_signals, data_by_name = parse(test_string_ltl, test_string_part)

        exp_input_signals = [Signal(n) for n in 'idle request0 request1'.split()]
        assert set(input_signals) == set(exp_input_signals)

        exp_output_signals = [Signal(n) for n in 'grant0 grant1'.split()]
        assert set(output_signals) == set(exp_output_signals)

        for (k, v) in data_by_name.items():
            print(k, v)

        u1_assumptions, u1_guarantees = data_by_name['u1']
        assert len(u1_assumptions) == 1
        assert len(u1_guarantees) == 3

        u2_assumptions, u2_guarantees = data_by_name['u2']
        assert len(u2_assumptions) == 2
        assert len(u2_guarantees) == 3
