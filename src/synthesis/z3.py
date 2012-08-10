import logging
from helpers.logging import log_entrance
from helpers.python_ext import is_empty_str
from helpers.shell import execute_shell


class Z3:
    SAT = 0
    UNSAT = 1

    def __init__(self, path, flag='-'):
        self._logger = logging.getLogger(__name__)
        self._cmd = path + ' {0}smt2 {0}in'.format(flag)


    def _remove_model_is_not_available(self, err):
        res = [x for x in err.split('\n') if "model is not available" not in x ]
        return '\n'.join(res)


    @log_entrance(logging.getLogger(), logging.INFO)
    def solve(self, smt_query):
        rc, raw_output, raw_err = execute_shell(self._cmd, smt_query)

        output = self._remove_model_is_not_available(raw_output)
        err = self._remove_model_is_not_available(raw_err)

        if rc != 0 or err:
            if not (rc == 1 and is_empty_str(err) and 'unsat' == output.strip()):
                self._logger.warning("Z3: returned: {0}\noutput:\n{1}\nerror:\n{2}\n".format(rc, output, err))

        self._logger.debug('Z3 output is:\n' + output)

        output_lines = [x.strip() for x in output.split('\n') if x.strip() != '']

        if output_lines[0] == 'unsat':
            return Z3.UNSAT, None

        if output_lines[0] == 'sat':
            return Z3.SAT, output_lines[1:] #first line is status

        assert False, 'unknown Z3 state: ' + output