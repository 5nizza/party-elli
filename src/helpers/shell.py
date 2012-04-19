import shlex
import subprocess


def execute_shell(cmd, input=''):
    """ Execute cmd, send input to stdin. Return returncode, stdout, stderr. """

    args = shlex.split(cmd)
    p = subprocess.Popen(args, stdin = subprocess.PIPE, stdout = subprocess.PIPE, stderr = subprocess.PIPE)
    out, err = p.communicate(input)

    return p.returncode, out, err
