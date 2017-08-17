import sys

from helpers.main_helper import get_root_dir
from helpers.python_ext import is_empty_str
from helpers.shell import execute_shell


BENCHMARKS_DIR = get_root_dir() + "benchmarks/"


def _get_cmd_result(result, out, err):
    output = '-' * 20 + 'DETAILS' + '-' * 20 + '\n' + \
             "output:" + out + '\n' + \
             "error:" + err + '\n\n' + \
             "result:" + str(result) + '\n\n' + \
             '-' * 40
    return output


def _print_failed(reason, cmd_args, result, out, err):
    print()
    print(_get_cmd_result(result, out, err))
    error_message = 'FAILED: \n{cmd_args}\n' \
                    'REASON: {reason}'.format(cmd_args=cmd_args, reason=reason)
    print(error_message)
    print()


def _print_ok(cmd_args):
    print('OK: ', cmd_args)


def _extract_model_size(out:str) -> int or None:
    template1 = '  FOUND model for sys of size '
    template2 = '  FOUND model for env of size '
    for l in [l.strip() for l in out.splitlines() if l.strip()]:
        if template1 in l or template2 in l:
            return int(l.split()[-1])
    return None


def run_benchmark(python_script_relative_path, benchmark, rc_expected, size_expected) -> bool:
    cmd_args = BENCHMARKS_DIR + benchmark
    exec_cmd = '{python3} {program} {args}'.format(python3=sys.executable,
                                                   program=get_root_dir() + python_script_relative_path,
                                                   args=cmd_args)
    result, out, err = execute_shell(exec_cmd)

    if not is_empty_str(err):
        _print_failed('error while executing the command', exec_cmd, result, out, err)
        return False
    else:
        size_actual = _extract_model_size(out)
        if result == rc_expected and (not size_expected or size_expected == size_actual):
            _print_ok(cmd_args)
            return True
        else:
            _print_failed('invalid exit status or model size: \n'\
                          '  rc_actual vs rc_expected: {rc_act} vs. {rc_exp}\n'\
                          '  size_actual vs size_expected: {size_act} vs. {size_exp}'.
                          format(rc_act=result,
                                 rc_exp=rc_expected,
                                 size_act=size_actual,
                                 size_exp=size_expected),
                          exec_cmd, result, out, err)
            return False
