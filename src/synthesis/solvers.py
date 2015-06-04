from collections import Iterable
import shlex
import subprocess
from helpers.python_ext import StrAwareList, lfilter
from helpers.shell import execute_shell
from interfaces.solver_interface import SolverInterface
from synthesis.func_description import FuncDescription
import synthesis.smt_helper as smt_helper
from synthesis.smt_logic import Logic


class TruncatableQueryStorage_ViaFile:
    def __init__(self, file_name):
        self._file_writer = open(file_name, mode='w')
        assert self._file_writer.seekable()

    def truncate(self, position):
        self._file_writer.seek(position)
        self._file_writer.truncate()

    @property
    def position(self):
        return self._file_writer.tell()

    def flush(self):
        self._file_writer.flush()

    def _append(self, s):
        self._file_writer.write(s)
        self._file_writer.write('\n')

    def __iadd__(self, other):
        if isinstance(other, Iterable) and not isinstance(other, str) and not isinstance(other, bytes):
            for s in other:
                self._append(s)
            return self
        else:
            self._append(other)
            return self

    def close(self):
        self._file_writer.close()


class EmulatePushPop:
    def __init__(self, query_storage: 'truncate-able query storage'):
        self._query_storage = query_storage
        self._pushes = []

    def pop(self):
        position_to_trunk_to = self._pushes.pop()
        self._query_storage.truncate(position_to_trunk_to)

    def push(self):
        self._pushes.append(self._query_storage.position)


class SmtSolverWithQueryStorageAbstract(SolverInterface):
    def __init__(self, query_storage, logic:Logic):
        self._query_storage = query_storage
        self._query_storage += smt_helper.make_headers()
        self._query_storage += smt_helper.make_set_logic(logic)
        self._logic = logic

    def declare_enum(self, enum_name:str, values):
        self._query_storage += smt_helper.declare_enum(enum_name, values)

    def declare_fun(self, func_desc:FuncDescription):
        self._query_storage += smt_helper.declare_fun(func_desc)

    def define_fun(self, func_desc:FuncDescription):
        self._query_storage += smt_helper.define_fun(func_desc)

    #
    def op_not(self, e):
        return smt_helper.op_not(e)

    def op_and(self, clauses):
        return smt_helper.op_and(clauses)

    def op_or(self, clauses):
        return smt_helper.op_or(clauses)

    def op_implies(self, left, right):
        return smt_helper.op_implies(left, right)

    def false(self):
        return smt_helper.false()

    def true(self):
        return smt_helper.true()

    def op_eq(self, first_arg, second_arg):
        return smt_helper.op_eq(first_arg, second_arg)

    def op_ge(self, left, right):
        return smt_helper.op_ge(left, right, self._logic)

    def op_gt(self, left, right):
        return smt_helper.op_gt(left, right, self._logic)

    def forall_bool(self, ground_args, formula):
        return smt_helper.forall_bool(ground_args, formula)

    def forall(self, ground_arg_type_pairs, formula):
        return smt_helper.forall(ground_arg_type_pairs, formula)

    #
    def call_func(self, func_desc:FuncDescription, vals_by_vars:dict):
        return smt_helper.call_func(func_desc, vals_by_vars)

    #
    def assert_(self, assertion):
        self._query_storage += smt_helper.make_assert(assertion)

    def push(self):
        self._query_storage += smt_helper.make_push()

    def add_check_sat(self):
        self._query_storage += smt_helper.make_check_sat()

    def pop(self):
        self._query_storage += smt_helper.make_pop()

    def get_value(self, expr):
        self._query_storage += smt_helper.get_value(expr)

    #
    def comment(self, comment):
        self._query_storage += smt_helper.comment(comment)

    def add_raw_smt(self, raw_smt_string):
        self._query_storage += raw_smt_string


class Z3_Smt_NonInteractive_ViaFiles(SmtSolverWithQueryStorageAbstract):
    def __init__(self, files_prefix:str,
                 z3_path:str,
                 logic:Logic,
                 logger):
        self._logger = logger
        self._file_name = files_prefix + '.smt2'
        super().__init__(TruncatableQueryStorage_ViaFile(self._file_name),
                         logic)

        self._emulate_push_pop = EmulatePushPop(self._query_storage)
        self._z3_cmd = z3_path + ' -smt2 ' + self._file_name

    def die(self):
        self._query_storage.close()

    def push(self):
        return self._emulate_push_pop.push()

    def pop(self):
        return self._emulate_push_pop.pop()

    def solve(self):
        self._logger.info('solving ' + self._file_name)

        self._query_storage += smt_helper.make_exit()
        self._query_storage.flush()  # i know query_storage.flush() exists
        #change the name of file and z3_cmd if necessary
        ret, out, err = execute_shell(self._z3_cmd)

        self._logger.debug('solver returned: \n' + out)

        out_lines = [s.strip() for s in out.splitlines() if s]
        if ret == 1 and out_lines[0].strip() != 'unsat':
            assert 0, 'error while executing z3: ret: {ret}\n' \
                      'out:{out}\n' \
                      'err:{err}\n'.format(ret=str(ret),
                                           out=out,
                                           err=err)

        if out_lines[0] == 'sat':
            return out_lines[1:]
        else:
            return None


# class Z3_NonInteractive_ViaPipes(SmtSolverWithQueryStorageAbstract):
#
#     def solve(self):
#         query_storage += 'check-sat'
#         query_storage += 'exit'
#
#         out = execute_shell("z3", "file=..", "args=",
#                             input=query_storage.to_str())
#
#         return parse(out)
#
#     def push(self):
#         assert 0
#
#     def pop(self):
#         assert 0
#
#

class Z3_Smt_Interactive(SmtSolverWithQueryStorageAbstract):
    def __init__(self, logic:Logic, z3_path, logger):
        super().__init__(StrAwareList(), logic)

        z3_cmd = z3_path + ' -smt2 -in '
        args = shlex.split(z3_cmd)

        self._logger = logger

        self._process = subprocess.Popen(args,
                                         stdin=subprocess.PIPE,
                                         stdout=subprocess.PIPE,
                                         stderr=subprocess.PIPE)

        self._logger.info('created z3 process: ' + str(self._process.pid))

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
        self._logger.info('solving the query..')

        self._query_storage += '(echo "done")'

        self._process.stdin.write(bytes(str(self._query_storage), 'utf-8'))
        self._process.stdin.flush()  # just in case

        lines = self._read_block()
        self._assert_no_errors(lines)

        self._query_storage = StrAwareList()

        if lines[0] == 'sat':
            return lines[1:]
        return None

        # TODO: what about killing z3 process?

#
#
# class Z3_Api:  # should implement all methods from SolverInterface
#     pass
