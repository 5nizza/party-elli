#!/usr/bin/env python3
import argparse
import logging
import signal
from multiprocessing import Process, Queue
from typing import Iterable

import elli
from LTL_to_atm import translator_via_spot
from config import Z3_PATH
from helpers.main_helper import setup_logging
from helpers.timer import Timer
from module_generation.dot import lts_to_dot
from module_generation.lts_to_aiger import lts_to_aiger
from parsing.tlsf_parser import convert_tlsf_to_acacia, get_spec_type
from syntcomp.syntcomp_constants import print_syntcomp_unknown, \
    print_syntcomp_unreal, print_syntcomp_real
from synthesis.smt_namings import ARG_MODEL_STATE
from synthesis.z3_via_pipe import Z3InteractiveViaPipes


# TODO:
# - edge-based acceptance
# - last.log from many processes
# - real check without strengthening


class CheckRealTask:
    def __init__(self, name, ltl_text, part_text, is_moore, min_size, max_size, max_k, opt_level):
        self.name = name
        self.ltl_text = ltl_text
        self.part_text = part_text
        self.is_moore = is_moore
        self.min_size = min_size
        self.max_size = max_size
        self.max_k = max_k
        self.opt_level = opt_level

    def do(self):
        solver = Z3InteractiveViaPipes(Z3_PATH)
        try:
            return elli.check_real(self.ltl_text, self.part_text,
                                   self.is_moore,
                                   translator_via_spot.LTLToAtmViaSpot(),
                                   solver,
                                   self.max_k,
                                   self.min_size, self.max_size)
        finally:
            solver.die()


class CheckUnrealTask:
    def __init__(self, name, ltl_text, part_text, is_moore, min_size, max_size, max_k, opt_level, timeout):
        self.name = name
        self.ltl_text = ltl_text
        self.part_text = part_text
        self.is_moore = is_moore
        self.min_size = min_size
        self.max_size = max_size
        self.max_k = max_k
        self.opt_level = opt_level
        self.timeout = timeout

    def do(self):
        class TimeoutException(Exception):
            pass

        if self.timeout:
            logging.info('CheckUnrealTask: setting timeout to %i' % self.timeout)
            def signal_handler(sig, frame):
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
                                     self.max_k,
                                     self.min_size, self.max_size)
        except TimeoutException:
            return None
        finally:
            solver.die()


def starter(q:Queue, task: CheckRealTask or CheckUnrealTask):
    res = task.do()
    q.put((task, res))


def kill_them(processes:Iterable[Process]):
    for p in processes:
        p.terminate()
        p.join()


def write_dot_result(status, lts_dot_str, dot_file_name):
    logging.info('status ' + status)
    if dot_file_name:
        with open(dot_file_name, 'w') as out:
            out.write(lts_dot_str)
            logging.info('Model is written to {file}'.format(file=out.name))
    else:
        logging.info(lts_dot_str)


def main(tlsf_file_name,
         output_file_name,
         dot_file_name):
    timer = Timer()
    ltl_text, part_text = convert_tlsf_to_acacia(tlsf_file_name)
    is_moore = get_spec_type(tlsf_file_name)

    # log_to_stderr()

    q = Queue()
    p_real = Process(target=starter,
                     args=(q, CheckRealTask('check real',
                                            ltl_text, part_text, is_moore,
                                            1, 20, 20, 2)))
    p_unreal = Process(target=starter,
                       args=(q, CheckUnrealTask('check unreal (short)',
                                                ltl_text, part_text, is_moore,
                                                1, 10, 20, 0, timeout=600)))
    p_real.start()
    p_unreal.start()
    nof_processes = 2
    lts, task = None, None   # .. to shut up pycharm warnings
    for _ in range(nof_processes):
        task, lts = q.get()  # type: (CheckRealTask or CheckUnrealTask, LTS or None)
        if lts is None:
            logging.info('task did not succeed: ' + task.name)
            logging.info('waiting for others..')
        else:
            break

    kill_them((p_real, p_unreal))

    if not lts:
        logging.info('status unknown')
        print_syntcomp_unknown()
        exit()

    logging.info('finished in %i sec.' % timer.sec_restart())

    if isinstance(task, CheckUnrealTask):
        lts_str = lts_to_dot(lts, ARG_MODEL_STATE, is_moore)  # we invert machine type
        write_dot_result('unrealizable', lts_str, dot_file_name)
        print_syntcomp_unreal()
    else:
        lts_str = lts_to_dot(lts, ARG_MODEL_STATE, not is_moore)
        logging.info('state machine size: %i' % len(lts.states))
        lts_aiger = lts_to_aiger(lts)
        write_dot_result('realizable', lts_str, dot_file_name)
        if output_file_name:
            with open(output_file_name, 'w') as out:
                out.write(lts_aiger)
        print_syntcomp_real(lts_aiger)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='elli trained for syntcomp rally',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('spec', metavar='spec', type=str,
                        help='tlsf spec file')
    parser.add_argument('-o', '--output', metavar='output', type=str,
                        help='output file for a model in the aiger format (if not given -- print to stdout)')

    parser.add_argument('--dot', metavar='dot', type=str,
                        help='write the output into a dot graph file')
    # parser.add_argument('--tmp', action='store_true', default=False,
    #                     help='keep temporary smt2 files')
    parser.add_argument('-v', '--verbose', action='count', default=-1,
                        help='verbosity level')

    args = parser.parse_args()

    setup_logging(args.verbose, name_processes=True)
    logging.info(args)

    main(args.spec, args.output, args.dot)
