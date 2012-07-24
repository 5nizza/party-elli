import logging
import argparse
import sys
import random
import os

from interfaces.ltl_spec import LtlSpec
from module_generation.dot import to_dot
from parsing.parser import parse_ltl
from synthesis.smt_logic import UFLIA, UFBV, UFLRA
from translation2uct.ltl2automaton import Ltl2UCW, Ltl2UCW_thru_ACW
from synthesis.model_searcher import search
from synthesis.z3 import Z3
from module_generation.verilog import to_verilog


_logger = None


def _get_logger():
    global _logger
    if _logger is None:
        _logger = logging.getLogger(__name__)
    return _logger


def _verilog_to_str(verilog_module):
    return verilog_module


def main(ltl_file, size, bound, verilog_file, dot_file, ltl2ucw, z3solver, logic):
    logger = _get_logger()
    ltl_spec = parse_ltl(ltl_file.read())

    automaton = ltl2ucw.convert(ltl_spec)

    logger.info('spec automaton has {0} states'.format(len(automaton.nodes)))

    model = search(automaton, ltl_spec.inputs, ltl_spec.outputs, size, bound, z3solver, logic)

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


def _create_spec_converter_z3(use_acw):
    """ Return ltl to automaton converter, Z3 solver """

    #make paths independent of current working directory
    bosy_dir_toks = ['./'] + os.path.relpath(__file__).split(os.sep) #abspath returns 'windows' (not cygwin) path
    root_dir = ('/'.join(bosy_dir_toks[:-1]) + '/..') #root dir is one level up compared to bosy.py

    z3_path = 'z3' #assume it is in the PATH
    ltl2ba_path = root_dir + '/lib/ltl3ba/ltl3ba-1.0.1/ltl3ba'
    #

    import platform
    flag_marker = '-'
    if 'windows' in platform.system().lower() or 'nt' in platform.system().lower():
        ltl2ba_path += '.exe'
        flag_marker = '/'

    ltl2ucw = Ltl2UCW_thru_ACW if use_acw else Ltl2UCW
    return ltl2ucw(ltl2ba_path), Z3(z3_path, flag_marker)


def _setup_logging(verbose):
    level = None
    if verbose is 0:
        level = logging.INFO
    elif verbose >= 1:
        level = logging.DEBUG

    logging.basicConfig(format="%(asctime)-10s%(message)s",
                        datefmt="%H:%M:%S",
                        level=level,
                        stream=sys.stdout)


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

    automaton_type_group = parser.add_mutually_exclusive_group(required=True)
    automaton_type_group.add_argument('--acw', action='store_true',
        help='use alternating very weak automaton and translate by themselves (default: %(default)i)')
    automaton_type_group.add_argument('--ucw', action='store_true',
        help='use ucw produced by ltl3ba (default: %(default)i)')

    args = parser.parse_args(sys.argv[1:])

    _setup_logging(args.verbose)

    ltl2ucw_converter, z3solver = _create_spec_converter_z3(args.acw)
    logic = _get_logic(args.logic)

    main(args.ltl, args.size, args.bound, args.verilog, args.dot, ltl2ucw_converter, z3solver, logic)

    args.ltl.close()
    if args.verilog:
        args.verilog.close()

    if args.dot:
        args.dot.close()

    print_bye()
