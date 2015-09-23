from _collections_abc import Iterable
import os
import shutil
from helpers.shell import execute_shell
from synthesis import smt_helper
from synthesis.smt_logic import Logic
from synthesis.solver_with_query_storage import SmtSolverWithQueryStorageAbstract


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
        if isinstance(other, Iterable) and \
                not isinstance(other, str) and \
                not isinstance(other, bytes):  # TODO: looks weird
            for s in other:
                self._append(s)
            return self
        else:
            self._append(other)
            return self

    def close(self):
        self._file_writer.close()


class EmulatePushPop:
    def __init__(self, query_storage:'truncate-able query storage'):
        assert hasattr(query_storage, 'truncate')
        assert hasattr(query_storage, 'position')

        self._query_storage = query_storage
        self._pushes = []

    def pop(self):
        position_to_trunk_to = self._pushes.pop()
        self._query_storage.truncate(position_to_trunk_to)

    def push(self):
        self._pushes.append(self._query_storage.position)


class Z3NonInteractiveViaFiles(SmtSolverWithQueryStorageAbstract):
    """
    I use this solver for non-incremental solving.
    """
    def __init__(self,
                 files_prefix:str,
                 z3_path:str,
                 logic:Logic,
                 logger,
                 remove_file:bool):
        self._logger = logger
        self._file_name = files_prefix + '.smt2'
        super().__init__(TruncatableQueryStorage_ViaFile(self._file_name), logic)

        self._emulate_push_pop = EmulatePushPop(self._query_storage)
        self._z3_cmd = z3_path + ' -smt2 ' + self._file_name
        self.__remove_file = remove_file

    def die(self):
        self._query_storage.close()
        if self.__remove_file:
            os.remove(self._file_name)

    def push(self):
        return self._emulate_push_pop.push()

    def pop(self):
        return self._emulate_push_pop.pop()

    def solve(self):
        self._logger.info('solving ' + self._file_name)

        self._query_storage += smt_helper.make_exit()
        self._query_storage.flush()
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


class FakeSolver(Z3NonInteractiveViaFiles):
    """
    Solver saves the query into file, instead of calling the solver.
    Always returns UNSAT.
    """

    def __init__(self, smt_file_prefix, z3_path:str, logic:Logic, logger):
        super().__init__(smt_file_prefix, z3_path, logic, logger, True)
        self.__cur_index = 1
        self.__file_prefix = smt_file_prefix

    def solve(self):
        self._query_storage += smt_helper.make_exit()
        self._query_storage.flush()

        file_name = '{file_prefix}_{index}.smt2'.format(file_prefix=self.__file_prefix,
                                                        index=str(self.__cur_index))

        self._logger.info('copying {src} into {dst}'.format(src=self._file_name, dst=file_name))
        self._logger.info(shutil.copyfile(self._file_name, file_name))

        self.__cur_index += 1
        return None  # always return UNSAT
