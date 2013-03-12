import argparse
import sys
from helpers.main_helper import get_root_dir
from helpers.python_ext import is_empty_str
from helpers.shell import execute_shell


_REALIZABLE = [
    "../benchmarks/parameterized/full_arbiter.ltl --cutoff 2 --size 3 --opt strength",
    "../benchmarks/parameterized/full_arbiter.ltl --cutoff 3 --size 3 --opt strength",

    "../benchmarks/parameterized/pnueli_arbiter.ltl --cutoff 2 --size 3 --opt strength",
    "../benchmarks/parameterized/pnueli_arbiter.ltl --cutoff 3 --size 3 --opt strength",


    "../benchmarks/parameterized/full_arbiter.ltl --cutoff 2 --size 3 --opt async_hub",
    "../benchmarks/parameterized/full_arbiter.ltl --cutoff 3 --size 3 --opt async_hub",

    "../benchmarks/parameterized/pnueli_arbiter.ltl --cutoff 2 --size 3 --opt async_hub",
    "../benchmarks/parameterized/pnueli_arbiter.ltl --cutoff 3 --size 3 --opt async_hub",


    "../benchmarks/parameterized/full_arbiter.ltl --cutoff 2 --size 3 --opt sync_hub",
    "../benchmarks/parameterized/full_arbiter.ltl --cutoff 3 --size 3 --opt sync_hub"
]

_UNREALIZABLE = [
    "../benchmarks/parameterized/full_arbiter.ltl --cutoff 2 --size 2 --opt strength",
    "../benchmarks/parameterized/full_arbiter.ltl --cutoff 3 --size 2 --opt strength",

    "../benchmarks/parameterized/pnueli_arbiter.ltl --cutoff 2 --size 2 --opt strength",
    "../benchmarks/parameterized/pnueli_arbiter.ltl --cutoff 3 --size 2 --opt strength",


    "../benchmarks/parameterized/full_arbiter.ltl --cutoff 2 --size 2 --opt async_hub",
    "../benchmarks/parameterized/full_arbiter.ltl --cutoff 3 --size 2 --opt async_hub",

    "../benchmarks/parameterized/pnueli_arbiter.ltl --cutoff 2 --size 2 --opt async_hub",
    "../benchmarks/parameterized/pnueli_arbiter.ltl --cutoff 3 --size 2 --opt async_hub",


    "../benchmarks/parameterized/full_arbiter.ltl --cutoff 2 --size 2 --opt sync_hub",
    "../benchmarks/parameterized/full_arbiter.ltl --cutoff 3 --size 2 --opt sync_hub",

    "../benchmarks/parameterized/pnueli_arbiter.ltl --cutoff 2 --size 2 --opt sync_hub",
    "../benchmarks/parameterized/pnueli_arbiter.ltl --cutoff 3 --size 2 --opt sync_hub"
]


_REALIZABLE_SUBSET = [
    "../benchmarks/parameterized/full_arbiter.ltl --cutoff 3 --size 3 --opt strength",
    "../benchmarks/parameterized/pnueli_arbiter.ltl --cutoff 3 --size 3 --opt strength",

    "../benchmarks/parameterized/full_arbiter.ltl --cutoff 3 --size 3 --opt async_hub",
    "../benchmarks/parameterized/pnueli_arbiter.ltl --cutoff 3 --size 3 --opt sync_hub"
]


_UNREALIZABLE_SUBSET = [
    "../benchmarks/parameterized/full_arbiter.ltl --cutoff 2 --size 2 --opt strength",
    "../benchmarks/parameterized/full_arbiter.ltl --cutoff 2 --size 2 --opt async_hub",
    "../benchmarks/parameterized/full_arbiter.ltl --cutoff 2 --size 2 --opt sync_hub",

    "../benchmarks/parameterized/pnueli_arbiter.ltl --cutoff 2 --size 2 --opt strength",
    "../benchmarks/parameterized/pnueli_arbiter.ltl --cutoff 2 --size 2 --opt async_hub",
    "../benchmarks/parameterized/pnueli_arbiter.ltl --cutoff 2 --size 2 --opt sync_hub",
]

_BENCHMARKS_DIR = get_root_dir() + "benchmarks/"
_PYTHON3 = "python3"
_PROGRAM = get_root_dir() + "src/p_bosy.py"


def _get_cmd_result(result, out, err):
    output = '-' * 20 + 'DETAILS' + '-' * 20 + '\n' + \
             "result:" + str(result) + '\n\n' + \
             "error:" + err + '\n\n' + \
             "output:" + out + '\n' + \
             '-' * 40
    return output


def _failed(reason, cmd_args, result, out, err):
    print()
    print(_get_cmd_result(result, out, err))
    error_message = 'FAILED: {cmd_args}\n' \
                    'REASON: {reason}'.format(cmd_args=cmd_args, reason=reason)
    print(error_message)
    print()


def _ok(cmd_args):
    print('OK: ', cmd_args)


def _run_benchmark(benchmark, is_realizable) -> bool:
    cmd_args = _BENCHMARKS_DIR + benchmark
    exec_cmd = '{python3} {program} {args}'.format(python3=_PYTHON3, program=_PROGRAM, args=cmd_args)
    result, out, err = execute_shell(exec_cmd)

    if result != 0 or not is_empty_str(err):
        _failed('error while executing the command', cmd_args, result, out, err)
        return False

    else:
        status_realizability = out.strip().splitlines()[-1]

        if is_realizable and "model found" in status_realizability:
            _ok(cmd_args)
            return True

        elif not is_realizable and "model not found" in status_realizability:
            _ok(cmd_args)
            return True

        else:
            _failed('invalid realizability status(should be {status})'.
                    format(status=['unrealizable', 'realizable'][is_realizable]),
                    cmd_args, result, out, err)
            return False


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Parametrized Synthesis Tool for token rings architecture')
    parser.add_argument('--nonstop', action='store_true', required=False, default=False,
                        help="don't stop on error")
    parser.add_argument('--extensive', action='store_true', required=False, default=False,
                        help="extensive testing (consider more sizes and more cutoffs)")

    args = parser.parse_args(sys.argv[1:])
    print(args)

    realizable = _REALIZABLE_SUBSET
    unrealizable = _UNREALIZABLE_SUBSET

    if args.extensive:
        realizable = _REALIZABLE
        unrealizable = _UNREALIZABLE

    all_passed = True
    for benchmark in realizable + unrealizable:
        result = _run_benchmark(benchmark, benchmark in realizable)
        all_passed &= result

        if not args.nonstop and result is False:
            exit(1)

    print('-'*80)
    print(['SOME TESTS FAILED', 'ALL TESTS PASSED'][all_passed])