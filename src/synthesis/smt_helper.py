from itertools import product
import math
from helpers.python_ext import StrAwareList
from interfaces.parser_expr import QuantifiedSignal


def build_values_from_label(signals, label) -> (dict, list):
    for s in signals: #TODO: remove after debug
        assert isinstance(s, QuantifiedSignal)

    value_by_signal = dict()
    free_values = []

    for s in signals:
        if s in label:
            value_by_signal[s] = str(label[s]).lower()
        else:
            value = '?{0}'.format(str(s)).lower() #TODO: hack: we str(signal)
            value_by_signal[s] = value
            free_values.append(value)

    return value_by_signal, free_values


def get_bits_definition(arg_prefix, nof_bits):
    args  = list(map(lambda i: arg_prefix+str(i), range(nof_bits)))
    args_defs = list(map(lambda a: (a, 'Bool'), args))
    return args, args_defs


def make_check_sat():
    return "(check-sat)"


def make_get_model():
    return "(get-model)"


def make_exit():
    return "(exit)"


def make_set_logic(logic):
    return ';(set-logic {0})\n'.format(logic.smt_name)


def make_headers():
    #TODO: ask stackoverflow about other speed upers
    #ematching slows down if forall quantifier is present
    return '(set-option :produce-models true)\n(set-option :EMATCHING false)\n'


#TODO: no need of constraints for input values
def declare_bool_const(const_name, value):
    smt = ['(declare-const {0} Bool)\n'.format(const_name),
           '(assert (= {0} {1}))\n'.format(const_name, str(value).lower())]
    return ''.join(smt)


def get_output_name(output):
    return 'fo_' + str(output)


def declare_output(output, sys_state_type):
    return declare_fun(get_output_name(output), [sys_state_type], "Bool")


def declare_counters(logic, sys_state_type, spec_state_type):
    smt_lines = [
        declare_fun("lambda_B", [spec_state_type, sys_state_type], "Bool"),
        declare_fun("lambda_sharp", [spec_state_type, sys_state_type], logic.counters_type(4))]

    return '\n'.join(smt_lines)


def get_valued_var_name(var, value):
    return '{0}{1}'.format('i_' if value else 'i_not_', var)


def declare_inputs(inputs):
    smt_str = ''
    for input_var in inputs:
        for value in [False, True]:
            smt_str += declare_bool_const(get_valued_var_name(input_var, value), value)

    smt_str += '\n'
    return smt_str


def declare_enum(enum_name, values):
    smt_str = '(declare-datatypes () (({0} {1})))'.format(enum_name,
        ' '.join(values))
    return smt_str

#def declare_enum_as_int_consts(names):
#    smt_lines = StrAwareList()
#    for crt_val, n in enumerate(names):
#        smt_lines += '(declare-const {name} Int)'.format(
#            name = n)
#
#        smt_lines += '(assert (= {name} {value}))'.format(
#            name=n,
#            value=crt_val)
#
#    return '\n'.join(smt_lines)
#
#
#def declare_enum_as_bv_consts(names):
#    smt_lines = StrAwareList()
#
#    width = int(max(int(math.ceil(math.log(len(names), 2))), 1))
#    for crt_val, n in enumerate(names):
#        smt_lines += '(declare-const {name} {type})'.format(
#            name = n,
#            type = '(_ bv {width})'.format(width = width))
#
#        smt_lines += '(assert (= {name} {value}))'.format(
#            name=n,
#            value='(_ bv{width} {value})'.format(width=width, value = crt_val))
#
#    return '\n'.join(smt_lines)


def tuple_type(name, component_types):
    args = ' '.join(component_types)
    return '({name} {args})'.format_map({'name':name, 'args':args})


def declare_tuple(name, component_types, getter_prefix):
    """ This implementation is Z3 specific """

    ctor_args = ' '.join(map(lambda i: 'arg'+str(i), range(len(component_types))))
    components_def = ' '.join(map(lambda i,t: '({get}{i} {t})'.format_map({'i':i,
                                                                           't':t,
                                                                           'get':getter_prefix}),
                                  enumerate(component_types)))

    smt_str = """
    (declare-datatypes ({args})
    ( ({name} (mk-pair {components_def})) )
    )
    """.format_map({'args':ctor_args, 'name':name, 'components_def':components_def})

    return smt_str


def call_func(function, args):
    smt_str = '(' + function + ' '
    for arg in args:
        smt_str += str(arg) + ' '
    if len(args):
        smt_str = smt_str[:-1]
    smt_str += ')'
    return smt_str


def make_assert(formula):
    smt_str = '(assert ' + formula + ')\n'
    return smt_str


def comment(comment):
    smt_str = '; ' + str(comment)
    return smt_str


def declare_fun(name, input_types, out_type):
    input_types = list(input_types)
    smt_str = '(declare-fun '
    smt_str += name + ' ('

    for var in input_types:
        smt_str += var + ' '
    if len(input_types):
        smt_str = smt_str[:-1]

    smt_str += ') ' + out_type + ')\n'
    return smt_str


def declare_sort(name, num_param):
    smt_str = '(declare-sort '
    smt_str += name + ' ' + str(num_param) + ')\n'
    return smt_str


def op_implies(arg1, arg2):
    smt_str = '(=> ' + arg1 + ' ' + arg2 + ')'
    return smt_str


def eq(arg1, arg2): #is equal to
    smt_str = '(= ' + arg1 + ' ' + arg2 + ')'
    return smt_str


def gt(arg1, arg2, logic):
    return '({0} {1} {2})'.format(logic.gt, arg1, arg2)


def ge(arg1, arg2, logic):
    return '({0} {1} {2})'.format(logic.ge, arg1, arg2)


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
    return make_and_or_xor(arguments, 'and')


def op_or(arguments):
    return make_and_or_xor(arguments, 'or')


def op_xor(arguments):
    return make_and_or_xor(arguments, 'xor')


def forall(free_var_type_pairs, condition):
    if len(free_var_type_pairs) == 0:
        return condition

    forall_pre = ' '.join(['({0} {1})'.format(var, type) for (var,type) in free_var_type_pairs])

    return '(forall ({0}) {1})'.format(forall_pre, condition)


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
#    return unwinding_forall_bool(free_input_vars, condition)


def true():
    return ' true '


def false():
    return ' false '


def get_value(arg):
    return "(get-value ({0}))".format(arg)


def beautify(s):
    depth = 0
    beautified = ''
    ignore = False #TODO: dirty
    for i, c in enumerate(s):
        if c is '(':
            if s[i+1:].strip().startswith('tau'):
                ignore = True
            if not ignore:
                beautified += '\n'
                beautified += '\t'*depth
                depth += 1
        elif c is ')':
            if not ignore:
                depth -= 1
            else:
                ignore = False
        beautified += c

    return beautified


