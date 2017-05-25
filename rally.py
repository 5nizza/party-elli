#!/usr/bin/env python3
import argparse
import logging
import subprocess
import tempfile

import elli
from config import Z3_PATH
from elli import REALIZABLE, UNREALIZABLE, UNKNOWN
from helpers.main_helper import setup_logging, Z3SolverFactory
from helpers.timer import Timer
from LTL_to_atm import translator_via_spot
from module_generation.aiger import lts_to_aiger
from module_generation.dot import lts_to_dot
from parsing.tlsf_parser import convert_tlsf_to_acacia, get_spec_type
from synthesis.smt_namings import ARG_MODEL_STATE


# TODO:
# - edge-based acceptance


def main(tlsf_file_name,
         output_file_name,
         dot_file_name,
         smt_files_prefix,
         keep_temp_files) -> int:
    """ :return: REALIZABLE, UNREALIZABLE, UNKNOWN (see elli) """

    timer = Timer()
    ltl_to_atm = translator_via_spot.LTLToAtmViaSpot
    solver_factory = Z3SolverFactory(smt_files_prefix,
                                     Z3_PATH,
                                     True,
                                     False,
                                     not keep_temp_files)

    ltl_text, part_text = convert_tlsf_to_acacia(tlsf_file_name)
    is_moore = get_spec_type(tlsf_file_name)

    try:
        timer.sec_restart()
        env_model = elli.check_unreal(ltl_text, part_text, is_moore,
                                      ltl_to_atm, solver_factory,
                                      1, 1,
                                      0, 200)
        logging.info('unreal check took (sec): %i' % timer.sec_restart())
        logging.info('env model is {NOT} FOUND'.format(NOT='' if env_model else 'NOT'))
        if env_model:
            print('UNREALIZABLE')
            logging.debug(lts_to_dot(env_model, ARG_MODEL_STATE, is_moore))
            return UNREALIZABLE
    except subprocess.TimeoutExpired:
        logging.info('I aborted unreal check (>200sec). Proceed to real check.')

    model = elli.check_real(ltl_text, part_text, is_moore,
                            ltl_to_atm, solver_factory,
                            0,
                            1, 40)
    logging.info('real check took (sec): %i' % timer.sec_restart())
    logging.info('sys model is {NOT} FOUND'.format(NOT='' if model else 'NOT'))
    if not model:
        logging.info('trying check_real without formula strengthening')
        model = elli.check_real(ltl_text, part_text, is_moore,
                                ltl_to_atm, solver_factory,
                                0,
                                1, 40, opt_level=0)
        logging.info('(without formula strengthening): real check took (sec): %i' % timer.sec_restart())
        logging.info('(without formula strengthening): sys model is {NOT} FOUND'.format(NOT='' if model else 'NOT'))

    if not model:
        return UNKNOWN

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
        print('REALIZABLE')
        print(aiger_model_str)

    solver_factory.down_solvers()
    return REALIZABLE


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='elli trained for syntcomp rally',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('spec', metavar='spec', type=str,
                        help='tlsf spec file')
    parser.add_argument('-o', '--output', metavar='output', type=str,
                        help='output file for a model in the aiger format (if not given -- print to stdout)')

    parser.add_argument('--dot', metavar='dot', type=str,
                        help='write the output into a dot graph file')
    parser.add_argument('--tmp', action='store_true', default=False,
                        help='keep temporary smt2 files')
    parser.add_argument('-v', '--verbose', action='count', default=-1,
                        help='verbosity level')

    args = parser.parse_args()

    setup_logging(args.verbose)
    logging.info(args)

    with tempfile.NamedTemporaryFile(dir='./') as smt_file:
        smt_files_prefix = smt_file.name

    status = main(args.spec,
                  args.output,
                  args.dot,
                  smt_files_prefix,
                  args.tmp)
    exit(status)
