#!/usr/bin/env python3
import os
import argparse

import logging

import check_model
from helpers.files import create_unique_file
from helpers.main_helper import setup_logging
from helpers.shell import execute_shell, rc_out_err_to_str
from syntcomp.syntcomp_constants import\
    REALIZABLE_RC as R_RC, \
    UNREALIZABLE_RC as U_RC, \
    UNKNOWN_RC as UNKN_RC,\
    UNREALIZABLE_STR as U_STR,\
    REALIZABLE_STR as R_STR
from tests.common import BENCHMARKS_DIR

easy = (
    (0, "tlsf/parameterized/round_robin_arbiter_unreal1.tlsf"),
    (0, "tlsf/parameterized/round_robin_arbiter_unreal2.tlsf"),
    (0, "tlsf/parameterized/prioritized_arbiter_unreal1.tlsf"),
    (0, "tlsf/parameterized/prioritized_arbiter_unreal2.tlsf"),
    (0, "tlsf/parameterized/prioritized_arbiter_unreal3.tlsf"),
    (0, "tlsf/parameterized/load_balancer_unreal1.tlsf"),
    (0, "tlsf/parameterized/load_balancer_unreal2.tlsf"),


    (1, "tlsf/parameterized/simple_arbiter.tlsf"),
    (1, "tlsf/parameterized/detector.tlsf"),
    (1, "tlsf/parameterized/full_arbiter.tlsf"),
    (1, "tlsf/parameterized/load_balancer.tlsf"),
    (1, "tlsf/parameterized/round_robin_arbiter.tlsf"),
    (1, "tlsf/parameterized/round_robin_arbiter2.tlsf"),
    (1, "tlsf/parameterized/prioritized_arbiter.tlsf"),
    (1, "tlsf/mealy_moore_real.tlsf"),
    (0, "tlsf/mealy_moore_unreal.tlsf"),
    (0, "tlsf/parameterized/simple_arbiter_unreal1.tlsf"),
    (0, "tlsf/parameterized/simple_arbiter_unreal2.tlsf"),
    (0, "tlsf/parameterized/simple_arbiter_unreal3.tlsf"),
    (0, "tlsf/parameterized/detector_unreal.tlsf"),
    (0, "tlsf/parameterized/full_arbiter_unreal1.tlsf"),
    (0, "tlsf/parameterized/full_arbiter_unreal2.tlsf"),
)


hard = (
    (1, "tlsf/parameterized/generalized_buffer.tlsf"),
    (1, "tlsf/parameterized/amba_case_study.tlsf"),

    (0, "tlsf/parameterized/generalized_buffer_unreal1.tlsf"),
    (0, "tlsf/parameterized/generalized_buffer_unreal2.tlsf"),
    (0, "tlsf/parameterized/amba_case_study_unreal1.tlsf"),
    (0, "tlsf/parameterized/amba_case_study_unreal2.tlsf"),

    (0, "tlsf/parameterized/full_arbiter_unreal3.tlsf"),
)


def _run_benchmark(solver:str, is_real:bool, bench_file_name:str, mc:bool) -> str or None:
    str_by_rc = {R_RC:'real_rc', U_RC:'unreal_rc', UNKN_RC:'unknown_rc'}

    rc, out, err = execute_shell('{solver} {bench}'.format(solver=solver, bench=bench_file_name))
    if rc not in (U_RC, R_RC, UNKN_RC):
        return rc_out_err_to_str(rc, out, err)

    exp_rc = (U_RC, R_RC)[is_real]
    if exp_rc != rc:
        return 'Realizability differs (expected vs. actual): %s vs. %s'\
               % (str_by_rc[exp_rc], str_by_rc[rc])

    out_lines = out.splitlines()
    if (is_real and out_lines[0] != R_STR) or (not is_real and out_lines[0] != U_STR):
        return 'stdout first line should be %s, got instead: %s'\
               % ((U_STR, R_STR)[is_real], out_lines[0])

    if not mc or not is_real:
        return None

    aiger_solution = '\n'.join(out_lines[1:])
    aiger_solution_file_name = create_unique_file(aiger_solution)
    is_correct = check_model.main(aiger_solution_file_name, bench_file_name, False)
    if not is_correct:
        return "the model is wrong"
    os.remove(aiger_solution_file_name)
    return None


def main():
    parser = argparse.ArgumentParser(description='I check a TLSF SYNTCOMP solver on several benchmarks',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('solver', metavar='solver', type=str,
                        help='Solver command (I will run using "<solver> <tlsf_spec>")')
    parser.add_argument('--all', action='store_true', required=False, default=False,
                        help="run all benchmarks including the hard ones")
    parser.add_argument('--nonstop', action='store_true', required=False, default=False,
                        help="don't stop on error")
    parser.add_argument('--mc', action='store_true', required=False, default=False,
                        help="model check the results")
    parser.add_argument('-v', '--verbose', action='count', default=0)

    args = parser.parse_args()
    setup_logging(args.verbose)
    logging.info(args)

    benchmarks = easy if not args.all else easy + hard

    all_passed = True
    for is_real, bench in benchmarks:
        logging.info('testing ' + BENCHMARKS_DIR + bench)
        fail_reason = _run_benchmark(args.solver, is_real==1, BENCHMARKS_DIR + bench, args.mc)
        if fail_reason:
            all_passed = False
            logging.info('test failed, reason:\n' + fail_reason)
            if not args.nonstop:
                return 1

    logging.info('-' * 80)
    logging.info(['SOME TESTS FAILED', 'ALL TESTS PASSED'][all_passed])
    return 0


if __name__ == '__main__':
    exit(main())
