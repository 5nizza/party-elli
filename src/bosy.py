import argparse
import logging
import sys
from helpers.main_helper import setup_logging, create_spec_converter_z3
from module_generation.dot import to_dot
from parsing.parser import parse_ltl
from synthesis.solitary_model_searcher import search
from synthesis.smt_logic import UFLIA


def main(ltl_file, dot_file, bounds, ltl2ucw_converter, z3solver, logger):
    raw_ltl_spec = parse_ltl(ltl_file.read())
    ltl_spec = raw_ltl_spec

    automaton = ltl2ucw_converter.convert(ltl_spec)
    logger.info('spec automaton has {0} states'.format(len(automaton.nodes)))

    models = search(automaton, ltl_spec.inputs, ltl_spec.outputs, bounds, z3solver, UFLIA())

    logger.info('model %s found', ['', 'not'][models is None])

    if dot_file is not None and models is not None:
        for lts in models:
            dot = to_dot(lts)
            print(dot)
    #        dot_file.write(dot)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='BOunded SYnthesis Tool')
    parser.add_argument('ltl', metavar='ltl', type=argparse.FileType(),
        help='loads the LTL formula from the given input file')
    parser.add_argument('--dot', metavar='dot', type=argparse.FileType('w'), required=False,
        help='writes the output into a dot graph file')
    parser.add_argument('--bound', metavar='bound', type=int, default=2, required=False,
        help='upper bound on the size of local process (default: %(default)i)')
    parser.add_argument('--size', metavar='size', type=int, default=None, required=False,
        help='exact size of the process implementation(default: %(default)i)')
    parser.add_argument('-v', '--verbose', action='count', default=0)

    args = parser.parse_args(sys.argv[1:])

    setup_logging(args.verbose)

    ltl2ucw_converter, z3solver = create_spec_converter_z3(False)

    bounds = list(range(1, args.bound + 1) if args.size is None else range(args.size, args.size + 1))

    main(args.ltl, args.dot, bounds, ltl2ucw_converter, z3solver, logging.getLogger(__name__))

    args.ltl.close()

    if args.dot:
        args.dot.close()
