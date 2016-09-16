import logging
import os
import subprocess
import sys

import signal

from helpers.python_ext import is_empty_str

if sys.version_info < (3, 0):
    # python2.7 version
    def execute_shell(cmd, input=''):
        """
        :param cmd:
        :param input: sent to sdtin
        :return: returncode, stdout, stderr.
        """

        proc_stdin = subprocess.PIPE if input != '' else None
        proc_input = input if input != '' else None

        p = subprocess.Popen(cmd,
                             stdin=proc_stdin,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE,
                             shell=True,   # so we can use piping | in cmd
                             universal_newlines=True)  # so we communicate using strings (instead of bytes)

        if proc_input:
            out, err = p.communicate(proc_input)
        else:
            out, err = p.communicate()

        return p.returncode, out, err

else:
    def execute_shell(cmd, input='', timeout=None):
        """
        :param cmd:
        :param input: sent to stdin
        :return: returncode, stdout, stderr.
        :raise: subprocess.TimeoutExpired (I kill the process!)
        """

        proc_stdin = subprocess.PIPE if input != '' else None
        proc_input = input if input != '' else None

        p = subprocess.Popen(cmd,
                             stdin=proc_stdin,
                             stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE,
                             shell=True,
                             preexec_fn=os.setsid if timeout else None)  # http://stackoverflow.com/a/4791612/801203
        try:
            if proc_input:
                out, err = p.communicate(bytes(proc_input, encoding=sys.getdefaultencoding()), timeout=timeout)
            else:
                out, err = p.communicate(timeout=timeout)
        except subprocess.TimeoutExpired:
            logging.debug('Timeout expired, killing the process')
            os.killpg(os.getpgid(p.pid), signal.SIGTERM)
            p.communicate()
            raise

        return p.returncode,\
               str(out, sys.getdefaultencoding()),\
               str(err, sys.getdefaultencoding())


def rc_out_err_to_str(rc, out, err) -> str:
    return 'rc: ' + str(rc) + '\nout: ' + out + '\nerr: ' + err


def assert_exec_strict(rc, out, err):
    assert rc==0 and is_empty_str(err), rc_out_err_to_str(rc, out, err)
