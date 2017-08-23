#!/usr/bin/env python3
import argparse
import logging
from pprint import pformat

from CTL_to_LTL_ import ctl2ltl, ctlstar2ltl
from LTL_to_atm.ast_to_ltl3ba import ConverterToLtl2BaFormatVisitor
from LTL_to_atm.translator_via_spot import LTLToAtmViaSpot
from helpers.main_helper import setup_logging
from module_generation import spec_to_tlsf
from parsing.python_parser import parse_python_spec


def main() -> None:
    parser = argparse.ArgumentParser(description='CTL to LTL converter',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('spec', metavar='spec', type=str,
                        help='the specification file (in python format)')

    parser.add_argument('--star', action='store_true', default=False,
                        dest='star',
                        help='force using CTL* to LTL translation for CTL formulas')

    parser.add_argument('--k', default=None, type=int,
                        help='force the value of parameter k (the number of IDs)')

    parser.add_argument('--out', '-o', default=None, type=str,
                        help='file name to output TLSF')

    parser.add_argument('--log', metavar='log', type=str, required=False,
                        default=None,
                        help='name of the log file')

    parser.add_argument('-v', '--verbose', action='count', default=0)

    args = parser.parse_args()

    setup_logging(args.verbose, args.log)
    logging.info(args)

    spec = parse_python_spec(args.spec)

    logging.info('Input spec:\n' + str(spec))

    if args.star or not is_ctl_formula(spec):
        new_spec = ctlstar2ltl.convert(spec, args.k, LTLToAtmViaSpot())
    else:
        new_spec = ctl2ltl.convert(spec)

    logging.info('introduced outputs:\n%s', pformat(new_spec.outputs - spec.outputs))
    logging.info('LTL\n%s', ConverterToLtl2BaFormatVisitor().dispatch(new_spec.formula))
    tlsf_str = spec_to_tlsf.convert(new_spec)
    print(tlsf_str)
    if args.out:
        with open(args.out, 'w') as f:
            f.write(tlsf_str)
        logging.info("output TLSF is written to: " + args.out)



if __name__ == "__main__":
    exit(main())
