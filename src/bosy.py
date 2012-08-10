import argparse
import logging
import sys
import random
from helpers.main_helper import setup_logging, create_spec_converter_z3
from interfaces.par_spec import RingEN

from module_generation.dot import to_dot
from parsing.en_rings_parser import is_parametrized, reduce_par_ltl
from parsing.parser import parse_ltl
from synthesis.smt_logic import UFLIA, UFBV, UFLRA
from synthesis.model_searcher import search, search_parametrized
from module_generation.verilog import to_verilog


def _verilog_to_str(verilog_module):
    return verilog_module


def main(ltl_file, bounds, verilog_file, dot_file, ltl2ucw, z3solver, logic, logger):
    raw_ltl_spec = parse_ltl(ltl_file.read())

    is_par_spec = is_parametrized(raw_ltl_spec.property)
    if is_par_spec:
        architecture = RingEN()

        par_inputs, par_outputs, concrete_property, nof_processes = architecture.modify_spec(raw_ltl_spec)

        automaton = ltl2ucw.convert(ltl_spec)
        inputs = raw_ltl_spec.inputs
        outputs = raw_ltl_spec.outputs

        logger.info('spec automaton has {0} states'.format(len(automaton.nodes)))

        model = search_parametrized(architecture,
            automaton,
            inputs, outputs, nof_processes,
            bounds,
            z3solver, logic)

    else:
        ltl_spec = raw_ltl_spec

        automaton = ltl2ucw.convert(ltl_spec)

        logger.info('spec automaton has {0} states'.format(len(automaton.nodes)))

        model = search(automaton, ltl_spec.inputs, ltl_spec.outputs, bounds, z3solver, logic)


    if model is None:
        logger.info('The specification is unrealizable with input conditions.')
        return

    output = str(model)
    if verilog_file is not None:
        verilog_module = to_verilog(model)
        output = _verilog_to_str(verilog_module)
        verilog_file.write(output)

    if dot_file is not None:
        dot = to_dot(model)
        dot_file.write(dot)

    logger.info('-'*80)
    logger.info(output)


def print_hello():
    hellos = ['Welcome to BoSy!', 'Hello!', 'Hallo!', 'Privet!', 'Haai!',
              'Ciao!', 'Tere!', 'Salut!', 'Namaste!', 'Heus!', 'Goede dag!',
              'Sveiki!', 'Selam!']
    print(hellos[random.randint(0, len(hellos) - 1)])


def print_bye():
    byes = ['bye', 'wederdom', 'Poka', 'Doei', 'Sees', 'Chao', 'zai jian', 'Hasta La Vista', 'Yasou']
    print(byes[random.randint(0, len(byes) - 1)] + '!')


def _get_logic(logic):
    return {'uflra':UFLRA, 'uflia':UFLIA, 'ufbv':UFBV}[logic.lower()]()


if __name__ == "__main__":
    print_hello()

    parser = argparse.ArgumentParser(description='A synthesizer of bounded systems from LTL')
    parser.add_argument('ltl', metavar='ltl', type=argparse.FileType(),
        help='loads the LTL formula from the given input file')
    parser.add_argument('--verilog', metavar='verilog', type=argparse.FileType('w'), required=False,
        help='writes the verilog output to the given file')
    parser.add_argument('--dot', metavar='dot', type=argparse.FileType('w'), required=False,
        help='writes the output into a dot graph file')
    parser.add_argument('--bound', metavar='bound', type=int, default=1, required=False,
        help='bound the maximal size of the system to synthesize(default: %(default)i)')
    parser.add_argument('--size', metavar='size', type=int, default=None, required=False,
        help='specify exact size of the model to synthesize(default: %(default)i)')
    parser.add_argument('--logic', metavar='logic', type=str, default='uflia', required=False,
        help='logic of smt queries(uflia, ufbv)(default: %(default)i)')
    parser.add_argument('-v', '--verbose', action='count', default=0)

    args = parser.parse_args(sys.argv[1:])

    setup_logging(args.verbose)

    ltl2ucw_converter, z3solver = create_spec_converter_z3(args.acw)
    logic = _get_logic(args.logic)

    bounds = list(range(1, args.bound + 1) if args.size is None else range(args.size, args.size + 1))

    main(args.ltl, bounds, args.verilog, args.dot, ltl2ucw_converter, z3solver, logic, logging.getLogger(__name__))

    args.ltl.close()
    if args.verilog:
        args.verilog.close()

    if args.dot:
        args.dot.close()

    print_bye()
