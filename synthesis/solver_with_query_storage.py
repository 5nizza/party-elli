from typing import Iterable

from interfaces.solver_interface import SolverInterface
from synthesis import smt_format


class SmtSolverWithQueryStorageAbstract(SolverInterface):
    def __init__(self, query_storage):
        assert hasattr(query_storage, '__iadd__')
        self._query_storage = query_storage

    def __iadd__(self, smt_statement:str or Iterable[str]):
        self._query_storage += smt_statement
        return self

    def push(self):
        self._query_storage += smt_format.make_push()

    def pop(self):
        self._query_storage += smt_format.make_pop()
