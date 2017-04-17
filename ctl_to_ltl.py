#!/usr/bin/env python3
import argparse

import logging
from pprint import pprint

from ctl2ltl_ import ctl2ltl
from helpers.converter_to_wring import ConverterToWringVisitor
from helpers.main_helper import setup_logging
from parsing.python_parser import parse_python_spec


def main():
    """ :return: 1 if model is found, 0 otherwise """

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

    logging.debug('Input CTL spec:\n' + str(spec))
    ltl, new_outputs = ctl2ltl.convert(spec)
    print('introduced outputs:\n')
    pprint(new_outputs)
    print('ltl\n', ConverterToWringVisitor().dispatch(ltl))


if __name__ == "__main__":
    exit(main())
