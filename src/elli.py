#!/usr/bin/env python3
import argparse
import logging
import tempfile

from helpers import automaton2dot
from helpers.main_helper import setup_logging, create_spec_converter_z3, Z3SolverFactory
from helpers.python_ext import readfile
from helpers.timer import Timer
from interfaces.lts import LTS
from ltl3ba.ltl2automaton import LTL3BA
from module_generation.dot import lts_to_dot
from parsing.acacia_parser_helper import parse_acacia_and_build_expr
from synthesis import model_searcher
from synthesis.encoder_builder import create_encoder
from synthesis.funcs_args_types_names import ARG_MODEL_STATE
from synthesis.smt_logic import UFLRA


REALIZABLE = 10
UNREALIZABLE = 20
UNKNOWN = 30


def check_unreal(ltl_text, part_text, is_moore,
                 ltl3ba:LTL3BA, solver_factory:Z3SolverFactory,
                 min_size, max_size,
                 ltl3ba_timeout_sec=None,
                 opt_level=0) -> LTS:
    """
    :raise: subprocess.TimeoutException
    :arg opt_level: Note that opt_level > 0 may introduce unsoundness (returns unrealizable while it is)
    """
    timer = Timer()
    outputs, inputs, expr = parse_acacia_and_build_expr(ltl_text,
                                                        part_text,
                                                        ltl3ba,
                                                        opt_level)

    timer.sec_restart()
    automaton = ltl3ba.convert(expr, timeout=ltl3ba_timeout_sec)  # note no negation
    logging.info('(unreal) automaton size is: %i' % len(automaton.nodes))
    logging.debug('(unreal) automaton (dot) is:\n' + automaton2dot.to_dot(automaton))
    logging.debug('(unreal) automaton translation took (sec): %i' % timer.sec_restart())

    encoder = create_encoder(inputs, outputs,
                             not is_moore,
                             automaton,
                             solver_factory.create())

    model = model_searcher.search(min_size, max_size, encoder)
    logging.debug('(unreal) model_searcher.search took (sec): %i' % timer.sec_restart())

    return model


def check_real(ltl_text, part_text, is_moore,
               ltl3ba, solver_factory:Z3SolverFactory,
               min_size, max_size,
               opt_level=2) -> LTS:
    """
    :param opt_level: values > 0 introduce incompleteness (but it is sound: if returns REAL, then REAL)
    """
    timer = Timer()
    inputs, outputs, expr = parse_acacia_and_build_expr(ltl_text, part_text, ltl3ba, opt_level)

    timer.sec_restart()
    automaton = ltl3ba.convert(~expr)
    logging.info('(real) automaton size is: %i' % len(automaton.nodes))
    logging.debug('(real) automaton (dot) is:\n' + automaton2dot.to_dot(automaton))
    logging.debug('(real) automaton translation took (sec): %i' % timer.sec_restart())

    encoder = create_encoder(inputs, outputs,
                             is_moore,
                             automaton,
                             solver_factory.create())

    model = model_searcher.search(min_size, max_size, encoder)
    logging.debug('(real) model_searcher.search took (sec): %i' % timer.sec_restart())

    return model


def main():
    """ :return: 1 if model is found, 0 otherwise """

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
                       help='upper bound on the size of the model (for unreal this specifies size of env model)')
    group.add_argument('--size', metavar='size', type=int, default=0, required=False,
                       help='search the model of this size (for unreal this specifies size of env model)')

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
                             '(a more sophisticated check could search for env that disproves systems of given size)'
                             '(note that the inverted spec will NOT be strengthened)')
    parser.add_argument('-v', '--verbose', action='count', default=0)

    args = parser.parse_args()

    setup_logging(args.verbose, args.log)
    logging.info(args)

    if args.incr and args.tmp:
        logging.warning("--tmp --incr: incremental queries do not produce smt2 files, "
                        "so I won't save any temporal files.")

    with tempfile.NamedTemporaryFile(dir='./') as smt_file:
        smt_files_prefix = smt_file.name

    ltl3ba, solver_factory = create_spec_converter_z3(UFLRA(),
                                                      args.incr,
                                                      False,
                                                      smt_files_prefix,
                                                      not args.tmp)
    if args.size == 0:
        min_size, max_size = 1, args.bound
    else:
        min_size, max_size = args.size, args.size

    ltl_text, part_text = readfile(args.spec), readfile(args.spec.replace('.ltl', '.part'))
    if not args.unreal:
        model = check_real(ltl_text, part_text, args.moore, ltl3ba, solver_factory, min_size, max_size)
    else:
        model = check_unreal(ltl_text, part_text, args.moore, ltl3ba, solver_factory, min_size, max_size)

    logging.info('{status} model for {who}'.format(status=('FOUND', 'NOT FOUND')[model is None],
                                                   who=('sys', 'env')[args.unreal]))
    if model:
        dot_model_str = lts_to_dot(model, ARG_MODEL_STATE, (not args.moore) ^ args.unreal)

        if args.dot:
            with open(args.dot, 'w') as out:
                out.write(dot_model_str)
                logging.info('{model_type} model is written to {file}'.format(
                             model_type=['Mealy', 'Moore'][args.moore],
                             file=out.name))
        else:
            logging.info(dot_model_str)

    solver_factory.down_solvers()

    return UNKNOWN if model is None else (REALIZABLE, UNREALIZABLE)[args.unreal]


if __name__ == "__main__":
    exit(main())
