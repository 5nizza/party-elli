#!/usr/bin/env python3
import argparse
import logging
from pprint import pformat

from CTL_to_LTL_ import ctl2ltl
from helpers.converter_to_wring import ConverterToWringVisitor
from helpers.main_helper import setup_logging
from parsing.python_parser import parse_python_spec


def main() -> None:
    parser = argparse.ArgumentParser(description='CTL to LTL converter',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('spec', metavar='spec', type=str,
                        help='the specification file (in python format)')

    parser.add_argument('--log', metavar='log', type=str, required=False,
                        default=None,
                        help='name of the log file')

    parser.add_argument('-v', '--verbose', action='count', default=0)

    args = parser.parse_args()

    setup_logging(args.verbose, args.log)
    logging.info(args)

    spec = parse_python_spec(args.spec)

    logging.info('Input CTL spec:\n' + str(spec))
    ltl, new_outputs = ctl2ltl.convert(spec)
    logging.info('introduced outputs:\n%s', pformat(new_outputs))
    logging.info('LTL\n', ConverterToWringVisitor().dispatch(ltl))


if __name__ == "__main__":
    exit(main())
