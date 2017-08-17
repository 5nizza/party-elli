from abc import ABC, abstractmethod
from typing import List, Iterable, Sequence

from interfaces.LTS import LTS


class EncoderInterface(ABC):
    @abstractmethod
    def encode_headers(self) -> List[str]:
        raise NotImplementedError()

    @abstractmethod
    def encode_initialization(self) -> List[str]:
        raise NotImplementedError()

    @abstractmethod
    def encode_run_graph(self, states_to_encode:Iterable[int]) -> List[str]:
        raise NotImplementedError()

    @abstractmethod
    def encode_model_bound(self, cur_all_states:Iterable[int]) -> List[str]:
        raise NotImplementedError()

    @abstractmethod
    def encode_get_model_values(self) -> List[str]:
        raise NotImplementedError()

    @abstractmethod
    def parse_model(self, smt_model:Sequence[str]) -> LTS:
        raise NotImplementedError()
