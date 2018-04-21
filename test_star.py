#!/usr/bin/env python3

import sys
import argparse

from syntcomp.syntcomp_constants import REALIZABLE_RC, UNKNOWN_RC
from tests.common import run_benchmark


realizable = [
    # "ctl/prolonged_full_arb.py --direct --size 7",
    "ctl/resettable_arbiter.py --direct --size 3",
    "ctl/self_loop_arbiter.py --direct --size 4",
    "ctl/full_arb.py --direct --size 4",
    "ctl/non_det_arb.py --direct --size 4",
    "ctl/delayed_full_arb.py --direct --size 5",

    # "ctl/prolonged_full_arb.py --aht --size 7",  # takes too much time
    "ctl/resettable_arbiter.py --aht --size 3",
    "ctl/self_loop_arbiter.py --aht --size 4",
    "ctl/full_arb.py --aht --size 4",
    "ctl/non_det_arb.py --aht --size 4",
    # "ctl/delayed_full_arb.py --aht --size 5",   # takes too much time
]

unknown = [  # no model should be found for these
    "ctl/resettable_arbiter.py --direct --size 2",
    "ctl/self_loop_arbiter.py --direct --size 3",
    "ctl/full_arb.py --direct --size 3",
    "ctl/non_det_arb.py --direct --size 3",
    "ctl/delayed_full_arb.py --direct --size 4",

    "ctl/resettable_arbiter.py --aht --size 2",
    "ctl/self_loop_arbiter.py --aht --size 3",
    "ctl/full_arb.py --aht --size 3",
    "ctl/non_det_arb.py --aht --size 3",
    # "ctl/delayed_full_arb.py --aht --size 4",
]


def _get_status(b):
    if b in realizable:
        return REALIZABLE_RC
    if b in unknown:
        return UNKNOWN_RC
    assert 0


def main():
    parser = argparse.ArgumentParser(description='_Functional_ tests runner for star.py '
                                                 'For _unit_ tests -- run with nosetests3')
    parser.add_argument('--nonstop', action='store_true', required=False, default=False,
                        help="don't stop on error")

    args = parser.parse_args(sys.argv[1:])
    print(args)

    all_passed = True
    for benchmark in realizable + unknown:
        # TODO: should be separated into two separate loops,
        #       for realizable benchmarks: set size_expected
        #       for unknown: use None
        print('testing ' + benchmark)
        result = run_benchmark('star.py', benchmark, _get_status(benchmark), None)
        all_passed &= result

        if not args.nonstop and result is False:
            exit(1)

    print('-' * 80)
    print(['SOME TESTS FAILED', 'ALL TESTS PASSED'][all_passed])


if __name__ == '__main__':
    exit(main())
