#!/usr/bin/env python3

import argparse

import logging
from typing import Iterable

from LTL_to_atm import translator_via_ltl3ba, translator_via_spot
from automata.k_reduction import k_reduce
from helpers.main_helper import setup_logging
from interfaces.LTL_to_automaton import LTLToAutomaton
from interfaces.automaton import Automaton
from interfaces.expr import Signal
from module_generation.automaton_to_verilog import atm_to_verilog
from module_generation.verilog_to_aiger_via_yosys import verilog_to_aiger
from parsing.acacia_parser_helper import parse_acacia_and_build_expr


# FIXME: rename
from parsing.tlsf_parser import convert_tlsf_or_acacia_to_acacia


def convert_spec_to_aiger(inputs:Iterable[Signal], outputs:Iterable[Signal],
                          ucw_automaton:Automaton,
                          k:int,
                          bad_out_name:str) -> str:
    k_atm = k_reduce(ucw_automaton, k)
    logging.info("k-LA automaton has %i states" % len(k_atm.nodes))

    module_name = 'automaton'
    verilog = atm_to_verilog(k_atm, inputs, outputs, module_name, bad_out_name)

    return verilog_to_aiger(verilog)


def main():
    parser = argparse.ArgumentParser(description='Translate LTL spec (TLSF or Acacia format) into AIGER via k-Live automata.',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('spec', metavar='spec', type=str,
                        help='input spec (in Wring or TLSF format)')

    parser.add_argument('--k', '-k', default=8, required=False, type=int,
                        help='max number of visits to a bad state (within one SCC)')

    group = parser.add_mutually_exclusive_group()
    group.add_argument('--spot', action='store_true', default=True,
                       dest='spot',
                       help='use SPOT for translating LTL->BA')
    group.add_argument('--ltl3ba', action='store_false', default=False,
                       dest='spot',
                       help='use LTL3BA for translating LTL->BA')
    group.add_argument('--mealy', action='store_true', default=False,
                       dest='acacia_mealy',
                       help='(for Acacia only) force Mealy machines')

    group.add_argument('--noopt', action='store_true', default=False,
                       dest='noopt',
                       help='Do not strengthen the specification (using the separation into safety-liveness)')

    parser.add_argument('--out', '-o', required=False, type=str,
                        help='output AIGER file')

    parser.add_argument('-v', '--verbose', action='count', default=0)

    args = parser.parse_args()
    setup_logging(args.verbose)

    ltl_to_automaton = (translator_via_ltl3ba.LTLToAtmViaLTL3BA,
                        translator_via_spot.LTLToAtmViaSpot)[args.spot]()  # type: LTLToAutomaton

    ltl_text, part_text, is_moore = convert_tlsf_or_acacia_to_acacia(args.spec,
                                                                     not args.acacia_mealy)

    spec = parse_acacia_and_build_expr(ltl_text, part_text,
                                       ltl_to_automaton,
                                       0 if args.noopt else 2)

    ucw_automaton = ltl_to_automaton.convert(spec.formula)

    aiger_str = convert_spec_to_aiger(spec.inputs, spec.outputs, ucw_automaton, args.k, 'bad')
    if args.out:
        with open(args.out, 'w') as f:
            f.write(aiger_str)
    else:
        print(aiger_str)


if __name__ == '__main__':
    main()
