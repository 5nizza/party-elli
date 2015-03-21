#!/usr/bin/env python3
import argparse
import sys
import tempfile
from helpers.automata_helper import to_dot
from helpers.main_helper import setup_logging, create_spec_converter_z3
from spec_optimizer.optimizations import parse_expr
from synthesis.smt_logic import UFLIA
from translation2uct.ltl2automaton import Ltl2UCW


def main(line, ltl2ucw:Ltl2UCW):
    expr = parse_expr(line)
    automaton = ltl2ucw.convert(expr)

    print(to_dot(automaton))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Translate ltl(of ltl2ba format) into UCW in dot (using ltl2ba)')

    parser.add_argument('--file', '-f', required=False, type=argparse.FileType(),
                        default=None,
                        help='input ltl file with ltl2ba property')
    parser.add_argument('--verbose', '-v', action='store_true',
                        required=False, default=False)
    parser.add_argument('--Formula', '-F', type=str, required=False, default=None)

    args = parser.parse_args(sys.argv[1:])

    logger = setup_logging(-1 if not args.verbose else 1)

    with tempfile.NamedTemporaryFile(dir='./') as smt_file:
        smt_files_prefix = smt_file.name

    converter, _ = create_spec_converter_z3(logger, UFLIA(None), False, smt_files_prefix)

    if not args.file:
        line = args.Formula
    else:
        lines = list(filter(lambda l: not l.strip().startswith("#") and l.strip(), args.file.readlines()))
        if len(lines) > 1:
            logger.critical("the file contains more than one line, suspicious!")
        line = lines[0].strip().strip(';')
    if not line:
        logger.critical('nothing to convert. exit.')
        exit(-1)

    main(line, converter)
