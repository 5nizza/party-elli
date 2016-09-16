from abc import ABCMeta, abstractmethod
from interfaces.lts import LTS


class EncodingSolver:  # TODO: not used?
    __metaclass__ = ABCMeta

    @abstractmethod
    def encode_run_graph(self, impl, model_states_to_encode, env_ass_func):
        raise NotImplementedError()

    @abstractmethod
    def push(self):
        raise NotImplementedError()

    @abstractmethod
    def pop(self):
        raise NotImplementedError()

    @abstractmethod
    def solve(self, impl) -> LTS:
        raise NotImplementedError()

    @abstractmethod
    def encode_model_bound(self, only_states, impl):
        raise NotImplementedError()
