#!/usr/bin/env python3
import argparse

from helpers.main_helper import setup_logging
from helpers.python_ext import readfile
from module_generation.verilog_to_aiger_via_yosys import verilog_to_aiger


def main():
    parser = argparse.ArgumentParser(description='Convert Verilog to AIGER',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('verilog', metavar='verilog', type=str,
                        help='input verilog file')
    parser.add_argument('-v', '--verbose', action='count', default=0)
    args = parser.parse_args()

    setup_logging(args.verbose)

    args = parser.parse_args()
    v_file = args.verilog
    print(verilog_to_aiger(readfile(v_file)))


if __name__ == '__main__':
    exit(main())
