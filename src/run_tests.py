#!/usr/bin/env python3

import sys
import argparse

from elli import REALIZABLE, UNREALIZABLE, UNKNOWN
from tests.common import run_benchmark

realizable = [
    "others/count1.ltl --moore --size 2",
    "others/count2.ltl --moore --size 3",

    "others/full_arbiter2.ltl --moore --size 4",
    "others/full_arbiter2.ltl --mealy --size 3",

    "others/pnueli_arbiter2.ltl --moore --size 3",
    "others/pnueli_arbiter2.ltl --mealy --size 3",

    "others/elevator2.ltl --moore --size 2",
    "others/elevator2.ltl --mealy --size 2",

    # some random subset of tests with --incr
    "others/count2.ltl --moore --bound 3 --incr",
    "others/full_arbiter2.ltl --mealy --bound 3 --incr",

    "others/pnueli_arbiter2.ltl --moore --bound 3 --incr",
    "others/pnueli_arbiter2.ltl --mealy --bound 3 --incr",

    "others/elevator2.ltl --mealy --bound 2 --incr",

    "others/immediate-arbiter-real.ltl --mealy --bound 5",
    "others/unreal.ltl --mealy",
]


unrealizable = [
    "others/unreal.ltl --unreal --moore",
    "others/immediate-arbiter-unreal.ltl --unreal --mealy",
    "others/immediate-arbiter-unreal.ltl --unreal --mealy",
    "others/immediate-arbiter-real.ltl --unreal --moore",
]


unknown = [  # no model should be found for these
    "others/count1.ltl --moore --size 1",
    "others/count2.ltl --moore --size 2",

    "others/full_arbiter2.ltl --moore --size 3",
    "others/full_arbiter2.ltl --mealy --size 2",

    "others/pnueli_arbiter2.ltl --moore --size 2",
    "others/pnueli_arbiter2.ltl --mealy --size 2",

    "others/elevator2.ltl --moore --size 1",
    "others/elevator2.ltl --mealy --size 1",

    # random subset for --incr
    "others/count2.ltl --moore --bound 2 --incr",
    "others/full_arbiter2.ltl --moore --bound 3 --incr",
    "others/pnueli_arbiter2.ltl --moore --bound 2 --incr",

    # bug when I used strengthening in unrealizability check
    "others/lilydemo23.ltl --mealy --unreal --size 1"
]


def _get_status(b):
    if b in realizable:
        return REALIZABLE
    if b in unrealizable:
        return UNREALIZABLE
    if b in unknown:
        return UNKNOWN
    assert 0


def main():
    parser = argparse.ArgumentParser(description='_Functional_ tests runner. '
                                                 'For _unit_ tests -- run with nosetests')
    parser.add_argument('--nonstop', action='store_true', required=False, default=False,
                        help="don't stop on error")

    args = parser.parse_args(sys.argv[1:])
    print(args)

    all_passed = True
    for benchmark in realizable + unrealizable + unknown:
        result = run_benchmark('src/elli.py', benchmark, _get_status(benchmark))
        all_passed &= result

        if not args.nonstop and result is False:
            exit(1)

    print('-' * 80)
    print(['SOME TESTS FAILED', 'ALL TESTS PASSED'][all_passed])


if __name__ == '__main__':
    exit(main())
