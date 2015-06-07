import shlex
import subprocess


def execute_shell(cmd, input=''):
    """
    Execute cmd, send input to stdin.
    Return returncode, stdout, stderr.
    """

    proc_stdin = subprocess.PIPE if input != '' and input is not None else None
    proc_input = input if input != '' and input is not None else None

    # args = shlex.split(cmd)

    p = subprocess.Popen(cmd,  # args,
                         stdin=proc_stdin,
                         stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE,
                         shell=True)  # makes prefixed things like `LD_LIBRARY_PATH=.. ./command` work

    out, err = p.communicate(proc_input)

    return p.returncode, \
           str(out, encoding='utf-8'), \
           str(err, encoding='utf-8')

