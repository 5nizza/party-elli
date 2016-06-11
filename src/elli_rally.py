#!/usr/bin/env python3
import argparse
import logging
import tempfile

import elli
import helpers.timer as timer
from helpers import automaton2dot
from helpers.main_helper import setup_logging, create_spec_converter_z3, Z3SolverFactory
from ltl3ba.ltl2automaton import LTL3BA
from module_generation.aiger import lts_to_aiger
from module_generation.dot import lts_to_dot
from parsing.acacia_parser_helper import parse_acacia_and_build_expr
from parsing.tlsf_parser import convert_tlsf_to_acacia, get_spec_type
from synthesis import model_searcher
from synthesis.encoder_builder import create_encoder
from synthesis.funcs_args_types_names import ARG_MODEL_STATE
from synthesis.smt_logic import UFLRA

CHECK_BOTH, CHECK_REAL, CHECK_UNREAL = 'both', 'real', 'unreal'


def _check_unrealizability(ltl3ba:LTL3BA, solver_factory:Z3SolverFactory) -> bool:
    pass


def main(tlsf_file_name,
         output_file_name,
         dot_file_name,
         synthesis_type,
         smt_files_prefix,
         keep_temp_files) -> str:
    """ :return: 'real', 'unreal', 'unknown' """

    logic = UFLRA()

    ltl3ba, solver_factory = create_spec_converter_z3(logic,
                                                      False,
                                                      False,
                                                      smt_files_prefix,
                                                      not keep_temp_files)

    ltl_text, part_text = convert_tlsf_to_acacia(tlsf_file_name)
    is_moore = get_spec_type(tlsf_file_name)

    timer.sec_restart()
    env_model = elli.check_unreal(ltl_text, part_text, is_moore,
                                  ltl3ba, solver_factory,
                                  1, 1)
    logging.info('unreal check took (sec): %i' % timer.sec_restart())
    if env_model:
        return 'unreal'

    model = elli.check_real(ltl_text, part_text, is_moore,
                            ltl3ba, solver_factory,
                            1, 24)

    logging.info(['unrealizable within the bounds', 'realizable'][model is not None])

    if model:
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

    return ['real', 'unknown'][model is None]


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

    status = main(args.spec,
                  args.output,
                  args.dot,
                  args.check,
                  smt_files_prefix,
                  args.tmp)

    if status == 'real':
        exit(10)
    if status == 'unreal':
        exit(20)
    exit(30)   # could not find model or counter-model, thus 'unknown'
