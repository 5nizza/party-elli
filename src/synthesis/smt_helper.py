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


def declare_bool_const(const_name, value):
    smt = ['(declare-const {0} Bool)\n'.format(const_name),
           '(assert (= {0} {1}))\n'.format(const_name, str(value).lower())]
    return ''.join(smt)


def make_func_declarations(inputs, outputs, logic):
    smt_lines = [
        comment("Declarations of the transition relation, output function and annotation"),
        declare_fun("tau", ["T"] + ['Bool'] * len(inputs), "T"),
        declare_fun("lambda_B", ["Q", "T"], "Bool"),
        declare_fun("lambda_sharp", ["Q", "T"], logic.counters_type(4))]

    smt_lines.extend(
        map(lambda output: declare_fun("fo_" + output, ["T"], "Bool"), outputs))

    return '\n'.join(smt_lines)


def get_valued_var_name(var, value):
    return '{0}{1}'.format('i_' if value else 'i_not_', var)


def make_input_declarations(inputs):
    smt_str = ''
    for input_var in inputs:
        for value in [False, True]:
            smt_str += declare_bool_const(get_valued_var_name(input_var, value), value)

    smt_str += '\n'
    return smt_str


def make_state_declarations(state_names, sort_name):
    smt_str = '(declare-datatypes () (({0} {1})))\n'.format(sort_name,
        ' '.join(state_names))
    return smt_str


def func(function, args):
    smt_str = '(' + function + ' '
    for arg in args:
        smt_str += arg + ' '
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

def declare_fun(name, vars, type):
    smt_str = '(declare-fun '
    smt_str += name + ' ('

    for var in vars:
        smt_str += var + ' '
    if len(vars):
        smt_str = smt_str[:-1]

    smt_str += ') ' + type + ')\n'
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