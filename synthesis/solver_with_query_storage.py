from abc import ABCMeta

from interfaces.solver_interface import SolverInterface
from interfaces.func_description import FuncDesc
from synthesis import smt_helper
from synthesis.smt_logic import Logic


class SmtSolverWithQueryStorageAbstract(SolverInterface, metaclass=ABCMeta):
    """
    Default implementation for most of the methods except
    die(), and solve()
    """

    def __init__(self, query_storage, logic:Logic):
        assert hasattr(query_storage, '__iadd__')

        self._query_storage = query_storage
        self._query_storage += smt_helper.make_headers()
        self._query_storage += smt_helper.make_set_logic(logic)
        self._logic = logic

    def declare_enum(self, enum_name:str, values):
        self._query_storage += smt_helper.declare_enum(enum_name, values)

    def declare_fun(self, func_desc:FuncDesc):
        self._query_storage += func_desc.declare_fun()

    def define_fun(self, func_desc:FuncDesc):
        self._query_storage += func_desc.definition()

    #
    def op_not(self, e):
        return smt_helper.op_not(e)

    def op_and(self, clauses):
        return smt_helper.op_and(clauses)

    def op_or(self, clauses):
        return smt_helper.op_or(clauses)

    def op_implies(self, left, right):
        return smt_helper.op_implies(left, right)

    def false(self):
        return smt_helper.false()

    def get_true(self):
        return smt_helper.true()

    def op_eq(self, first_arg, second_arg):
        return smt_helper.op_eq(first_arg, second_arg)

    def op_ge(self, left, right):
        return smt_helper.op_ge(left, right, self._logic)

    def op_gt(self, left, right):
        return smt_helper.op_gt(left, right, self._logic)

    def forall_bool(self, ground_args, formula):
        return smt_helper.forall_bool(ground_args, formula)

    def forall(self, ground_arg_type_pairs, formula):
        return smt_helper.forall(ground_arg_type_pairs, formula)

    #
    def call_func(self, func_desc:FuncDesc, vals_by_vars:dict):
        return func_desc.call_func(vals_by_vars)

    #
    def assert_(self, assertion):
        self._query_storage += smt_helper.make_assert(assertion)

    def push(self):
        self._query_storage += smt_helper.make_push()

    def add_check_sat(self):
        self._query_storage += smt_helper.make_check_sat()

    def pop(self):
        self._query_storage += smt_helper.make_pop()

    def get_value(self, expr):
        self._query_storage += smt_helper.get_value(expr)

    #
    def comment(self, comment):
        self._query_storage += smt_helper.comment(comment)
