import itertools
import logging
from math import log, ceil
from helpers.ordered_set import OrderedSet


class Logic:
    def counters_type(self, max_counter_value):
        pass
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
        self._signals = Signals(inputs, outputs)
        self._logic = logic
        self._logger = logging.getLogger(__name__)


    def _lambdaB(self, spec_state, sys_state_expression):
        return self._func("lambda_B", ['q_' + spec_state.name, sys_state_expression])


    def _counter(self, spec_state, sys_state_expression):
        return self._func("lambda_sharp", ['q_' + spec_state.name, sys_state_expression])


    def _tau(self, sys_state, args_str):
        return self._func("tau", [sys_state] + args_str)


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

    def _gt(self, arg1, arg2):
        return '({0} {1} {2})'.format(self._logic.gt, arg1, arg2)

    def _ge(self, arg1, arg2):
        return '({0} {1} {2})'.format(self._logic.ge, arg1, arg2)

    def _not(self, argument):
        smt_str = '(not ' + argument + ')'
        return smt_str


    def _make_and_or_xor(self, arguments, op):
        assert len(arguments) > 0, 'invalid operation "{0}" args "{1}"'.format(str(op), str(arguments))

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
        for input_var in self._signals._inputs:
            for value in [False, True]:
                smt_str += self._declare_bool_const(self._signals.get_valued_var_name(input_var, value), value)

        smt_str += '\n'
        return smt_str


    def _make_func_declarations(self, nof_impl_states):
        smt_str = self._comment("Declarations for transition relation, output function and annotation")
        smt_str += self._declare_fun("tau", ["T"] + ['Bool'] * len(self._signals._inputs), "T")

        for output in self._signals.outputs:
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
                and_args.append(self._func("lambda_B", ["q_" + state.name, "t_0"])) #TODO: get rid off t_
            or_args.append(self._and(and_args))

        return self._assert(self._or(or_args))


    def _assert_out_values(self, label, sys_state):
        and_args = []
        for var in self._signals.outputs:
            if (var in label) and (label[var] is True):
                and_args.append(self._func("fo_" + var, [sys_state])) #TODO: get rid off fo_
            elif (var in label) and (label[var] is False):
                and_args.append(self._not(self._func("fo_" + var, [sys_state])))
            elif var not in label:
                pass
            else:
                assert False, "Error: wrong variable value: " + label[var]

        smt_str = ' '
        if len(and_args) > 1:
            smt_str = self._and(and_args)
        elif len(and_args) == 1:
            smt_str = and_args[0]

        return smt_str


    def _get_input_values(self, label):
        input_values = {}
        for input_var in self._signals.inputs:
            if input_var in label:
                input_values[input_var] = label[input_var]

        return input_values


    def _is_end_node(self, spec_state):
        return spec_state.name == '' #TODO: dirty hack!

#
#    def _make_transition(self, src_root_clause, label):
#        """ Return tuple (list_of_sets, [state->[src, src], ..] ) """
#        root_node = _make_dnf(src_root_clause)
#        assert root_node.type == self.Clause.OR or \
#            root_node.type == self.Clause.TERM
#
#
#


    def _get_guarantees(self, spec_state, sys_state):
        labels = spec_state.transitions.keys()

        output_ors = []
        for out_values in self._signals.enumerate_out_values():
            if self._signals.is_forbidden_label_values(out_values, labels):
                continue #forbid outputs which are not in the spec graph by excluding them from top OR

            inputs_ands = []
            for in_values in self._signals.enumerate_input_values():
                all_values = dict(list(in_values.items()) +
                                  list(out_values.items()))

                if self._signals.is_forbidden_label_values(all_values, labels):
                    inputs_ands = [self._false()]
                    break #advisory will always make you loose here, so break

                dst_set_list = self._signals.get_relevant_edges(all_values, spec_state)

                non_determinism = []
                for dst_set in dst_set_list:

                    universality = []
                    for spec_next_state in dst_set:
                        if self._is_end_node(spec_next_state):
                            universality.append(self._true())
                            continue

                        tau_args, free_in_vars = self._signals.make_tau_arg_list(in_values)
                        assert len(free_in_vars) == 0

                        sys_next_state = self._tau(sys_state, tau_args)
                        new_transition = self._and([self._lambdaB(spec_next_state, sys_next_state),
                                                    self._counter_greater(spec_next_state, sys_next_state,
                                                                          spec_state, sys_state)])
                        universality.append(new_transition)

                    non_determinism.append(self._and(universality))

                inputs_ands.append(self._or(non_determinism))

            output_ors.append(self._and([self._assert_out_values(out_values, sys_state)] + inputs_ands))

        return self._or(output_ors)


    def _make_transition_assertions(self, num_impl_states):
        smt_str = self._comment("transition assertions")

        for spec_state in self._automaton.nodes:
            if self._is_end_node(spec_state):
                continue

            for sys_state in ['t_' + str(x) for x in range(0, num_impl_states)]:
                assumption = self._lambdaB(spec_state, sys_state)
                guarantee = self._get_guarantees(spec_state, sys_state)
                implication = self._implies(assumption, guarantee)
                assertion = self._assert(implication)
                smt_str += self._beautify(assertion) + '\n'

        return smt_str




