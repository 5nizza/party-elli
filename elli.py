#!/usr/bin/env python3
import argparse
import logging
import tempfile

from automata import automaton_to_dot
from automata.k_reduction import k_reduce
from config import Z3_PATH
from helpers.main_helper import setup_logging, Z3SolverFactory
from helpers.python_ext import readfile
from helpers.timer import Timer
from interfaces.LTL_to_automaton import LTLToAutomaton
from interfaces.LTS import LTS
from LTL_to_atm import translator_via_spot, translator_via_ltl3ba
from module_generation.dot import lts_to_dot
from parsing.acacia_parser_helper import parse_acacia_and_build_expr
from synthesis import model_searcher
from synthesis.cobuchi_smt_encoder import CoBuchiEncoder
from synthesis.encoder_builder import build_tau_desc, build_output_desc
from synthesis.safety_smt_encoder import SafetyEncoder
from synthesis.smt_namings import ARG_MODEL_STATE

# these are tool return values acc. to SYNTCOMP conventions
REALIZABLE = 10
UNREALIZABLE = 20
UNKNOWN = 30


def check_unreal(ltl_text, part_text, is_moore,
                 ltl_to_atm:LTLToAutomaton, solver_factory:Z3SolverFactory,
                 min_size, max_size,
                 opt_level=0,
                 ltl_to_atm_timeout_sec=0) -> LTS:
    """
    Note that opt_level > 0 may introduce unsoundness (returns unrealizable while it is).
    """
    if ltl_to_atm_timeout_sec > 0:
        logging.warning("check_unreal: you set timeout (%i sec.) for LTL to automaton translation,"
                        "but I don't support it now (I used to..)" % ltl_to_atm_timeout_sec)
    timer = Timer()
    spec = parse_acacia_and_build_expr(ltl_text, part_text, ltl_to_atm, opt_level)

    timer.sec_restart()
    automaton = ltl_to_atm.convert(spec.formula)
    logging.info('(unreal) automaton size is: %i' % len(automaton.nodes))
    logging.debug('(unreal) automaton (dot) is:\n' + automaton_to_dot.to_dot(automaton))
    logging.debug('(unreal) automaton translation took (sec): %i' % timer.sec_restart())

    # encoder = create_encoder(spec.outputs, spec.inputs, not is_moore, automaton)  # note: inputs/outputs reversed order

    # note: inputs/outputs and machine type are reversed
    tau_desc = build_tau_desc(spec.outputs)
    desc_by_output = dict((i, build_output_desc(i, not is_moore, spec.outputs))
                          for i in spec.inputs)
    encoder = CoBuchiEncoder(automaton,
                             tau_desc,
                             spec.outputs,
                             desc_by_output)

    model = model_searcher.search(min_size, max_size, encoder, solver_factory.create())
    logging.debug('(unreal) model_searcher.search took (sec): %i' % timer.sec_restart())

    return model


def check_real(ltl_text, part_text, is_moore,
               ltl_to_atm:LTLToAutomaton, solver_factory:Z3SolverFactory,
               klive:int,
               min_size, max_size,
               opt_level=2) -> LTS:
    """
    When opt_level>0, introduce incompleteness (but it is sound: if returns REAL, then REAL)
    When klive>0, reduce UCW to k-UCW.
    """
    timer = Timer()
    spec = parse_acacia_and_build_expr(ltl_text, part_text, ltl_to_atm, opt_level)

    timer.sec_restart()
    automaton = ltl_to_atm.convert(~spec.formula)
    logging.info('automaton size is: %i' % len(automaton.nodes))
    logging.debug('automaton (dot) is:\n' + automaton_to_dot.to_dot(automaton))
    logging.debug('automaton translation took (sec): %i' % timer.sec_restart())

    tau_desc = build_tau_desc(spec.inputs)
    desc_by_output = dict((o, build_output_desc(o, is_moore, spec.inputs))
                          for o in spec.outputs)
    if klive == 0:
        logging.info("using CoBuchiEncoder")
        encoder = CoBuchiEncoder(automaton,
                                 tau_desc,
                                 spec.inputs,
                                 desc_by_output)
    else:
        safety_automaton = k_reduce(automaton, klive)
        logging.info('safety automaton size is: %i' % len(safety_automaton.nodes))
        logging.info("using SafetyEncoder")
        encoder = SafetyEncoder(safety_automaton,
                                tau_desc,
                                spec.inputs,
                                desc_by_output)

    model = model_searcher.search(min_size, max_size, encoder, solver_factory.create())
    logging.debug('model_searcher.search took (sec): %i' % timer.sec_restart())

    return model


def main():
    parser = argparse.ArgumentParser(description='Bounded Synthesis Tool',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('spec', metavar='spec', type=str,
                        help='the specification file (acacia+ format)')

    group = parser.add_mutually_exclusive_group()
    group.add_argument('--moore', action='store_true', default=True,
                       dest='moore',
                       help='system is Moore')
    group.add_argument('--mealy', action='store_false',
                       default=False,
                       dest='moore',
                       help='system is Mealy')

    group = parser.add_mutually_exclusive_group()
    group.add_argument('--spot', action='store_true', default=True,
                       dest='spot',
                       help='use SPOT for translating LTL->BA')
    group.add_argument('--ltl3ba', action='store_false', default=False,
                       dest='spot',
                       help='use ltl3ba for translating LTL->BA')

    parser.add_argument('--klive', type=int, default=0,
                        help="reduce liveness to safety using parameter k"
                             "(k=0 means no reduction)")

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

    ltl_to_automaton = (translator_via_ltl3ba.LTLToAtmViaLTL3BA,
                        translator_via_spot.LTLToAtmViaSpot)[args.spot]()
    solver_factory = Z3SolverFactory(smt_files_prefix,
                                     Z3_PATH,
                                     args.incr,
                                     False,
                                     not args.tmp)

    if args.size == 0:
        min_size, max_size = 1, args.bound
    else:
        min_size, max_size = args.size, args.size

    ltl_text, part_text = readfile(args.spec), readfile(args.spec.replace('.ltl', '.part'))

    if args.unreal:
        model = check_unreal(ltl_text, part_text, args.moore,
                             ltl_to_automaton, solver_factory,
                             min_size, max_size)
    else:
        model = check_real(ltl_text, part_text, args.moore,
                           ltl_to_automaton, solver_factory,
                           args.klive,
                           min_size, max_size)

    if not model:
        logging.info('model NOT FOUND')
    else:
        logging.info('FOUND model for {who} of size {size}'.
            format(who=('sys', 'env')[args.unreal],
            size=len(model.states)))

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
