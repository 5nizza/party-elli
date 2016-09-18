from abc import ABC, abstractmethod


class EncoderInterface(ABC):
    @abstractmethod
    def encode_headers(self, max_model_states):
        raise NotImplementedError()

    @abstractmethod
    def encode_initialization(self):
        raise NotImplementedError()

    @abstractmethod
    def encode_run_graph(self, new_states):
        raise NotImplementedError()

    @abstractmethod
    def push(self):
        raise NotImplementedError()

    @abstractmethod
    def encode_model_bound(self, cur_all_states):
        raise NotImplementedError()

    @abstractmethod
    def solve(self):
        raise NotImplementedError()

    @abstractmethod
    def pop(self):
        raise NotImplementedError()
