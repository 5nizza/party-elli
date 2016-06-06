#!/usr/bin/env python3
import argparse
import logging
import tempfile

from typing import Iterable

from helpers import automaton2dot
from helpers.main_helper import setup_logging, create_spec_converter_z3
from helpers.python_ext import readfile
from interfaces.expr import Expr, Signal
from module_generation.aiger import lts_to_aiger
from module_generation.dot import lts_to_dot
from module_generation.verilog import lts_to_verilog
from parsing.acacia_parser_helper import parse_acacia_and_build_expr
from parsing.tlsf_parser import parse_tlsf
from synthesis import model_searcher
from synthesis.encoder_builder import create_encoder
from synthesis.funcs_args_types_names import ARG_MODEL_STATE
from synthesis.smt_logic import UFLIA

CHECK_BOTH, CHECK_REAL, CHECK_UNREAL = 'both', 'real', 'unreal'


def parse_acacia_spec(spec_file_name:str, ltl3ba)\
        -> (Iterable[Signal], Iterable[Signal], Expr):
    """ :return: (inputs_signals, output_signals, expr) """

    assert spec_file_name.endswith('.ltl'), spec_file_name
    ltl_file_str = readfile(spec_file_name)
    part_file_str = readfile(spec_file_name.replace('.ltl', '.part'))
    return parse_acacia_and_build_expr(ltl_file_str, part_file_str, ltl3ba)


def main(tlsf_file_name,
         output_file_name,
         dot_file_name,
         synthesis_type,
         smt_files_prefix,
         keep_temp_files):

    assert synthesis_type == CHECK_REAL, 'the rest is not impl yet'

    ltl3ba, solver_factory = create_spec_converter_z3(UFLIA(None),  # TODO: use UFLRA
                                                      False,
                                                      False,
                                                      smt_files_prefix,
                                                      not keep_temp_files)

    inputs, outputs, expr, is_moore = parse_tlsf(tlsf_file_name, ltl3ba)
    automaton = ltl3ba.convert(~expr)

    logging.debug('automaton (dot) is:\n' + automaton2dot.to_dot(automaton))
    logging.debug(automaton)

    encoder = create_encoder(inputs, outputs,
                             is_moore,
                             automaton,
                             solver_factory.create(), UFLIA(None))

    min_size, max_size = 1, 128   # TODO: guess better
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

        if output_file_name:
            aiger_model_str = lts_to_aiger(model)
            with open(output_file_name, 'w') as out:
                out.write(aiger_model_str)

    return is_realizable


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='elli trained for syntcomp rally',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('spec', metavar='spec', type=str,
                        help='tlsf spec file')
    parser.add_argument('-o', '--output', metavar='output', type=str,
                        help='output file for a model in the aiger format')

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

    exit(is_realizable)
