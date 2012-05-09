import itertools
import logging

class Encoder:
    CHECK_SAT = "(check-sat)\n"
    GET_MODEL = "(get-model)\n"
    EXIT_CALL = "(exit)\n"

    def __init__(self, uct, inputs, outputs):
        self._uct = uct
        self._inputs = inputs
        self._outputs = outputs
        self._upsilon = Upsilon(self._inputs)
        self._logger = logging.getLogger(__name__)

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
        smt_str = '(> ' + arg1 + ' ' + arg2 + ')'
        return smt_str

    def _ge(self, arg1, arg2): #is greater than or equal to
        smt_str = '(>= ' + arg1 + ' ' + arg2 + ')'
        return smt_str

    def _lt(self, arg1, arg2): #is less than
        smt_str = '(< ' + arg1 + ' ' + arg2 + ')'
        return smt_str

    def _le(self, arg1, arg2):#is less than or equal to
        smt_str = '(<= ' + arg1 + ' ' + arg2 + ')'
        return smt_str

    def _not(self, argument):
        smt_str = '(not ' + argument + ')'
        return smt_str

    def _and(self, arguments):
        smt_str = '(and '
        smt_str += self._make_and_or_xor_body(arguments) + ')'
        return smt_str

    def _or(self, arguments):
        smt_str = '(or '
        smt_str += self._make_and_or_xor_body(arguments) + ')'
        return smt_str

    def _xor(self, arguments):
        smt_str = '(xor '
        smt_str += self._make_and_or_xor_body(arguments) + ')'
        return smt_str


    def _make_and_or_xor_body(self, arguments):
        smt_str = ''
        for arg in arguments:
            smt_str += arg + ' '
        if len(arguments):
            smt_str = smt_str[:-1]
        return smt_str


    def _forall(self, param_list, expression):
        smt_str = '(forall ('
        for pairs in param_list:             #name-sort pair
            smt_str += '(' + pairs[0] + ' ' + pairs[1] + ')'
        smt_str += ')' + expression + ')'
        return smt_str


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


    def _make_other_declarations(self):
        smt_str = self._comment("Declarations for transition relation, output function and annotation")
        smt_str += self._declare_fun("tau", ["T"] + ['Bool'] * len(self._upsilon._inputs), "T")

        #declare output functions
        for input in self._inputs:
            smt_str += self._declare_fun("fo_" + input, ["T"], "Bool")
        for output in self._outputs:
            smt_str += self._declare_fun("fo_" + output, ["T"], "Bool")

            #declare annotations
        smt_str += self._declare_fun("lambda_B", ["Q", "T"], "Bool")
        smt_str += self._declare_fun("lambda_sharp", ["Q", "T"], "Int")
        smt_str += '\n'

        return smt_str


    def _make_root_condition(self):
        smt_str = self._comment("the root node of the run graph is labelled by a natural number:")

        elements = []
        for state in self._uct.initial_nodes:
            elements.append(self._func("lambda_B", ["q_" + state.name, "t_0"]))

        if len(elements) > 1:
            smt_str += self._assert(self._and(elements))
        else:
            smt_str += self._assert(elements[0])

        return smt_str


    def _make_input_preservation(self, num_impl_states):
        smt_str = self._comment("input preserving:")
        elements = []
        for input in self._inputs:
            for input_values in self._upsilon.enumerate_input_values():
                for impl_state in range(0, num_impl_states):
                    element = self._func("fo_" + input,
                        [self._func("tau",
                            ["t_" + str(impl_state), self._upsilon.make_input_values_str(input_values)])
                        ])

                    if input_values[input] is False:
                        element = self._not(element)
                    elements.append(element)

        smt_str += self._assert(self._and(elements))

        return smt_str


    def _make_trans_condition(self, label, impl_state):
        input_output_list = self._inputs + self._outputs
        and_args = []
        for var in input_output_list:
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

        for uct_state in self._uct.nodes:
            for label, dst_set_list in uct_state.transitions.items():
                assert len(dst_set_list) == 1, 'unsupported: ' + str(dst_set_list)

                dst_set = dst_set_list[0]
                for uct_state_next in dst_set: #TODO: remov shift
                    for input_values in self._upsilon.enumerate_input_values():
                        for impl_state in range(0, num_impl_states):
    #                        smt_str += self._comment(
    #                            'q=q_' + uct_state.name + " (q',v)=(q_" + uct_state_next.name + "," +
    #                            self._upsilon.make_input_values_str(input_values) + "), t=t_" + str(impl_state))

                            implication_left_1 = self._func("lambda_B", ["q_" + uct_state.name, "t_" + str(impl_state)])
                            implication_left_2 = self._make_trans_condition(label, impl_state)

                            if len(implication_left_2) > 0:
                                implication_left = self._and([implication_left_1, implication_left_2])
                            else:
                                implication_left = implication_left_1

                            arg = self._func("tau",
                                ["t_" + str(impl_state), self._upsilon.make_input_values_str(input_values)])
                            implication_right_1 = self._func("lambda_B", ["q_" + uct_state_next.name, arg])

                            gt_arg_1 = self._func("lambda_sharp", ["q_" + uct_state_next.name, arg])
                            gt_arg_2 = self._func("lambda_sharp", ["q_" + uct_state.name, "t_" + str(impl_state)])

                            if uct_state_next not in self._uct.rejecting_nodes:
                                implication_right_2 = self._ge(gt_arg_1, gt_arg_2)
                            else:
                                implication_right_2 = self._gt(gt_arg_1, gt_arg_2)

                            implication_right = self._and([implication_right_1, implication_right_2])

                            smt_str += self._assert(self._implies(implication_left, implication_right))

        return smt_str


    def _make_set_logic(self, logic):
        return '(set-logic {0})\n'.format(logic)


    def _make_headers(self):
        return '(set-option :produce-models true)\n'


    def encode_uct(self, num_impl_states):
        smt_str = self._make_headers()

        smt_str += self._make_set_logic('UFLIA')
        smt_str += self._make_state_declarations([uct_state.name for uct_state in self._uct.nodes], "Q")
        smt_str += self._make_state_declarations([str(impl_state) for impl_state in range(0, num_impl_states)], "T")

        smt_str += self._make_input_declarations()

        smt_str += self._make_other_declarations()

        smt_str += self._make_main_assertions(num_impl_states)

        smt_str += self._make_root_condition()
        smt_str += self._make_input_preservation(num_impl_states)
        smt_str += "\n"
        smt_str += self.CHECK_SAT

        for x in range(0, num_impl_states):
            for input_values in self._upsilon.enumerate_input_values():
                smt_str += "(get-value ((tau t_" + str(x) + " " + self._upsilon.make_input_values_str(
                    input_values) + ")))\n"
        for x in range(0, num_impl_states):
            smt_str += "(get-value (t_" + str(x) + "))\n"

        for input in self._inputs:
            for x in range(0, num_impl_states):
                smt_str += "(get-value ((fo_" + input + " t_" + str(x) + ")))\n"
        for output in self._outputs:
            for x in range(0, num_impl_states):
                smt_str += "(get-value ((fo_" + output + " t_" + str(x) + ")))\n"
        smt_str += self.EXIT_CALL

        self._logger.debug(smt_str)

        return smt_str


    def _declare_bool_const(self, const_name, value):
        smt = ['(declare-const {0} Bool)\n'.format(const_name),
               '(assert (= {0} {1}))\n'.format(const_name, str(value).lower())]
        return ''.join(smt)


class Upsilon:
    def __init__(self, inputs):
        self._inputs = inputs


    def enumerate_input_values(self):
        """ Return list of maps: [{var:val, var:val}, {..}, ...]
        """
        values_tuples = list(itertools.product([False, True], repeat=len(self._inputs)))

        result = []
        for values_tuple in values_tuples:
            values = {}
            for i, value in enumerate(values_tuple):
                var = self._inputs[i]
                values[var] = value
            result.append(values)
        return result


    def make_input_values_str(self, input_values):
        valued_vars = []
        for var, value in input_values.items():
            valued_vars.append(self.get_valued_var_name(var, value))

        return ' '.join(valued_vars)


    def get_valued_var_name(self, var, value):
        return '{0}{1}'.format('i_' if value else 'i_not_', var)