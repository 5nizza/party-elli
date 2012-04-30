import logging
import argparse
import sys
import random
import os

from interfaces.ltl_spec import LtlSpec
from module_generation.dot import to_dot
from translation2uct.ltl2uct import Ltl2Uct
from synthesis.model_searcher import search
from synthesis.z3 import Z3
from module_generation.verilog import to_verilog


_logger = None


def _get_logger():
    global _logger
    if _logger is None:
        _logger = logging.getLogger(__name__)
    return _logger


def _parse_ltl(text):
    inputs = []
    outputs = []
    for l in text.strip().split('\n'):
        if 'INPUT:' in l:
            i = l.replace('INPUT:', '').strip()
            inputs.append(i)
        elif 'OUTPUT:' in l:
            o = l.replace('OUTPUT:', '').strip()
            outputs.append(o)
        elif 'PROPERTY:' in l:
            p = l.replace('PROPERTY:', '').strip()
            property = p
        else:
            assert False, 'unknown input line: ' + l

    return LtlSpec(inputs, outputs, property)


def _verilog_to_str(verilog_module):
    return verilog_module


def main(ltl_file, bound, verilog_file, dot_file, ltl2uct, z3solver):
    logger = _get_logger()
    ltl_spec = _parse_ltl(ltl_file.read())

    uct = ltl2uct.convert(ltl_spec)

    model = search(uct, ltl_spec.inputs, ltl_spec.outputs, bound, z3solver)

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


def _create_ltl2uct_z3():
    """ Return ltl2uct converter, Z3 solver """

    #make paths independent of current working directory
    bosy_dir_toks = ['./'] + os.path.relpath(__file__).split(os.sep) #abspath returns 'windows' (not cygwin) path
    root_dir = ('/'.join(bosy_dir_toks[:-1]) + '/..') #root dir is one level up compared to bosy.py

    z3_path = root_dir + '/lib/z3/bin/z3'
    ltl2ba_path = root_dir + '/lib/ltl2ba-1.1/ltl2ba'
    #

    import platform
    flag = '-'
    if 'windows' in platform.system().lower() or 'nt' in platform.system().lower():
        ltl2ba_path += '.exe'
        z3_path = 'z3' #assume z3 bin directory is in the PATH
        flag = '/'

    return Ltl2Uct(ltl2ba_path), Z3(z3_path, flag)


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
    parser.add_argument('-v', '--verbose', action='count', default=0)

    args = parser.parse_args(sys.argv[1:])

    _setup_logging(args.verbose)

    ltl2uct, z3solver = _create_ltl2uct_z3()

    main(args.ltl, args.bound, args.verilog, args.dot, ltl2uct, z3solver)

    args.ltl.close()
    if args.verilog:
        args.verilog.close()

    if args.dot:
        args.dot.close()

    print_bye()
