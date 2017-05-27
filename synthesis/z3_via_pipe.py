import logging
import shlex
import subprocess
from typing import List

from helpers.python_ext import StrAwareList, lfilter
from synthesis.solver_with_query_storage import SmtSolverWithQueryStorageAbstract


class Z3InteractiveViaPipes(SmtSolverWithQueryStorageAbstract):
    """ Incremental Solver """

    def __init__(self, z3_path):
        super().__init__(StrAwareList())

        z3_cmd = z3_path + ' -smt2 -in '
        args = shlex.split(z3_cmd)

        self._process = subprocess.Popen(args,
                                         stdin=subprocess.PIPE,
                                         stdout=subprocess.PIPE,
                                         stderr=subprocess.STDOUT)

        logging.info('created z3 process: ' + str(self._process.pid))

    def die(self):
        self._process.kill()
        self._process.wait()  # let zombie go

    def _read_block(self) -> List[str]:
        lines = []

        logging.debug('reading z3 output:')
        while True:
            line = str(self._process.stdout.readline(), 'utf-8').strip()
            logging.debug(line)
            if line == 'done':
                break
            lines.append(line)

        return lines

    def _assert_no_errors(self, lines):
        real_error_lines = lfilter(lambda l: 'error' in l and 'model is not available' not in l, lines)
        if real_error_lines:
            msg = 'z3 found errors in query. Last piece of query: \n' \
                  '{query}\n' \
                  '-----------------------\n' \
                  'z3 error messages:\n' \
                  '{error}'.format(query=str(self._query_storage),
                                   error='\n'.join(real_error_lines))
            assert 0, msg

    def solve(self) -> List[str] or None:
        logging.info('solving the query..')

        self._query_storage += '(echo "done")'

        lines_response = []
        # TODO: XXX: ugly (know about check-sat + protected): avoiding deadlock due to pipe overfull
        extracting = False
        for l in self._query_storage._output:
            self._process.stdin.write(bytes(l + '\n', 'utf-8'))
            self._process.stdin.flush()  # just in case
            if l.strip().startswith('(check-sat'):
                z3_response = str(self._process.stdout.readline(), 'utf-8').strip()
                if z3_response == 'unsat':
                    self._query_storage = StrAwareList()
                    return None
                if z3_response == 'sat':
                    logging.debug('z3 returned sat, extracting the model')
                    extracting = True
                    continue
                else:
                    assert 0, 'z3 returned unexpected smth: ' + lines_response[0]
            if extracting:
                z3_response = str(self._process.stdout.readline(), 'utf-8').strip()
                lines_response.append(z3_response)

        self._query_storage = StrAwareList()
        return lines_response
