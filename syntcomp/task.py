from abc import ABC, abstractmethod
from pprint import pformat


class Task(ABC):
    def __init__(self, name:str, is_doing_real_check:bool):
        self.name = name                                # type: str
        self.is_doing_real_check = is_doing_real_check  # type: bool
        self.answer = None                              # type: bool or None # None means task did not finished execution
        self.model = None                               # the type varies, can be None for realizability checkers
        self.err_msg = None                             # type: str or None

    @abstractmethod
    def do(self) -> None:
        pass

    def is_realizable(self) -> bool or None:
        assert self.answer is not None and self.err_msg is None, \
            "asking realizability of the task that did not finish or that crashed:\n" + str(self)

        if self.answer is False:
            return None  # unknown

        return self.is_doing_real_check

    def __str__(self):
        return "Task:\n" + '  \n'.join(pformat(vars(self)).splitlines)
