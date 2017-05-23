#!/usr/bin/env python3

import sys
import argparse

from elli import REALIZABLE, UNREALIZABLE, UNKNOWN
from tests.common import run_benchmark


realizable = [
    # "ctl/prolonged_full_arb.py --direct --size 7",
    "ctl/resettable_arbiter.py --direct --size 3",
    "ctl/self_loop_arbiter.py --direct --size 4",
    "ctl/full_arb.py --direct --size 4",
    "ctl/non_det_arb.py --direct --size 4",
    "ctl/delayed_full_arb.py --direct --size 5",
]

unknown = [  # no model should be found for these
    "ctl/resettable_arbiter.py --direct --size 2",
    "ctl/self_loop_arbiter.py --direct --size 3",
    "ctl/full_arb.py --direct --size 3",
    "ctl/non_det_arb.py --direct --size 3",
    "ctl/delayed_full_arb.py --direct --size 4",
]


def _get_status(b):
    if b in realizable:
        return REALIZABLE
    if b in unknown:
        return UNKNOWN
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
        result = run_benchmark('star.py', benchmark, _get_status(benchmark))
        all_passed &= result

        if not args.nonstop and result is False:
            exit(1)

    print('-' * 80)
    print(['SOME TESTS FAILED', 'ALL TESTS PASSED'][all_passed])


if __name__ == '__main__':
    exit(main())