import shlex
import subprocess
import sys


def execute_shell(cmd, input=''):
    """ Execute cmd, send input to stdin. Return returncode, stdout, stderr. """

    args = shlex.split(cmd)
    p = subprocess.Popen(args, stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.PIPE)
    out, err = p.communicate(bytes(input, sys.stdin.encoding))

    return p.returncode, str(out, sys.stdout.encoding), str(err, sys.stderr.encoding)
