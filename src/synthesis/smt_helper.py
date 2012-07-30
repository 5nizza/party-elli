def make_check_sat():
    return "(check-sat)"


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


def get_output_name(output):
    return 'fo_' + str(output)


def declare_outputs(outputs):
    smt_lines = list(map(lambda output: declare_fun(get_output_name(output), ["T"], "Bool"), outputs))
    return '\n'.join(smt_lines)


def declare_counters(logic):
    smt_lines = [
        declare_fun("lambda_B", ["Q", "T"], "Bool"),
        declare_fun("lambda_sharp", ["Q", "T"], logic.counters_type(4))]

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
    smt_str = '(declare-datatypes () (({0} {1})))\n'.format(enum_name,
        ' '.join(values))
    return smt_str


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


def func(function, args):
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
    smt_str = '; ' + comment + '\n'
    return smt_str


def declare_fun(name, input_types, out_type):
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


def implies(arg1, arg2):
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
    assert len(arguments) > 0, 'invalid operation "{0}" args "{1}"'.format(str(op), str(arguments))

    if len(arguments) == 1:
        return ' ' + arguments[0] + ' '

    return '({0} {1})'.format(op, ' '.join(arguments))


def op_and(arguments):
    return make_and_or_xor(arguments, 'and')


def op_or(arguments):
    return make_and_or_xor(arguments, 'or')


def op_xor(arguments):
    return make_and_or_xor(arguments, 'xor')


def forall(free_input_vars, condition):
    if len(free_input_vars) == 0:
        return condition

    forall_pre = ' '.join(['({0} Bool)'.format(x) for x in free_input_vars])

    return '(forall ({0}) {1})'.format(forall_pre, condition)


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


