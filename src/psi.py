import argparse
import sys

def main():
    pass


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Parametrized SynthesIs Tool')
    parser.add_argument('ltl', metavar='ltl', type=argparse.FileType(),
        help='loads the LTL formula from the given input file')
    parser.add_argument('--dot', metavar='dot', type=argparse.FileType('w'), required=False,
        help='writes the output into a dot graph file')
    parser.add_argument('--bound', metavar='bound', type=int, default=2, required=False,
        help='upper bound on the size of local process (default: %(default)i)')
    parser.add_argument('--size', metavar='size', type=int, default=None, required=False,
        help='exact size of the process implementation(default: %(default)i)')
    parser.add_argument('-v', '--verbose', action='count', default=0)

    main(sys.argv[1:])

    args = parser.parse_args(sys.argv[1:])

    _setup_logging(args.verbose)

    ltl2ucw_converter, z3solver = _create_spec_converter_z3(args.acw)
    logic = _get_logic(args.logic)

    bounds = list(range(1, args.bound + 1) if args.size is None else range(args.size, args.size + 1))

    main(args.ltl, bounds, args.verilog, args.dot, ltl2ucw_converter, z3solver, logic, _get_logger())

    args.ltl.close()
    if args.verilog:
        args.verilog.close()

    if args.dot:
        args.dot.close()

    print_bye()