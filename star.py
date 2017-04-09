#!/usr/bin/env python3
import argparse
import logging
import tempfile

from config import Z3_PATH
from ctl2aht_ import ctl2aht
from helpers.logging_helper import log_entrance
from helpers.main_helper import setup_logging, Z3SolverFactory
from interfaces.LTL_to_automaton import LTLToAutomaton
from interfaces.LTS import LTS
from interfaces.aht_automaton import SharedAHT, DstFormulaPropMgr, get_reachable_from
from interfaces.spec import Spec
from ltl_to_automaton import translator_via_spot
from module_generation.dot import lts_to_dot
from parsing.python_parser import parse_python_spec
from synthesis import model_searcher
from synthesis.ctl_encoder_via_aht import CTLEncoderViaAHT
from synthesis.encoder_builder import build_tau_desc, build_output_desc
from synthesis.smt_namings import ARG_MODEL_STATE

REALIZABLE = 10
UNREALIZABLE = 20
UNKNOWN = 30


# def check_unreal(spec:Spec,
#                  is_moore,
#                  min_size, max_size,
#                  ctl_to_aht, solver_factory:Z3SolverFactory,
#                  atm_timeout_sec=None,
#                  opt_level=0) -> LTS:
#     """
#     :raise: subprocess.TimeoutException
#     :arg opt_level: Note that opt_level > 0 may introduce unsoundness (returns unrealizable while it is)
#     """
#     timer = Timer()
#     automaton = ctl_to_aht.convert(spec, timeout=atm_timeout_sec)  # note no negation
#     logging.info('(unreal) automaton size is: %i' % len(automaton.nodes))
#     logging.debug('(unreal) automaton (dot) is:\n' + automaton2dot.to_dot(automaton))
#     logging.debug('(unreal) automaton translation took (sec): %i' % timer.sec_restart())
#
#     encoder = create_encoder(inputs, outputs,
#                              not is_moore,
#                              automaton,
#                              solver_factory.create())
#
#     model = model_searcher.search(min_size, max_size, encoder)
#     logging.debug('(unreal) model_searcher.search took (sec): %i' % timer.sec_restart())
#
#     return model

@log_entrance()
def check_real(spec:Spec,
               min_size, max_size,
               ltl_to_atm:LTLToAutomaton,
               solver_factory:Z3SolverFactory) -> LTS:
    shared_aht, dstFormPropMgr = SharedAHT(), DstFormulaPropMgr()

    aht_automaton = ctl2aht.ctl2aht(spec, ltl_to_atm, shared_aht, dstFormPropMgr)

    aht_nodes, aht_transitions = get_reachable_from(aht_automaton.init_node,
                                                    shared_aht.transitions,
                                                    dstFormPropMgr)
    logging.info('The AHT automaton size (nodes/transitions) is: %i/%i' %
                 (len(aht_nodes), len(aht_transitions)))
    # print('(real) AHT automaton (dot) is:\n' +
    #       aht2dot.convert(aht_automaton, shared_aht, dstFormPropMgr))

    encoder = CTLEncoderViaAHT(aht_automaton, aht_transitions,
                               dstFormPropMgr,
                               build_tau_desc(spec.inputs),
                               spec.inputs,
                               dict((o, build_output_desc(o, True, spec.inputs))
                                    for o in spec.outputs))

    model = model_searcher.search(min_size, max_size, encoder, solver_factory.create())
    return model


def main():
    """ :return: 1 if model is found, 0 otherwise """

    parser = argparse.ArgumentParser(description='Bounded Synthesizer for CTL*',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('spec', metavar='spec', type=str,
                        help='the specification file (in python format)')

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
    parser.add_argument('-v', '--verbose', action='count', default=0)

    args = parser.parse_args()

    setup_logging(args.verbose, args.log)
    logging.info(args)

    if args.incr and args.tmp:
        logging.warning("--tmp --incr: incremental queries do not produce smt2 files, "
                        "so I won't save any temporal files.")

    with tempfile.NamedTemporaryFile(dir='./') as smt_file:
        smt_files_prefix = smt_file.name

    ltl_to_atm = translator_via_spot.LTLToAtmViaSpot()
    solver_factory = Z3SolverFactory(smt_files_prefix,
                                     Z3_PATH,
                                     args.incr,
                                     False,
                                     not args.tmp)

    if args.size == 0:
        min_size, max_size = 1, args.bound
    else:
        min_size, max_size = args.size, args.size

    spec = parse_python_spec(args.spec)
    model = check_real(spec, min_size, max_size, ltl_to_atm, solver_factory)

    logging.info('{status} model for {who}'.format(status=('FOUND', 'NOT FOUND')[model is None],
                                                   who='sys'))
    if model:
        dot_model_str = lts_to_dot(model, ARG_MODEL_STATE, False)

        if args.dot:
            with open(args.dot, 'w') as out:
                out.write(dot_model_str)
                logging.info('Moore model is written to {file}'.format(file=out.name))
        else:
            logging.info(dot_model_str)

    solver_factory.down_solvers()

    return UNKNOWN if model is None else REALIZABLE


if __name__ == "__main__":
    exit(main())
