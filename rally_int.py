#!/usr/bin/env python3
import argparse
import logging
import signal

import elli
from LTL_to_atm import translator_via_spot
from config import Z3_PATH
from helpers.main_helper import setup_logging
from helpers.timer import Timer
from module_generation.dot import lts_to_dot
from module_generation.lts_to_aiger import lts_to_aiger
from parsing.tlsf_parser import convert_tlsf_or_acacia_to_acacia
from syntcomp.syntcomp_constants import print_syntcomp_unknown, \
    print_syntcomp_unreal, print_syntcomp_real, REALIZABLE_RC, UNREALIZABLE_RC, UNKNOWN_RC
from syntcomp.tasks_manager import Task, run_synth_tasks
from synthesis.smt_namings import ARG_MODEL_STATE
from synthesis.z3_via_pipe import Z3InteractiveViaPipes


# TODO:
# - edge-based acceptance
# - last.log from many processes
# - real check without strengthening


class ElliIntRealTask(Task):
    def __init__(self, name, ltl_text, part_text, is_moore, min_size, max_size, opt_level):
        super().__init__(name, True)
        self.name = name
        self.ltl_text = ltl_text
        self.part_text = part_text
        self.is_moore = is_moore
        self.min_size = min_size
        self.max_size = max_size
        self.opt_level = opt_level

    def do(self):
        solver = Z3InteractiveViaPipes(Z3_PATH)
        try:
            return elli.check_real(self.ltl_text, self.part_text,
                                   self.is_moore,
                                   translator_via_spot.LTLToAtmViaSpot(),
                                   solver,
                                   0,
                                   self.min_size, self.max_size)
        finally:
            solver.die()


class ElliIntUnrealTask(Task):
    def __init__(self, name, ltl_text, part_text, is_moore, min_size, max_size, opt_level, timeout):
        super().__init__(name, False)
        self.ltl_text = ltl_text
        self.part_text = part_text
        self.is_moore = is_moore
        self.min_size = min_size
        self.max_size = max_size
        self.opt_level = opt_level
        self.timeout = timeout

    def do(self):
        class TimeoutException(Exception):
            pass

        if self.timeout:
            logging.info('CheckUnrealTask: setting timeout to %i' % self.timeout)
            def signal_handler(sig, _):
                if sig == signal.SIGALRM:
                    raise TimeoutException("CheckUnrealTask: timeout reached")
            signal.signal(signal.SIGALRM, signal_handler)
            signal.alarm(self.timeout)

        solver = Z3InteractiveViaPipes(Z3_PATH)
        try:
            return elli.check_unreal(self.ltl_text, self.part_text,
                                     self.is_moore,
                                     translator_via_spot.LTLToAtmViaSpot(),
                                     solver,
                                     0,
                                     self.min_size, self.max_size)
        except TimeoutException:
            return None
        finally:
            solver.die()


def write_dot_result(lts_dot_str, dot_file_name):
    if dot_file_name:
        with open(dot_file_name, 'w') as out:
            out.write(lts_dot_str)
            logging.info('Model is written to {file}'.format(file=out.name))
    else:
        logging.info(lts_dot_str)


def main(spec_file_name, is_moore_:bool, output_file_name, dot_file_name):
    timer = Timer()
    ltl_text, part_text, is_moore = convert_tlsf_or_acacia_to_acacia(spec_file_name, is_moore_)

    elli_int_real = ElliIntRealTask('check real',
                                    ltl_text, part_text, is_moore,
                                    1, 20, 0)
    elli_int_unreal = ElliIntUnrealTask('check unreal (short)',
                                        ltl_text, part_text, is_moore,
                                        1, 10, 0, timeout=1200)

    is_real, lts = run_synth_tasks([elli_int_real, elli_int_unreal])

    logging.info('finished in %i sec.' % timer.sec_restart())

    if not lts:
        logging.info('status unknown')
        print_syntcomp_unknown()
        exit(UNKNOWN_RC)

    if not is_real:
        lts_str = lts_to_dot(lts, ARG_MODEL_STATE, is_moore)  # we invert machine type
        write_dot_result(lts_str, dot_file_name)
        print_syntcomp_unreal()
        exit(UNREALIZABLE_RC)
    else:
        lts_str = lts_to_dot(lts, ARG_MODEL_STATE, not is_moore)
        logging.info('state machine size: %i' % len(lts.states))
        lts_aiger = lts_to_aiger(lts)
        write_dot_result(lts_str, dot_file_name)
        if output_file_name:
            with open(output_file_name, 'w') as out:
                out.write(lts_aiger)
        print_syntcomp_real(lts_aiger)
        exit(REALIZABLE_RC)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='SMT-based bounded synthesizer, with integers for ranks',
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

    main(args.spec, args.moore, args.output, args.dot)
