import subprocess
import sys


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
                             shell=True)

        if proc_input:
            out, err = p.communicate(bytes(proc_input, encoding='utf-8'))
        else:
            out, err = p.communicate()

        return p.returncode, str(out, encoding='utf-8'), str(err, encoding='utf-8')
