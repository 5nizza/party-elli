from abc import ABC, abstractmethod

from interfaces.automata import Automaton
from interfaces.expr import Expr


class LTLToAutomaton(ABC):
    """ Interface for the automaton. """
    @staticmethod
    @abstractmethod
    def convert(expr:Expr, states_prefix:str='') -> Automaton:
        pass
