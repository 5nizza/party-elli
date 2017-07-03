#!/usr/bin/env python3
import argparse
import logging

from helpers.main_helper import setup_logging
from helpers.timer import Timer
from interfaces.LTS import LTS
from module_generation.dot import lts_to_dot
from module_generation.lts_to_aiger import lts_to_aiger
from parsing.tlsf_parser import convert_tlsf_or_acacia_to_acacia
from syntcomp.syntcomp_constants import print_syntcomp_unknown, \
    print_syntcomp_unreal, print_syntcomp_real, REALIZABLE_RC, UNREALIZABLE_RC, UNKNOWN_RC
from syntcomp.task_creator import TaskCreator
from syntcomp.tasks_manager import run_synth_tasks
from synthesis.smt_namings import ARG_MODEL_STATE


def _write_dot_result(lts_dot_str, dot_file_name):
    if dot_file_name:
        with open(dot_file_name, 'w') as out:
            out.write(lts_dot_str)
            logging.info('Model is written to {file}'.format(file=out.name))
    else:
        logging.info(lts_dot_str)


def run_and_report(spec_file_name, is_moore_:bool,
                   output_file_name, dot_file_name,
                   tasks_creator:TaskCreator):
    timer = Timer()
    ltl_text, part_text, is_moore = convert_tlsf_or_acacia_to_acacia(spec_file_name, is_moore_)

    tasks = tasks_creator.create(ltl_text, part_text, is_moore)

    is_real, lts_or_aiger = run_synth_tasks(tasks)

    if is_real is None:
        logging.warning('Either crashed or did not succeed')
        print_syntcomp_unknown()
        exit(UNKNOWN_RC)

    logging.info('finished in %i sec.' % timer.sec_restart())

    if not lts_or_aiger:
        logging.info('status unknown')
        print_syntcomp_unknown()
        exit(UNKNOWN_RC)

    if not is_real:
        if isinstance(lts_or_aiger, LTS):
            lts_str = lts_to_dot(lts_or_aiger, ARG_MODEL_STATE, is_moore)  # we invert machine type
            _write_dot_result(lts_str, dot_file_name)
        print_syntcomp_unreal()
        exit(UNREALIZABLE_RC)
    else:
        if isinstance(lts_or_aiger, LTS):
            lts_str = lts_to_dot(lts_or_aiger, ARG_MODEL_STATE, not is_moore)
            logging.info('state machine size: %i' % len(lts_or_aiger.states))
            _write_dot_result(lts_str, dot_file_name)
            lts_aiger = lts_to_aiger(lts_or_aiger)
        else:
            lts_aiger = lts_or_aiger
        if output_file_name:
            with open(output_file_name, 'w') as out:
                out.write(lts_aiger)
        print_syntcomp_real(lts_aiger)
        exit(REALIZABLE_RC)


def main_template(tool_desc:str, tasks_creator:TaskCreator):
    parser = argparse.ArgumentParser(description=tool_desc,
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('spec', metavar='spec', type=str,
                        help='TLSF or Acacia (Lily) spec file')
    parser.add_argument('-o', '--output', metavar='output', type=str,
                        help='output file for a model in AIGER format '
                             '(if not given -- print to stdout)')
    parser.add_argument('--dot', metavar='dot', type=str,
                        help='write the output into a dot graph file')
    group = parser.add_mutually_exclusive_group()
    group.add_argument('--moore', action='store_true', default=True,
                       dest='moore',
                       help='system is Moore (ignored for TLSF)')
    group.add_argument('--mealy', action='store_false',
                       default=False,
                       dest='moore',
                       help='system is Mealy (ignored for TLSF)')
    parser.add_argument('-v', '--verbose', action='count', default=-1,
                        help='verbosity level')

    args = parser.parse_args()

    setup_logging(args.verbose, name_processes=True)
    logging.info(args)

    run_and_report(args.spec, args.moore, args.output, args.dot, tasks_creator)
