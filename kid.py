#!/usr/bin/env python3

import argparse
import logging

from LTL_to_atm.translator_via_spot import LTLToAtmViaSpot
from automata.k_reduction import k_reduce
from helpers.main_helper import setup_logging
from interfaces.LTL_to_automaton import LTLToAutomaton
from interfaces.spec import Spec
from module_generation.automaton_to_verilog import atm_to_verilog
from module_generation.verilog_to_aiger_via_yosys import verilog_to_aiger
from parsing.acacia_parser_helper import parse_acacia_and_build_expr
from parsing.tlsf_parser import convert_tlsf_or_acacia_to_acacia
from syntcomp.aiger_synthesizer import synthesize
from syntcomp.syntcomp_constants import REALIZABLE_RC, UNREALIZABLE_RC, print_syntcomp_unreal, print_syntcomp_unknown, \
    UNKNOWN_RC, print_syntcomp_real


BAD_OUT_NAME = '__bad'


def _check_real(spec, is_moore, ltl_to_atm, min_k, max_k) -> str:
    ucw_atm = ltl_to_atm.convert(~spec.formula)
    logging.info("UCW automaton has %i states" % len(ucw_atm.nodes))

    model_aiger = None
    for k in range(min_k, max_k+1):
        logging.info("setting k to %i..." % k)
        k_atm = k_reduce(ucw_atm, k)
        logging.info("k-LA automaton has %i states" % len(k_atm.nodes))

        aiger_spec = verilog_to_aiger(atm_to_verilog(k_atm,
                                                     spec.inputs, spec.outputs,
                                                     'automaton', BAD_OUT_NAME))
        model_aiger = synthesize(aiger_spec, is_moore, BAD_OUT_NAME)
        if model_aiger:
            return model_aiger
    return model_aiger


def check_unreal(ltl_text:str, part_text:str, is_moore:bool,
                 ltl_to_atm:LTLToAutomaton,
                 min_k, max_k,
                 opt_level:int) -> str or None:
    spec = parse_acacia_and_build_expr(ltl_text, part_text, ltl_to_atm, opt_level)
    assert BAD_OUT_NAME not in (spec.inputs | spec.outputs), 'name collision'
    neg_spec = Spec(spec.outputs, spec.inputs, ~spec.formula)
    neg_is_moore = not is_moore
    return _check_real(neg_spec, neg_is_moore, ltl_to_atm, min_k, max_k)


def check_real(ltl_text:str, part_text:str, is_moore:bool,
               ltl_to_atm:LTLToAutomaton,
               min_k:int,
               max_k:int,
               opt_level:int) -> str or None:
    spec = parse_acacia_and_build_expr(ltl_text, part_text, ltl_to_atm, opt_level)
    assert BAD_OUT_NAME not in (spec.inputs | spec.outputs), 'name collision'
    return _check_real(spec, is_moore, ltl_to_atm, min_k, max_k)


def main():
    parser = argparse.ArgumentParser(description='LTL synthesizer via k-reduction to AIGER',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('spec', metavar='spec', type=str,
                        help='TLSF or Wring (Acacia) spec file')
    parser.add_argument('--minK', default=2, required=False, type=int,
                        help='min max number of visits to a bad state (within one SCC)')
    parser.add_argument('--maxK', default=8, required=False, type=int,
                        help='max max number of visits to a bad state (within one SCC)')
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
    parser.add_argument('-v', '--verbose', action='count', default=0,
                        help='verbosity level')

    args = parser.parse_args()

    setup_logging(args.verbose)
    logging.info(args)

    ltl_text, part_text, is_moore = convert_tlsf_or_acacia_to_acacia(args.spec, args.moore)

    ltl_to_atm = LTLToAtmViaSpot()

    if not args.unreal:
        aiger_str = check_real(ltl_text, part_text, is_moore, ltl_to_atm, args.minK, args.maxK, 0)
        if aiger_str is None:
            print_syntcomp_unknown()
            return UNKNOWN_RC

        if args.output:
            with open(args.output, 'w') as out:
                out.write(aiger_str)
        print_syntcomp_real(aiger_str)
        return REALIZABLE_RC
    else:
        aiger_str = check_unreal(ltl_text, part_text, is_moore, ltl_to_atm, args.minK, args.maxK, 0)
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
