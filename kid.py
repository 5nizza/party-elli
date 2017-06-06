#!/usr/bin/env python3

import argparse
import logging

from LTL_to_atm.translator_via_spot import LTLToAtmViaSpot
from helpers.main_helper import setup_logging
from helpers.python_ext import readfile
from interfaces.LTL_to_automaton import LTLToAutomaton
from interfaces.spec import Spec
from ltl_to_aiger import convert_spec_to_aiger
from parsing.acacia_parser_helper import parse_acacia_and_build_expr
from parsing.tlsf_parser import convert_tlsf_to_acacia, get_spec_type
from rally_int import print_syntcomp_real
from syntcomp.aiger_synthesizer import synthesize
from syntcomp.syntcomp_constants import REALIZABLE_RC, UNREALIZABLE_RC, print_syntcomp_unreal, print_syntcomp_unknown, \
    UNKNOWN_RC


BAD_OUT_NAME = '__bad'


def check_unreal(ltl_text:str, part_text:str, is_moore:bool,
                 ltl_to_atm:LTLToAutomaton,
                 max_k:int) -> str or None:
    spec = parse_acacia_and_build_expr(ltl_text, part_text, ltl_to_atm, 0)
    assert BAD_OUT_NAME not in (spec.inputs | spec.outputs), 'name collision'

    neg_spec = Spec(spec.outputs, spec.inputs, ~spec.formula)
    neg_is_moore = not is_moore

    aiger_spec = convert_spec_to_aiger(neg_spec, max_k, ltl_to_atm, BAD_OUT_NAME)
    model_aiger = synthesize(aiger_spec, neg_is_moore, BAD_OUT_NAME)
    return model_aiger


def check_real(ltl_text:str, part_text:str, is_moore:bool,
               ltl_to_atm:LTLToAutomaton,
               max_k:int,
               opt_level=2) -> str or None:
    spec = parse_acacia_and_build_expr(ltl_text, part_text, ltl_to_atm, opt_level)
    assert BAD_OUT_NAME not in (spec.inputs | spec.outputs), 'name collision'
    aiger_spec = convert_spec_to_aiger(spec, max_k, ltl_to_atm, BAD_OUT_NAME)
    model_aiger = synthesize(aiger_spec, is_moore, BAD_OUT_NAME)
    return model_aiger


def main():
    parser = argparse.ArgumentParser(description='LTL synthesizer via k-reduction to AIGER',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('spec', metavar='spec', type=str,
                        help='TLSF or Wring (Acacia) spec file')
    parser.add_argument('--k', '-k', default=8, required=False, type=int,
                        help='max number of visits to a bad state (within one SCC)')
    parser.add_argument('-o', '--output', metavar='output', type=str,
                        help='output file for a model in the AIGER format (if not given -- print to stdout)')
    group = parser.add_mutually_exclusive_group()
    group.add_argument('--moore', action='store_true', default=False,
                       dest='moore',
                       help='system is Moore (ignored for TLSF)')
    group.add_argument('--mealy', action='store_false',
                       default=True,
                       dest='moore',
                       help='system is Mealy (ignored for TLSF)')
    parser.add_argument('--unreal', action='store_true', required=False,
                        help='check unrealizability: '
                             'negate the spec, system type, (in/out)puts, '
                             'and synthesize a model for the env '
                             '(note the spec will NOT be strengthened)')
    parser.add_argument('-v', '--verbose', action='count', default=-1,
                        help='verbosity level')

    args = parser.parse_args()

    setup_logging(args.verbose)
    logging.info(args)

    spec_file_name = args.spec

    if spec_file_name.endswith('.tlsf'):
        ltl_text, part_text = convert_tlsf_to_acacia(spec_file_name)
        is_moore = get_spec_type(spec_file_name)
    else:
        assert spec_file_name.endswith('.ltl')
        ltl_text, part_text = readfile(spec_file_name), readfile(spec_file_name.replace('.ltl', '.part'))
        is_moore = args.moore

    ltl_to_atm = LTLToAtmViaSpot()

    if not args.unreal:
        aiger_str = check_real(ltl_text, part_text, is_moore, ltl_to_atm, args.k)
        if aiger_str is None:
            print_syntcomp_unknown()
            return UNKNOWN_RC

        if args.output:
            with open(args.output, 'w') as out:
                out.write(aiger_str)
        print_syntcomp_real(aiger_str)
        return REALIZABLE_RC
    else:
        aiger_str = check_unreal(ltl_text, part_text, is_moore, ltl_to_atm, args.k)
        if aiger_str:
            logging.info('found model for env (not going to print it)')
            # with open('/tmp/env.aag', 'w') as out:
            #     out.write(aiger_str)
            print_syntcomp_unreal()
            return UNREALIZABLE_RC
        else:
            print_syntcomp_unknown()
            return UNKNOWN_RC


if __name__ == '__main__':
    exit(main())