#
#            for sys_state in range(0, num_impl_states):
#
#                assumption = self._func("lambda_B", ["q_" + spec_state.name, "t_" + str(sys_state)])
#                transition_guarantees = []
#
#                for label, dst_set_list in spec_state.transitions.items():
#                    input_values = {}
#                    for input_var in self._upsilon.inputs:
#                        if input_var in label:
#                            input_values[input_var] = label[input_var]
#
#                    tau_args, free_input_vars = self._upsilon.make_tau_arg_list(input_values)
#                    sys_next_state = self._func("tau", ["t_" + str(sys_state)] + tau_args)
#
#                    lbl_output_clause = self._make_trans_condition_on_output_vars(label, sys_state)
#
#                    or_guarantees = []
#                    for dst_set in dst_set_list:
#                        and_guarantees = [lbl_output_clause]
#                        for spec_next_state in dst_set:
#                            guarantee_run_graph = self._func("lambda_B", ["q_" + spec_next_state.name, sys_next_state])
#
#                            greater = [self._ge, self._gt][spec_next_state in self._automaton.rejecting_nodes]
#                            crt_sharp = self._func("lambda_sharp", ["q_" + spec_state.name, "t_" + str(sys_state)])
#                            next_sharp = self._func("lambda_sharp", ["q_" + spec_next_state.name, sys_next_state])
#                            guarantee_counters = greater(next_sharp, crt_sharp)
#
#                            guarantee = self._and([guarantee_run_graph, guarantee_counters])
#                            and_guarantees.append(guarantee)
#
#                        or_guarantees.append(self._and(and_guarantees))
#
#                    transition_guarantees.append(self._forall(free_input_vars, self._or(or_guarantees)))
#
#                smt_addition = self._assert(self._implies(assumption, self._and(transition_guarantees)))
#                smt_str += smt_addition

#        return smt_str


    def _make_set_logic(self):
        return ';(set-logic {0})\n'.format(self._logic.smt_name)


    def _make_headers(self):
        return '(set-option :produce-models true)\n'


    def _make_get_values(self, num_impl_states):
        smt_str = ''
        for s in range(0, num_impl_states):
            for input_values in self._signals.enumerate_input_values():
                smt_str += "(get-value ({0}))\n".format(self._func("tau", ['t_'+str(s)] + self._signals.make_tau_arg_list(input_values)[0]))
        for s in range(0, num_impl_states):
            smt_str += "(get-value (t_{0}))\n".format(s)

        for output in self._signals.outputs:
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
        smt_str += self._make_transition_assertions(num_impl_states)
        smt_str += "\n"
        smt_str += self.CHECK_SAT
        smt_str += "\n"
        smt_str += self._make_get_values(num_impl_states)
        smt_str += "\n"
        smt_str += self.EXIT_CALL
        smt_str += "\n"

        self._logger.debug(smt_str)

        return smt_str


    def _true(self):
        return ' true '
    def _false(self):
        return ' false '


    def _counter_greater(self, next_spec_state, next_sys_state, spec_state, sys_state):
        crt_counter = self._counter(spec_state, sys_state)
        next_counter = self._counter(next_spec_state, next_sys_state)

        greater_func = [self._ge, self._gt][next_spec_state in self._automaton.rejecting_nodes]
        counters_relation = greater_func(next_counter, crt_counter)

        return counters_relation


    def _beautify(self, s):
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


class Signals:
    def __init__(self, inputs, outputs):
        self._inputs = OrderedSet(list(inputs))
        self._outputs = outputs


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

    @property
    def outputs(self):
        return self._outputs


    def _enumerate_values(self, variables):
        """ Return list of maps: [ {var:val, var:val}, ..., {var:val, var:val} ] """

        values_tuples = list(itertools.product([False, True], repeat=len(variables)))

        result = []
        for values_tuple in values_tuples:
            values = {}
            for i, (var, value) in enumerate(zip(variables, values_tuple)):
                values[var] = value
            result.append(values)
        return result


    def enumerate_out_values(self):
        return self._enumerate_values(self._outputs)


    def enumerate_input_values(self):
        return self._enumerate_values(self._inputs)


    def is_forbidden_label_values(self, var_values, labels):
        return sum(map(lambda l: self.satisfies(var_values, l), labels)) == 0


    def satisfies(self, all_values, label):
        for var, val in all_values.items():
            if var not in label:
                continue
            if label[var] != val:
                return False
        return True


    def get_relevant_edges(self, var_values, spec_state):
        """ Return dst_sets_list """
        relevant_edges = []

        for label, dst_set_list in spec_state.transitions.items():
            if not self.satisfies(var_values, label):
                continue #consider only edges with labels that are satisfied by current signal values

            relevant_edges.extend(dst_set_list)

        return relevant_edges


