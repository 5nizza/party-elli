#!/usr/bin/env python3

import argparse

from LTL_to_atm import translator_via_ltl3ba, translator_via_spot
from automata.automaton_to_dot import to_dot
from automata.k_reduction import k_reduce
from helpers.main_helper import setup_logging
from helpers.python_ext import readfile
from interfaces.LTL_to_automaton import LTLToAutomaton
from interfaces.spec import Spec
from module_generation.aiger import verilog_to_aiger
from module_generation.automaton_to_verilog import atm_to_verilog
from parsing.acacia_parser_helper import parse_acacia_and_build_expr


def convert_spec_to_aiger(spec:Spec, k:int, ltl_to_automaton:LTLToAutomaton) -> str:
    atm = ltl_to_automaton.convert(spec.formula)
    with open('/tmp/orig.dot', 'w') as f:
        f.write(to_dot(atm))

    k_atm = k_reduce(atm, k)

    with open('/tmp/red.dot', 'w') as f:
        f.write(to_dot(k_atm))

    verilog = atm_to_verilog(k_atm, spec.inputs, spec.outputs)
    return verilog_to_aiger(verilog)


def main():
    parser = argparse.ArgumentParser(description='Translate Spec Into AIGER via k-Live Automata',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('spec', metavar='spec', type=str,
                        help='input spec (in Wring format)')

    parser.add_argument('--k', '-k', default=8, required=False, type=int,
                        help='max number of visits to a bad state (within one SCC)')

    group = parser.add_mutually_exclusive_group()
    group.add_argument('--spot', action='store_true', default=True,
                       dest='spot',
                       help='use SPOT for translating LTL->BA')
    group.add_argument('--ltl3ba', action='store_false', default=False,
                       dest='spot',
                       help='use LTL3BA for translating LTL->BA')

    parser.add_argument('--out', '-o', required=False, type=str,
                        help='output AIGER file')

    parser.add_argument('-v', '--verbose', action='count', default=0)

    args = parser.parse_args()
    setup_logging(args.verbose)

    ltl_to_automaton = (translator_via_ltl3ba.LTLToAtmViaLTL3BA,
                        translator_via_spot.LTLToAtmViaSpot)[args.spot]()

    spec = parse_acacia_and_build_expr(readfile(args.spec),
                                       readfile(args.spec.replace('.ltl', '.part')),
                                       ltl_to_automaton,
                                       2)

    aiger_str = convert_spec_to_aiger(spec, args.k, ltl_to_automaton)
    if args.out:
        with open(args.out, 'w') as f:
            f.write(aiger_str)
    else:
        print(aiger_str)


if __name__ == '__main__':
    main()