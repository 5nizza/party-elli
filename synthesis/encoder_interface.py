from abc import ABC, abstractmethod
from typing import List

from interfaces.LTS import LTS


class EncoderInterface(ABC):
    @abstractmethod
    def encode_headers(self, max_model_states) -> List[str]:
        raise NotImplementedError()

    @abstractmethod
    def encode_initialization(self) -> List[str]:
        raise NotImplementedError()

    @abstractmethod
    def encode_run_graph(self, new_states) -> List[str]:
        raise NotImplementedError()

    @abstractmethod
    def encode_model_bound(self, cur_all_states) -> List[str]:
        raise NotImplementedError()

    @abstractmethod
    def encode_get_model_values(self) -> List[str]:
        raise NotImplementedError()

    @abstractmethod
    def parse_model(self, smt_model:List[str]) -> LTS:
        raise NotImplementedError()
