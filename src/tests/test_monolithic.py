import os
import sys
# to inform python where to look for packages
sys.path.append(os.path.dirname(os.path.realpath(__file__)) + '/../')


import argparse
from tests.common import run_benchmark

_REALIZABLE = [
    "non_parameterized/others/count1.ltl --moore --size 2",
    "non_parameterized/others/count2.ltl --moore --size 3",

    "non_parameterized/others/full_arbiter2.ltl --moore --size 4",
    "non_parameterized/others/full_arbiter2.ltl --mealy --size 3",

    "non_parameterized/others/pnueli_arbiter2.ltl --moore --size 3",
    "non_parameterized/others/pnueli_arbiter2.ltl --mealy --size 3",

    "non_parameterized/others/pnueli_arbiter2.ltl --moore --size 3 --weak",
    "non_parameterized/others/pnueli_arbiter2.ltl --mealy --size 3 --weak",

    "non_parameterized/others/elevator2.ltl --moore --size 2",
    "non_parameterized/others/elevator2.ltl --mealy --size 2",

    
    # some random subset of tests with --incr
    "non_parameterized/others/count2.ltl --moore --bound 3 --incr",
    "non_parameterized/others/full_arbiter2.ltl --mealy --bound 3 --incr",

    "non_parameterized/others/pnueli_arbiter2.ltl --moore --bound 3 --incr",
    "non_parameterized/others/pnueli_arbiter2.ltl --mealy --bound 3 --incr",

    "non_parameterized/others/elevator2.ltl --mealy --bound 2 --incr"
]

_UNREALIZABLE = [
    "non_parameterized/others/count1.ltl --moore --size 1",
    "non_parameterized/others/count2.ltl --moore --size 2",

    "non_parameterized/others/full_arbiter2.ltl --moore --size 3",
    "non_parameterized/others/full_arbiter2.ltl --mealy --size 2",

    "non_parameterized/others/pnueli_arbiter2.ltl --moore --size 2",
    "non_parameterized/others/pnueli_arbiter2.ltl --mealy --size 2",

    "non_parameterized/others/pnueli_arbiter2.ltl --moore --size 2 --weak",
    "non_parameterized/others/pnueli_arbiter2.ltl --mealy --size 2 --weak",

    "non_parameterized/others/elevator2.ltl --moore --size 1",
    "non_parameterized/others/elevator2.ltl --mealy --size 1",

    # random subset for --incr
    "non_parameterized/others/count2.ltl --moore --bound 2 --incr",

    "non_parameterized/others/full_arbiter2.ltl --moore --bound 3 --incr",

    "non_parameterized/others/pnueli_arbiter2.ltl --moore --bound 2 --incr",
]


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Parametrized Synthesis Tool for token rings architecture')
    parser.add_argument('--nonstop', action='store_true', required=False, default=False,
                        help="don't stop on error")

    args = parser.parse_args(sys.argv[1:])
    print(args)

    realizable = _REALIZABLE
    unrealizable = _UNREALIZABLE

    all_passed = True
    for benchmark in realizable + unrealizable:
        result = run_benchmark('src/bosy.py', benchmark, benchmark in realizable)
        all_passed &= result

        if not args.nonstop and result is False:
            exit(1)

    print('-'*80)
    print(['SOME TESTS FAILED', 'ALL TESTS PASSED'][all_passed])
