from abc import ABCMeta, abstractmethod
from interfaces.lts import LTS
from synthesis.func_description import FuncDescription


class SolverInterface:
    __metaclass__ = ABCMeta

    @abstractmethod
    def die(self):
        raise NotImplementedError()

    @abstractmethod
    def declare_enum(self, enum_name:str, values):
        raise NotImplementedError()

    @abstractmethod
    def declare_fun(self, func_desc:FuncDescription):
        raise NotImplementedError()

    @abstractmethod
    def define_fun(self, func_desc:FuncDescription):
        raise NotImplementedError()

    @abstractmethod
    def op_not(self, e):
        raise NotImplementedError()

    @abstractmethod
    def op_and(self, clauses):
        raise NotImplementedError()

    @abstractmethod
    def op_or(self, clauses):
        raise NotImplementedError()

    @abstractmethod
    def op_implies(self, left, right):
        raise NotImplementedError()

    @abstractmethod
    def false(self):
        raise NotImplementedError()

    @abstractmethod
    def true(self):
        raise NotImplementedError()

    @abstractmethod
    def op_eq(self, first_arg, second_arg):
        raise NotImplementedError()

    @abstractmethod
    def op_ge(self, left, right):
        raise NotImplementedError()

    @abstractmethod
    def op_gt(self, left, right):
        raise NotImplementedError()

    @abstractmethod
    def forall_bool(self, ground_args, formula):
        raise NotImplementedError()

    @abstractmethod
    def forall(self, ground_arg_type_pairs, formula):
        raise NotImplementedError()

    #
    @abstractmethod
    def call_func(self, func_desc:FuncDescription, vals_by_vars:dict):
        raise NotImplementedError()

    #
    @abstractmethod
    def assert_(self, condition):
        raise NotImplementedError()

    @abstractmethod
    def push(self):
        raise NotImplementedError()

    @abstractmethod
    def pop(self):
        raise NotImplementedError()

    @abstractmethod
    def add_check_sat(self):
        """ This is a hack to fit incremental and usual solvers
            into common interface.
        """
        raise NotImplementedError()

    @abstractmethod
    def solve(self) -> list:  # TODO: currently returns lines, but should return some model witness
        raise NotImplementedError()

    @abstractmethod
    def get_value(self, expr):
        raise NotImplementedError()

    #
    @abstractmethod
    def comment(self, comment):
        raise NotImplementedError()
