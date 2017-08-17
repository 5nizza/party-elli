#!/usr/bin/env python3

import sys
import argparse
from typing import Tuple as Pair

from syntcomp.syntcomp_constants import REALIZABLE_STR, UNREALIZABLE_STR, UNKNOWN_STR, UNKNOWN_RC, UNREALIZABLE_RC, \
    REALIZABLE_RC
from tests.common import run_benchmark


realizable = [
    ("others/count1.ltl --moore", 2),
    ("others/count2.ltl --moore", 3),

    ("others/full_arbiter2.ltl --moore", 4),
    ("others/full_arbiter2.ltl --mealy", 3),

    ("others/pnueli_arbiter2.ltl --moore", 3),
    ("others/pnueli_arbiter2.ltl --mealy", 3),

    ("others/elevator2.ltl --moore", 2),
    ("others/elevator2.ltl --mealy", 2),

    # # using --klive
    ("others/count1.ltl --moore --maxK 5", 2),
    ("others/count2.ltl --moore --maxK 5", 3),
    #
    ("others/full_arbiter2.ltl --moore --maxK 5", 4),
    ("others/full_arbiter2.ltl --mealy --maxK 5", 3),

    ("others/pnueli_arbiter2.ltl --moore --maxK 5", 3),
    ("others/pnueli_arbiter2.ltl --mealy --maxK 5", 3),

    ("others/elevator2.ltl --moore --maxK 5", 2),
    ("others/elevator2.ltl --mealy --maxK 5", 2),

    # some random subset of tests with --incr
    ("others/count2.ltl --moore --incr", 3),
    ("others/full_arbiter2.ltl --mealy --incr", 3),

    ("others/pnueli_arbiter2.ltl --moore --incr", 3),
    ("others/pnueli_arbiter2.ltl --mealy --incr", 3),

    ("others/elevator2.ltl --mealy --incr", 2),

    ("others/immediate-arbiter-real.ltl --mealy", 1),
    ("others/unreal.ltl --mealy", 1),
]


unrealizable = [
    ("others/unreal.ltl --unreal --moore", 1),
    ("others/immediate-arbiter-unreal.ltl --unreal --mealy", 1),
    ("others/immediate-arbiter-unreal.ltl --unreal --mealy", 1),
    ("others/immediate-arbiter-real.ltl --unreal --moore", 1),

    ("others/unreal.ltl --unreal --moore --maxK 10", 1),
    ("others/immediate-arbiter-unreal.ltl --unreal --mealy --maxK 5", 2),
    ("others/immediate-arbiter-real.ltl --unreal --moore --maxK 5", 1),
]


unknown = [  # no model should be found for these
    # bug when I used strengthening in unrealizability check
    # no model should be found (iterate forever..)
    ("others/lilydemo23.ltl --mealy --unreal --bound 3", 0)
]


def main():
    parser = argparse.ArgumentParser(description='_Functional_ tests runner. '
                                                 'For _unit_ tests -- run with nosetests3')
    parser.add_argument('--nonstop', action='store_true', required=False, default=False,
                        help="don't stop on error")

    args = parser.parse_args(sys.argv[1:])
    print(args)

    all_passed = True
    for bench_size in realizable + unrealizable + unknown:
        result = run_benchmark('elli.py',
                               bench_size[0],
                               {100:REALIZABLE_RC,
                                10:UNREALIZABLE_RC,
                                1:UNKNOWN_RC}[(bench_size in realizable)*100 + (bench_size in unrealizable)*10 + (bench_size in unknown)],
                               bench_size[1])
        all_passed &= result

        if not args.nonstop and result is False:
            exit(1)

    print('-' * 80)
    print(['SOME TESTS FAILED', 'ALL TESTS PASSED'][all_passed])


if __name__ == '__main__':
    exit(main())
