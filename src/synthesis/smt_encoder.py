import itertools
import logging
from math import log, ceil
from helpers.ordered_set import OrderedSet

class Logic:
    def counters_type(self, max_counter_value):
        pass
    @property
    def smt_name(self):
        pass
    @property
    def gt(self):
        pass
    @property
    def ge(self):
        pass


class UFBV(Logic):
    def counters_type(self, max_counter_value):
        width = int(ceil(log(max(max_counter_value, 2), 2)))
        return '(_ BitVec {0})'.format(width)

    @property
    def smt_name(self):
        return 'UFBV'

    @property
    def gt(self):
        return 'bvugt'

    @property
    def ge(self):
        return 'bvuge'


class UFLIA(Logic):
    def counters_type(self, max_counter_value):
        return 'Int'

    @property
    def smt_name(self):
        return 'UFLIA'

    @property
    def gt(self):
        return '>'

    @property
    def ge(self):
        return '>='


class Encoder:
    CHECK_SAT = "(check-sat)\n"
    GET_MODEL = "(get-model)\n"
    EXIT_CALL = "(exit)\n"

    def __init__(self, automaton, inputs, outputs, logic):
        self._automaton = automaton
        self._upsilon = Upsilon(inputs)
        self._outputs = outputs
        self._logger = logging.getLogger(__name__)
        self._logic = logic

    def _func(self, function, args):
        smt_str = '(' + function + ' '
        for arg in args:
            smt_str += arg + ' '
        if len(args):
            smt_str = smt_str[:-1]
        smt_str += ')'
        return smt_str

    def _assert(self, formula):
        smt_str = '(assert ' + formula + ')\n'
        return smt_str

    def _comment(self, comment):
        smt_str = '; ' + comment + '\n'
        return smt_str

    def _declare_fun(self, name, vars, type):
        smt_str = '(declare-fun '
        smt_str += name + ' ('

        for var in vars:
            smt_str += var + ' '
        if len(vars):
            smt_str = smt_str[:-1]

        smt_str += ') ' + type + ')\n'
        return smt_str

    def _declare_sort(self, name, num_param):
        smt_str = '(declare-sort '
        smt_str += name + ' ' + str(num_param) + ')\n'
        return smt_str

    def _implies(self, arg1, arg2):
        smt_str = '(=> ' + arg1 + ' ' + arg2 + ')'
        return smt_str

    def _eq(self, arg1, arg2): #is equal to
        smt_str = '(= ' + arg1 + ' ' + arg2 + ')'
        return smt_str

    def _gt(self, arg1, arg2): #is greater than
        return '({0} {1} {2})'.format(self._logic.gt, arg1, arg2)

    def _ge(self, arg1, arg2): #is greater than or equal to
        return '({0} {1} {2})'.format(self._logic.ge, arg1, arg2)

    def _not(self, argument):
        smt_str = '(not ' + argument + ')'
        return smt_str


    def _make_and_or_xor(self, arguments, op):
        if len(arguments) == 1:
            return ' ' + arguments[0] + ' '

        return '({0} {1})'.format(op, ' '.join(arguments))


    def _and(self, arguments):
        return self._make_and_or_xor(arguments, 'and')


    def _or(self, arguments):
        return self._make_and_or_xor(arguments, 'or')


    def _xor(self, arguments):
        return self._make_and_or_xor(arguments, 'xor')


    def _forall(self, free_input_vars, condition):
        if len(free_input_vars) == 0:
            return condition

        forall_pre = ' '.join(['({0} Bool)'.format(x) for x in free_input_vars])

        return '(forall ({0}) {1})'.format(forall_pre, condition)


    def _make_state_declarations(self, state_names, sort_name):
        smt_str = '(declare-datatypes () (({0} {1})))\n'.format(sort_name,
            ' '.join([sort_name.lower() + '_' + x for x in state_names]))
        return smt_str


    def _make_input_declarations(self):
        smt_str = ''
        for input_var in self._upsilon._inputs:
            for value in [False, True]:
                smt_str += self._declare_bool_const(self._upsilon.get_valued_var_name(input_var, value), value)

        smt_str += '\n'
        return smt_str


    def _make_func_declarations(self, nof_impl_states):
        smt_str = self._comment("Declarations for transition relation, output function and annotation")
        smt_str += self._declare_fun("tau", ["T"] + ['Bool'] * len(self._upsilon._inputs), "T")

        for output in self._outputs:
            smt_str += self._declare_fun("fo_" + output, ["T"], "Bool")

        smt_str += self._declare_fun("lambda_B", ["Q", "T"], "Bool")
        smt_str += self._declare_fun("lambda_sharp", ["Q", "T"], self._logic.counters_type(1))
        smt_str += '\n'

        return smt_str


    def _make_initial_states_condition(self):
        or_args = []
        for initial_set in self._automaton.initial_sets_list:
            and_args = []
            for state in initial_set:
                and_args.append(self._func("lambda_B", ["q_" + state.name, "t_0"]))
            or_args.append(self._and(and_args))

        return self._assert(self._or(or_args))


    def _make_trans_condition_on_output_vars(self, label, impl_state):
        and_args = []
        for var in self._outputs:
            if (var in label) and (label[var] is True):
                and_args.append(self._func("fo_" + var, ["t_" + str(impl_state)]))
            elif (var in label) and (label[var] is False):
                and_args.append(self._not(self._func("fo_" + var, ["t_" + str(impl_state)])))
            elif var not in label:
                pass
            else:
                assert False, "Error: Variable in label has wrong value: " + label[var]

        smt_str = ' '
        if len(and_args) > 1:
            smt_str = self._and(and_args)
        elif len(and_args) == 1:
            smt_str = and_args[0]

        return smt_str


    def _make_main_assertions(self, num_impl_states):
        smt_str = self._comment("main assertions")

        for spec_state in self._automaton.nodes:
            for label, dst_set_list in spec_state.transitions.items():
                if not len(list(itertools.chain(*dst_set_list))): #TODO: why?
                    continue

                for impl_state in range(0, num_impl_states):
