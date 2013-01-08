import shlex
import subprocess
import sys


def execute_shell(cmd, input=''):
    """ Execute cmd, send input to stdin. Return returncode, stdout, stderr. """

    proc_stdin = subprocess.PIPE if input != '' and input is not None else None
    proc_input = input if input != '' and input is not None else None

    args = shlex.split(cmd)

    p = subprocess.Popen(args,
        stdin = proc_stdin,
        stdout = subprocess.PIPE,
        stderr = subprocess.PIPE)

    out, err = p.communicate(proc_input)

    return p.returncode, \
           str(out, encoding=sys.stdout.encoding), \
           str(err, encoding=sys.stderr.encoding)

