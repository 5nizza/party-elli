from abc import ABC, abstractmethod
from typing import List

from syntcomp.task import Task


class TaskCreator(ABC):
    @staticmethod
    @abstractmethod
    def create(ltl_text:str, part_text:str, is_moore:bool) -> List[Task]:
        pass