#                    smt_str += self._comment()

                    implication_left_1 = self._func("lambda_B", ["q_" + spec_state.name, "t_" + str(impl_state)])
                    implication_left_2 = self._make_trans_condition_on_output_vars(label, impl_state)

                    if len(implication_left_2) > 0:
                        implication_left = self._and([implication_left_1, implication_left_2])
                    else:
                        implication_left = implication_left_1

                    input_values = {}
                    for input_var in self._upsilon.inputs:
                        if input_var in label:
                            input_values[input_var] = label[input_var]

                    tau_args, free_input_vars = self._upsilon.make_tau_arg_list(input_values)
                    sys_next_state = self._func("tau", ["t_" + str(impl_state)] + tau_args)

                    or_args = []
                    for dst_set in dst_set_list:
                        and_args = []
                        for spec_next_state in dst_set:
                            implication_right_1 = self._func("lambda_B", ["q_" + spec_next_state.name, sys_next_state])

                            crt_sharp = self._func("lambda_sharp", ["q_" + spec_state.name, "t_" + str(impl_state)])
                            next_sharp = self._func("lambda_sharp", ["q_" + spec_next_state.name, sys_next_state])

                            greater = [self._ge, self._gt][spec_next_state in self._automaton.rejecting_nodes]
                            implication_right_2 = greater(next_sharp, crt_sharp)

                            implication_right = self._and([implication_right_1, implication_right_2])
                            and_args.append(implication_right)

                        or_args.append(self._and(and_args))

                    smt_addition = self._assert(self._implies(implication_left, self._forall(free_input_vars, self._or(or_args))))

                    smt_str += smt_addition

        return smt_str


    def _make_set_logic(self):
        return ';(set-logic {0})\n'.format(self._logic.smt_name)


    def _make_headers(self):
        return '(set-option :produce-models true)\n'

    def _make_get_values(self, num_impl_states):
        smt_str = ''
        for s in range(0, num_impl_states):
            for input_values in self._upsilon.enumerate_input_values():
                smt_str += "(get-value ({0}))\n".format(self._func("tau", ['t_'+str(s)] + self._upsilon.make_tau_arg_list(input_values)[0]))
        for s in range(0, num_impl_states):
            smt_str += "(get-value (t_{0}))\n".format(s)

        for output in self._outputs:
            for s in range(0, num_impl_states):
                smt_str += "(get-value ((fo_{0} t_{1})))\n".format(output, s)

        return smt_str


    def _declare_bool_const(self, const_name, value):
        smt = ['(declare-const {0} Bool)\n'.format(const_name),
               '(assert (= {0} {1}))\n'.format(const_name, str(value).lower())]
        return ''.join(smt)


    def encode(self, num_impl_states):
        smt_str = self._make_headers()
        smt_str += "\n"
        smt_str += self._make_set_logic()
        smt_str += "\n"
        smt_str += self._make_state_declarations([node.name for node in self._automaton.nodes], "Q")
        smt_str += "\n"
        smt_str += self._make_state_declarations([str(t) for t in range(0, num_impl_states)], "T")
        smt_str += "\n"
        smt_str += self._make_input_declarations()
        smt_str += "\n"
        smt_str += self._make_func_declarations(num_impl_states)
        smt_str += "\n"
        smt_str += self._make_initial_states_condition()
        smt_str += "\n"
        smt_str += self._make_main_assertions(num_impl_states)
        smt_str += "\n"
        smt_str += self.CHECK_SAT
        smt_str += "\n"
        smt_str += self._make_get_values(num_impl_states)
        smt_str += "\n"
        smt_str += self.EXIT_CALL
        smt_str += "\n"

        self._logger.debug(smt_str)

        return smt_str


class Upsilon:
    def __init__(self, inputs):
        self._inputs = OrderedSet(list(inputs))


    def enumerate_input_values(self):
        """ Return list of maps: [{var:val, var:val}, {..}, ...] """

        values_tuples = list(itertools.product([False, True], repeat=len(self._inputs)))

        result = []
        for values_tuple in values_tuples:
            values = {}
            for i, (var, value) in enumerate(zip(self._inputs, values_tuple)):
                values[var] = value
            result.append(values)
        return result


    def make_tau_arg_list(self, input_values): #TODO: use ?var_name instead of var_name in forall
        """ Return tuple (list of tau args(in correct order), free vars):
            for variables without values use variable name (you should enumerate them afterwards).
        """

        valued_vars = []
        free_vars = set()
        for var_name in self._inputs:
            if var_name in input_values:
                valued_vars.append(self.get_valued_var_name(var_name, input_values[var_name]))
            else:
                valued_vars.append(var_name)
                free_vars.add(var_name)

        return valued_vars, free_vars


    def get_valued_var_name(self, var, value):
        return '{0}{1}'.format('i_' if value else 'i_not_', var)

    @property
    def inputs(self):
        return self._inputs