import logging
import shlex
import subprocess
from helpers.python_ext import StrAwareList, lfilter
from synthesis.smt_logic import Logic
from synthesis.solver_with_query_storage import SmtSolverWithQueryStorageAbstract


class Z3InteractiveViaPipes(SmtSolverWithQueryStorageAbstract):
    """
    I use this solver for incremental solving.
    """
    def __init__(self, logic:Logic, z3_path):
        super().__init__(StrAwareList(), logic)

        z3_cmd = z3_path + ' -smt2 -in '
        args = shlex.split(z3_cmd)

        self._process = subprocess.Popen(args,
                                         stdin=subprocess.PIPE,
                                         stdout=subprocess.PIPE,
                                         stderr=subprocess.STDOUT)

        logging.info('created z3 process: ' + str(self._process.pid))

    def die(self):
        self._process.kill()

    def _read_block(self) -> str:
        lines = []

        while True:
            line = str(self._process.stdout.readline(), 'utf-8').strip()
            if line == 'done':
                break
            lines.append(line)

        return lines

    def _assert_no_errors(self, lines):
        logging.debug('solver returned:')
        logging.debug('\n'.join(lines))
        real_error_lines = lfilter(lambda l: 'error' in l and 'model is not available' not in l, lines)
        if real_error_lines:
            msg = 'z3 found errors in query. Last piece of query: \n' \
                  '{query}\n' \
                  '-----------------------\n' \
                  'z3 error messages:\n' \
                  '{error}'.format(query=str(self._query_storage),
                                   error='\n'.join(real_error_lines))
            assert 0, msg

    def solve(self):
        logging.info('solving the query..')

        self._query_storage += '(echo "done")'

        self._process.stdin.write(bytes(str(self._query_storage), 'utf-8'))
        self._process.stdin.flush()  # just in case

        lines = self._read_block()
        self._assert_no_errors(lines)

        self._query_storage = StrAwareList()

        if lines[0] == 'sat':
            return lines[1:]
        return None
