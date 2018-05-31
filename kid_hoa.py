#!/usr/bin/env python3

import argparse
import logging
import os

from LTL_to_atm.translator_via_spot import LTLToAtmViaSpot
from automata.atm_to_spot import convert_to_spot_automaton
from helpers.files import create_unique_file
from helpers.main_helper import setup_logging
from interfaces.LTL_to_automaton import LTLToAutomaton
from interfaces.spec import Spec
from parsing.acacia_parser_helper import parse_acacia_and_build_expr
from parsing.tlsf_parser import convert_tlsf_or_acacia_to_acacia
from syntcomp.safety_hoa_synthesizer import run_safety_hoa_synthesizer
from syntcomp.syntcomp_constants import REALIZABLE_RC, UNREALIZABLE_RC, print_syntcomp_unreal, print_syntcomp_unknown, \
    UNKNOWN_RC, print_syntcomp_real


def _check_real(spec, is_moore, ltl_to_atm, min_k, max_k) -> bool:
    ucw_atm = ltl_to_atm.convert(~spec.formula)
    logging.info("UCW automaton has %i states" % len(ucw_atm.nodes))

    spot_ucw_atm = convert_to_spot_automaton(ucw_atm)
    spot_ucw_atm = spot_ucw_atm.postprocess('SBAcc')

    hoa_file = create_unique_file(spot_ucw_atm.to_str('hoa'), '.hoa')
    part_file = create_unique_file(".inputs {inputs}\n"
                                   ".outputs {outputs}".format(inputs=' '.join(map(str, spec.inputs)),
                                                               outputs=' '.join(map(str, spec.outputs))),
                                   '.part')

    for k in range(min_k, max_k+1, 2):
        logging.info("trying k=%i..." % k)

        is_realizable = run_safety_hoa_synthesizer(hoa_file, part_file, k, is_moore)
        if is_realizable:
            break

    os.remove(hoa_file)
    os.remove(part_file)

    # noinspection PyUnboundLocalVariable
    return is_realizable


def check_unreal(ltl_text:str, part_text:str, is_moore:bool,
                 ltl_to_atm:LTLToAutomaton,
                 min_k, max_k,
                 opt_level:int) -> bool:
    spec = parse_acacia_and_build_expr(ltl_text, part_text, ltl_to_atm, opt_level)
    neg_spec = Spec(spec.outputs, spec.inputs, ~spec.formula)
    neg_is_moore = not is_moore
    return _check_real(neg_spec, neg_is_moore, ltl_to_atm, min_k, max_k)


def check_real(ltl_text:str, part_text:str, is_moore:bool,
               ltl_to_atm:LTLToAutomaton,
               min_k:int,
               max_k:int,
               opt_level:int) -> bool:
    spec = parse_acacia_and_build_expr(ltl_text, part_text, ltl_to_atm, opt_level)
    return _check_real(spec, is_moore, ltl_to_atm, min_k, max_k)


def main():
    parser = argparse.ArgumentParser(description='LTL synthesizer via reduction to safety games (avoiding AIGER)',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('spec', metavar='spec', type=str,
                        help='TLSF or Wring (Acacia) spec file')
    parser.add_argument('--minK', default=2, required=False, type=int,
                        help='min max number of visits to a bad state (within one SCC)')
    parser.add_argument('--maxK', default=8, required=False, type=int,
                        help='max max number of visits to a bad state (within one SCC)')
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
        is_real = check_real(ltl_text, part_text, is_moore, ltl_to_atm, args.minK, args.maxK, 0)
        if not is_real:
            print_syntcomp_unknown()
            return UNKNOWN_RC

        print_syntcomp_real(None)
        return REALIZABLE_RC
    else:
        is_unreal = check_unreal(ltl_text, part_text, is_moore, ltl_to_atm, args.minK, args.maxK, 0)
        if is_unreal:
            print_syntcomp_unreal()
            return UNREALIZABLE_RC
        else:
            print_syntcomp_unknown()
            return UNKNOWN_RC


if __name__ == '__main__':
    exit(main())
