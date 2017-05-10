from typing import Dict

from helpers.python_ext import lmap, lfilter
from interfaces.func_description import FuncDesc


def make_check_sat():
    return "(check-sat)"


def make_push(level=1):
    return '(push {level})'.format(level=level)


def make_pop(level=1):
    return '(pop {level})'.format(level=level)


def make_exit():
    return "(exit)"


def declare_enum(enum_name:str, values):
    smt_str = '(declare-datatypes () (({0} {1})))'.format(enum_name,
                                                          ' '.join(values))
    return smt_str


def assertion(formula:str):
    smt_str = '(assert ' + formula + ')\n'
    return smt_str


def comment(comment:str):
    comment_lines = str(comment).splitlines()
    smt_str = '; ' + '; '.join(comment_lines)
    return smt_str


def declare_fun(func:FuncDesc) -> str:
    s = '(declare-fun {name} ({arg_types}) {ret_type})'
    arg_types = ' '.join(map(lambda arg_type: arg_type[1],
                             func.ordered_argname_type_pairs))
    return s.format(name=func.name, arg_types=arg_types, ret_type=func.output_ty)


def define_fun(func:FuncDesc, body:str) -> str:
    s = '(define-fun {name} ({args}) {type}' \
        '  ({body})' \
        ')'
    args = ' '.join(map(lambda arg_type: '(%s %s)'%arg_type,
                        func.ordered_argname_type_pairs))
    return s.format(name=func.name, args=args, type=func.output_ty, body=body)


def _get_args_list(self, value_by_argname:Dict[str, str]) -> list:
    my_args = set([p[0] for p in self.ordered_argname_type_pairs])
    given_args = set(value_by_argname.keys())
    assert my_args.issubset(given_args), \
        self.name + ': given values for \n{0}\n, but I need for \n{1}' \
            .format(given_args, my_args)

    ordered_values = []
    for (signal, ty) in self.ordered_argname_type_pairs:
        value = value_by_argname[signal]
        ordered_values.append(value)

    return ordered_values


def get_args_dict(func_desc:FuncDesc, ordered_values) -> dict:
    value_by_arg = dict()
    for i, v in enumerate(ordered_values):
        arg, ty = func_desc.ordered_argname_type_pairs[i]
        value_by_arg[arg] = v
    return value_by_arg


def call_func(func_desc:FuncDesc, func_args_dict:Dict[str, str]) -> str:
    smt_func_args_dict = dict()
    for (var,val) in func_args_dict.items():
        if val is True:
            val = "true"
        elif val is False:
            val = "false"
        smt_func_args_dict[var] = val

    func_args_dict = smt_func_args_dict

    args = _get_args_list(func_desc, func_args_dict)

    smt_str = '(' + func_desc.name + ' '
    for arg in args:
        smt_str += str(arg) + ' '

    if len(args):
        smt_str = smt_str[:-1]
    smt_str += ')'

    return smt_str


def op_implies(arg1, arg2):
    smt_str = '(=> ' + arg1 + ' ' + arg2 + ')'
    return smt_str


def op_eq(arg1, arg2):
    smt_str = '(= ' + arg1 + ' ' + arg2 + ')'
    return smt_str


def op_gt(arg1, arg2):
    return '(> {0} {1})'.format(arg1, arg2)


def op_ge(arg1, arg2):
    return '(>= {0} {1})'.format(arg1, arg2)


def op_not(argument):
    smt_str = '(not ' + argument + ')'
    return smt_str


def make_and_or_xor(arguments, op):
    arguments = list(arguments)
    if len(arguments) == 0:
        return ''

    if len(arguments) == 1:
        return ' ' + arguments[0] + ' '

    return '({0} {1})'.format(op, ' '.join(arguments))


def op_and(arguments):
    filtered_arguments = lfilter(lambda a: a != true(), arguments)
    if not filtered_arguments:
        return true()
    return make_and_or_xor(filtered_arguments, 'and')


def op_or(arguments):
    filtered_arguments = lfilter(lambda a: a != false(), arguments)
    if not filtered_arguments:
        return false()
    return make_and_or_xor(filtered_arguments, 'or')


def forall(free_var_type_pairs, condition):
    if len(free_var_type_pairs) == 0:
        return condition

    forall_pre = ' '.join(['({0} {1})'.format(var, ty) for (var, ty) in free_var_type_pairs])

    return '(forall ({0}) {1})'.format(forall_pre, condition)


def exists(free_var_type_pairs, condition):
    if len(free_var_type_pairs) == 0:
        return condition

    forall_pre = ' '.join(['({0} {1})'.format(var, ty) for (var, ty) in free_var_type_pairs])

    return '(exists ({0}) {1})'.format(forall_pre, condition)


#def unwinding_forall_bool(free_input_vars, operation):
#    if not len(free_input_vars):
#        return operation
#
#    values = product(*[[False, True] for _ in range(len(free_input_vars))])
#
#    #    print(list(values))
#    #    print()
#    #    print(free_input_vars)
#    #    print()
#
#    res = StrAwareList()
#    for free_vars_values in values:
#        var_val_tuples = zip(free_input_vars, free_vars_values)
#
#        concrete_operation = operation
#        for var_val in var_val_tuples:
#            concrete_operation = concrete_operation.replace(var_val[0], str(var_val[1]).lower())
#
#        res += concrete_operation
#
#    return op_and(res)


def forall_bool(free_input_vars, condition):
    return forall([(var, 'Bool') for var in free_input_vars], condition)


def exists_bool(free_input_vars, condition):
    return exists([(var, 'Bool') for var in free_input_vars], condition)


def true():
    return 'true'


def false():
    return 'false'


def get_value(arg:str):
    return "(get-value ({0}))".format(arg)


def bool_type():
    return 'Bool'


def real_type():
    return 'Real'
