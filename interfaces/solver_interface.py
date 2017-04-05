from abc import ABC, abstractmethod
from typing import List, Iterable


class SolverInterface(ABC):
    @abstractmethod
    def __iadd__(self, other:str or Iterable[str]):
        raise NotImplementedError()

    @abstractmethod
    def solve(self) -> List[str] or None:
        """ :returns: None if UNSAT, else (possible empty) list of string values.
                      (excluding 'sat'/'unsat' status)
        """
        raise NotImplementedError()

    @abstractmethod
    def push(self):
        raise NotImplementedError()

    @abstractmethod
    def pop(self):
        raise NotImplementedError()

    @abstractmethod
    def die(self):
        raise NotImplementedError()
