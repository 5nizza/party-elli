from helpers.python_ext import lmap, lfilter
from interfaces.func_description import FuncDesc


def get_bits_definition(arg_prefix, nof_bits):
    args = list(map(lambda i: arg_prefix + str(i), range(nof_bits)))
    args_defs = list(map(lambda a: (a, 'Bool'), args))
    return args, args_defs


def make_check_sat():
    return "(check-sat)"


def make_push(level=1):
    return '(push {level})'.format(level=level)


def make_pop(level=1):
    return '(pop {level})'.format(level=level)


def make_get_model():
    return "(get-model)"


def make_exit():
    return "(exit)"


def make_set_logic(logic):
    return ';(set-logic {0})\n'.format(logic.smt_name)


def make_headers():
    return '(set-option :produce-models true)\n'

#TODO: no need of constraints for input values
def declare_bool_const(const_name, value):
    smt = ['(declare-const {0} Bool)\n'.format(const_name),
           '(assert (= {0} {1}))\n'.format(const_name, str(value).lower())]
    return ''.join(smt)


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


def tuple_type(name, component_types):
    args = ' '.join(component_types)
    return '({name} {args})'.format_map({'name': name, 'args': args})


def declare_tuple(name, component_types, getter_prefix):
    """ This implementation is Z3 specific """

    ctor_args = ' '.join(map(lambda i: 'arg' + str(i), range(len(component_types))))
    components_def = ' '.join(map(lambda i, t: '({get}{i} {t})'.format_map({'i': i,
                                                                            't': t,
                                                                            'get': getter_prefix}),
                                  enumerate(component_types)))

    smt_str = """
    (declare-datatypes ({args})
    ( ({name} (mk-pair {components_def})) )
    )
    """.format_map({'args': ctor_args, 'name': name, 'components_def': components_def})

    return smt_str


def make_assert(formula):
    smt_str = '(assert ' + formula + ')\n'
    return smt_str


def comment(comment):
    smt_str = '; ' + str(comment)
    return smt_str


def define_fun(func_desc:FuncDesc) -> str:
    return func_desc.definition  # TODO: looks dirty


def declare_fun(func_desc:FuncDesc) -> str:
    input_types = lmap(lambda i_t: i_t[1], func_desc.inputs)
    smt_str = '(declare-fun '
    smt_str += func_desc.name + ' ('

    for var in input_types:
        smt_str += var + ' '
    if len(input_types):
        smt_str = smt_str[:-1]

    smt_str += ') ' + str(func_desc.output_ty) + ')\n'
    return smt_str


def op_implies(arg1, arg2):
    smt_str = '(=> ' + arg1 + ' ' + arg2 + ')'
    return smt_str


def op_eq(arg1, arg2):
    smt_str = '(= ' + arg1 + ' ' + arg2 + ')'
    return smt_str


def op_gt(arg1, arg2, logic):
    return '({0} {1} {2})'.format(logic.gt, arg1, arg2)


def op_ge(arg1, arg2, logic):
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
    filtered_arguments = lfilter(lambda a: a != true(), arguments)
    return make_and_or_xor(filtered_arguments, 'and')


def op_or(arguments):
    filtered_arguments = lfilter(lambda a: a != false(), arguments)
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

#    return unwinding_forall_bool(free_input_vars, condition)


def true():
    return 'true'


def false():
    return 'false'


def get_value(arg):
    return "(get-value ({0}))".format(arg)


def beautify(s):
    depth = 0
    beautified = ''
    ignore = False  # TODO: dirty
    for i, c in enumerate(s):
        if c is '(':
            if s[i + 1:].strip().startswith('tau'):
                ignore = True
            if not ignore:
                beautified += '\n'
                beautified += '\t' * depth
                depth += 1
        elif c is ')':
            if not ignore:
                depth -= 1
            else:
                ignore = False
        beautified += c

    return beautified
