#!/usr/bin/env python3
import argparse
import logging
import tempfile

import helpers.timer as timer
from helpers import automaton2dot
from helpers.main_helper import setup_logging, create_spec_converter_z3
from module_generation.aiger import lts_to_aiger
from module_generation.dot import lts_to_dot
from parsing.tlsf_parser import parse_tlsf_build_expr
from synthesis import model_searcher
from synthesis.encoder_builder import create_encoder
from synthesis.funcs_args_types_names import ARG_MODEL_STATE
from synthesis.smt_logic import UFLRA

CHECK_BOTH, CHECK_REAL, CHECK_UNREAL = 'both', 'real', 'unreal'


def main(tlsf_file_name,
         output_file_name,
         dot_file_name,
         synthesis_type,
         smt_files_prefix,
         keep_temp_files):
    logic = UFLRA()

    assert synthesis_type == CHECK_REAL, 'the rest is not impl yet'

    ltl3ba, solver_factory = create_spec_converter_z3(logic,
                                                      False,
                                                      False,
                                                      smt_files_prefix,
                                                      not keep_temp_files)

    timer.sec_restart()

    inputs, outputs, expr, is_moore = parse_tlsf_build_expr(tlsf_file_name, ltl3ba)
    logging.info('parsing and building expr took (sec): %i' % timer.sec_restart())

    automaton = ltl3ba.convert(~expr)
    logging.info('automata translation took (sec): %i' % timer.sec_restart())
    logging.info('automaton size is: %i' % len(automaton.nodes))
    logging.debug('automaton (dot) is:\n' + automaton2dot.to_dot(automaton))

    encoder = create_encoder(inputs, outputs,
                             is_moore,
                             automaton,
                             solver_factory.create(),
                             logic)

    model = model_searcher.search(1, 24, encoder)  # TODO: guess better min max sizes
    logging.info('model_searcher.search took (sec): %i' %timer.sec_restart())

    is_realizable = model is not None

    logging.info(['unrealizable within the bounds', 'realizable'][is_realizable])

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

        aiger_model_str = lts_to_aiger(model)
        logging.info('circuit size: %i' % len(model.states))

        if output_file_name:
            with open(output_file_name, 'w') as out:
                out.write(aiger_model_str)
        else:
            print(aiger_model_str)

    solver_factory.down_solvers()

    return is_realizable


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='elli trained for syntcomp rally',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('spec', metavar='spec', type=str,
                        help='tlsf spec file')
    parser.add_argument('-o', '--output', metavar='output', type=str,
                        help='output file for a model in the aiger format (if not given -- print to stdout)')

    parser.add_argument('--check',
                        choices=(CHECK_BOTH, CHECK_REAL, CHECK_UNREAL),
                        default=CHECK_BOTH,
                        help='what type of the check')

    parser.add_argument('--dot', metavar='dot', type=str,
                        help='write the output into a dot graph file')
    parser.add_argument('--tmp', action='store_true', default=False,
                        help='keep temporary smt2 files')
    parser.add_argument('-v', '--verbose', action='count', default=-1,
                        help='verbosity level')

    args = parser.parse_args()
    assert args.check == CHECK_REAL

    setup_logging(args.verbose)
    logging.info(args)

    with tempfile.NamedTemporaryFile(dir='./') as smt_file:
        smt_files_prefix = smt_file.name

    is_realizable = main(args.spec,
                         args.output,
                         args.dot,
                         args.check,
                         smt_files_prefix,
                         args.tmp)

    exit([20, 10][is_realizable])
