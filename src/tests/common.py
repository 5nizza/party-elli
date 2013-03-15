import sys
from helpers.main_helper import get_root_dir
from helpers.python_ext import is_empty_str
from helpers.shell import execute_shell


_BENCHMARKS_DIR = get_root_dir() + "benchmarks/"


def _get_cmd_result(result, out, err):
    output = '-' * 20 + 'DETAILS' + '-' * 20 + '\n' + \
             "output:" + out + '\n' + \
             "error:" + err + '\n\n' + \
             "result:" + str(result) + '\n\n' + \
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


def run_benchmark(python_script_relative_path, benchmark, is_realizable) -> bool:
    cmd_args = _BENCHMARKS_DIR + benchmark
    exec_cmd = '{python3} {program} {args}'.format(python3=sys.executable,
                                                   program=get_root_dir() + python_script_relative_path,
                                                   args=cmd_args)
    result, out, err = execute_shell(exec_cmd)

    if (result != 0 and result != 1) or not is_empty_str(err):
        _failed('error while executing the command', cmd_args, result, out, err)
        return False

    else:
        actual_is_realizable = result is 0

        if is_realizable == actual_is_realizable:
            _ok(cmd_args)
            return True
        else:
            _failed('invalid realizability status(should be {status})'.
                    format(status=['unrealizable', 'realizable'][is_realizable]),
                    cmd_args, result, out, err)
            return False

