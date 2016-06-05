#!/usr/bin/env python3
import argparse
import logging
import tempfile

from typing import Iterable

from helpers import automaton2dot
from helpers.main_helper import setup_logging, create_spec_converter_z3
from helpers.python_ext import readfile
from interfaces.expr import Expr, Signal
from ltl3ba.ltl2automaton import LTL3BA
from module_generation.dot import lts_to_dot
from parsing.acacia_parser_helper import parse_acacia_and_build_expr
from synthesis import model_searcher
from synthesis.encoder_builder import create_encoder
from synthesis.funcs_args_types_names import ARG_MODEL_STATE
from synthesis.smt_logic import UFLIA


def parse_acacia_spec(spec_file_name:str, ltl3ba)\
        -> (Iterable[Signal], Iterable[Signal], Expr):
    """ :return: (inputs_signals, output_signals, expr) """

    assert spec_file_name.endswith('.ltl'), spec_file_name
    ltl_file_str = readfile(spec_file_name)
    part_file_str = readfile(spec_file_name.replace('.ltl', '.part'))
    return parse_acacia_and_build_expr(ltl_file_str, part_file_str, ltl3ba)


def main(input_signals, output_signals, ltl:Expr,
         is_moore,
         dot_file_name,
         min_size, max_size,
         ltl3ba:LTL3BA,
         smt_solver):
    logging.info('LTL is:\n' + str(ltl))

    automaton = ltl3ba.convert(~ltl)

    logging.debug('automaton (dot) is:\n' + automaton2dot.to_dot(automaton))
    logging.debug(automaton)

    encoder = create_encoder(input_signals, output_signals,
                             is_moore,
                             automaton,
                             smt_solver, UFLIA(None))

    model = model_searcher.search(min_size, max_size, encoder)

    is_realizable = model is not None

    logging.info(['unrealizable', 'realizable'][is_realizable])

    if is_realizable:
        dot_model_str = lts_to_dot(model, ARG_MODEL_STATE, not is_moore)

        if dot_file_name:
            with open(dot_file_name, 'w') as out:
                out.write(dot_model_str)
                logging.info('{model_type} model is written to {file}'.format(
                             model_type=['Mealy', 'Moore'][is_moore],
                             file=out.name))
        else:
            logging.info(dot_model_str)

    return is_realizable


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Bounded Synthesis Tool',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('spec', metavar='spec', type=str,
                        help='the specification file (acacia+ format)')

    group = parser.add_mutually_exclusive_group()  # default: moore=False, mealy=True
    group.add_argument('--moore', action='store_true', default=False,
                       help='system is Moore')
    group.add_argument('--mealy', action='store_false', default=True,
                       help='system is Mealy')

    group = parser.add_mutually_exclusive_group()
    group.add_argument('--bound', metavar='bound', type=int, default=128, required=False,
                       help='upper bound on the size of the model'
                            ' (ignored for --unreal)')
    group.add_argument('--size', metavar='size', type=int, default=0, required=False,
                       help='search the model of this size'
                            ' (ignored for --unreal)')

    parser.add_argument('--incr', action='store_true', required=False, default=False,
                        help='use incremental solving')
    parser.add_argument('--tmp', action='store_true', required=False, default=False,
                        help='keep temporary smt2 files')
    parser.add_argument('--dot', metavar='dot', type=str, required=False,
                        help='write the output into a dot graph file')
    parser.add_argument('--log', metavar='log', type=str, required=False,
                        default=None,
                        help='name of the log file')
    parser.add_argument('--unreal', action='store_true', required=False,
                        help='simple check of unrealizability: '
                             'invert the spec, system type, (in/out)puts, '
                             'and synthesize the model for env '
                             '(a more sophisticated check could search for env that disproves systems of given size)')
    parser.add_argument('-v', '--verbose', action='count', default=0)

    args = parser.parse_args()

    setup_logging(args.verbose, args.log)
    logging.info(args)

    if args.incr and args.tmp:
        logging.warning("--tmp --incr: incremental queries do not produce smt2 files, "
                        "so I won't save any temporal files.")

    with tempfile.NamedTemporaryFile(dir='./') as smt_file:
        smt_files_prefix = smt_file.name

    ltl3ba, solver_factory = create_spec_converter_z3(UFLIA(None),
                                                      args.incr,
                                                      False,
                                                      smt_files_prefix,
                                                      not args.tmp)

    solver = solver_factory.create()

    input_signals, output_signals, ltl = parse_acacia_spec(args.spec, ltl3ba)

    moore = args.moore
    if args.unreal:
        input_signals, output_signals = output_signals, input_signals
        ltl = ~ltl
        moore = not args.moore

    # set the bounds:
    if args.unreal:
        min_size, max_size = 1, 128
    elif args.size == 0:
        min_size, max_size = 1, args.bound + 1
    else:
        min_size, max_size = args.size, args.size+1

    is_realizable = main(input_signals,
                         output_signals,
                         ltl,
                         moore,
                         args.dot,
                         min_size, max_size,
                         ltl3ba,
                         solver)
    if args.unreal:
        logging.info('{status_verb} model for _env_ to disprove the specification'
                     .format(status_verb=['could not find', 'found'][is_realizable]))

    solver.die()

    exit(is_realizable)
