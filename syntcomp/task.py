from abc import ABC, abstractmethod

from interfaces.LTS import LTS


class Task(ABC):
    def __init__(self, name:str, is_doing_real_check:bool):
        self.name = name                                # type: str
        self.is_doing_real_check = is_doing_real_check  # type: bool

    @abstractmethod
    def do(self) -> LTS:
        pass
