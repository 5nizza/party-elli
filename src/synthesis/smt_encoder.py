import itertools
import logging
from helpers.boolean import AND, OR, Symbol, normalize, FALSE, TRUE
from helpers.ordered_set import OrderedSet
from interfaces.automata import get_next_states, satisfied, Node, Automaton, to_dot
from itertools import chain


def _get_spec_states_of_clause(spec_state_clause, terminals):
    symbols = spec_state_clause.symbols
    symbol_to_state = dict([(x[1],x[0]) for x in terminals.items()])
    states = set(map(lambda s: symbol_to_state[s], symbols))
    return states


def _build_clause(term_clauses, list_of_state_sets):
    if len(list_of_state_sets) is 0:
        return FALSE

#    print('\n'.join([str(t) for t in terminals]))
#    print()
#    print()

    ors = []
    for state_set in list_of_state_sets:
        if len(state_set) > 1:
            and_args = list(map(lambda s: term_clauses[s], state_set))
            ors.append(AND(*and_args))
        else:
            state = list(state_set)[0]
#            print(str(state))
            ors.append(term_clauses[state])

    if len(ors) > 1:
        clause = OR(*ors)
    else:
        clause = ors[0]

    return clause


class Encoder:
    CHECK_SAT = "(check-sat)"
    GET_MODEL = "(get-model)"
    EXIT_CALL = "(exit)"

    def __init__(self, automaton, inputs, outputs, logic):
        self._automaton = automaton
        self._signals = Signals(inputs, outputs)
        self._logic = logic
        self._logger = logging.getLogger(__name__)


    def _lambdaB(self, spec_state_name, sys_state_expression):
        return self._func("lambda_B", [spec_state_name, sys_state_expression])

    def _counter(self, spec_state_name, sys_state_expression):
        return self._func("lambda_sharp", [spec_state_name, sys_state_expression])


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
                                                                ' '.join(state_names))
        return smt_str


    def _make_input_declarations(self):
        smt_str = ''
        for input_var in self._signals._inputs:
            for value in [False, True]:
                smt_str += self._declare_bool_const(self._signals.get_valued_var_name(input_var, value), value)

        smt_str += '\n'
        return smt_str


    def _make_func_declarations(self, nof_impl_states):
        smt_str = self._comment("Declarations of transition relation, output function and annotation")
        smt_str += self._declare_fun("tau", ["T"] + ['Bool'] * len(self._signals._inputs), "T")

        for output in self._signals.outputs:
            smt_str += self._declare_fun("fo_" + output, ["T"], "Bool")

        smt_str += self._declare_fun("lambda_B", ["Q", "T"], "Bool")
        smt_str += self._declare_fun("lambda_sharp", ["Q", "T"], self._logic.counters_type(1))
        smt_str += '\n'

        return smt_str


    def _make_initial_states_condition(self, initial_spec_state_name):
        return self._assert(self._func("lambda_B", [initial_spec_state_name, "t_0"]))


    def _condition_on_output(self, label, sys_state):
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


    def _convert_state_clause_to_lambdaB(self,
                                         next_spec_state_clause,
                                         next_sys_state):
        if (str(next_spec_state_clause)) == '0':
            assert next_spec_state_clause == FALSE

        if next_spec_state_clause == TRUE:
            guarantee = self._true()
        elif next_spec_state_clause == FALSE:
            guarantee = self._false()
        else:
            guarantee = self._lambdaB(self._get_smt_name(next_spec_state_clause), next_sys_state)

        return guarantee


    def _get_create_node(self, spec_state_clause):
        if getattr(self, '_my_nodes', None) is None:
            self._my_nodes = {}
            self._my_keys = set()

        assert spec_state_clause != FALSE

        self._my_keys.add(spec_state_clause)

        name = str(spec_state_clause)
        if spec_state_clause == TRUE:
            name = 'OK'
        node = self._my_nodes[spec_state_clause] = self._my_nodes.get(spec_state_clause, Node(name))
        return node


    def _make_state_transition_assertions(self,
                                          sys_state,
                                          spec_state_clause,
                                          state_to_clause,
                                          clauses_generated):
        # of the form: spec_state(t) & output
        # --(in,out)-->
        # next_spec_state (tau(input))
        assertions = []
        for input in self._signals.enumerate_input_values():
            for output in self._signals.enumerate_out_values():
                signal_values = dict(chain(input.items(), output.items()))

                assumption_on_crt_state = self._lambdaB(self._get_smt_name(spec_state_clause), sys_state)
                assumption_on_output = self._condition_on_output(signal_values, sys_state)

                next_spec_state_clause = self._get_next_spec_state_clause(signal_values, spec_state_clause, state_to_clause)
                # next_spec_state_clause may be True/False/clause

                #
                if next_spec_state_clause != FALSE:
                    crt_node = self._get_create_node(spec_state_clause)
                    crt_node.add_transition(signal_values, {self._get_create_node(next_spec_state_clause)})
                #

                if next_spec_state_clause != TRUE and next_spec_state_clause != FALSE:
                    clauses_generated.add(next_spec_state_clause)

                tau_args, free_in_vars = self._signals.make_tau_arg_list(signal_values)
                assert len(free_in_vars) == 0

                next_sys_state = self._tau(sys_state, tau_args)

                guarantee_lambdaB = self._convert_state_clause_to_lambdaB(next_spec_state_clause, next_sys_state)

                guarantee_counter = self._true()
                if next_spec_state_clause != TRUE and next_spec_state_clause != FALSE:
                    guarantee_counter = self._counter_greater(next_spec_state_clause, next_sys_state,
                                                              spec_state_clause, sys_state,
                                                              state_to_clause)

                guarantee = self._and([guarantee_lambdaB, guarantee_counter])

                implication = self._implies(self._and([assumption_on_crt_state, assumption_on_output]),
                                            guarantee)

                assertions.append(self._assert(implication))

        return assertions


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

            output_ors.append(self._and([self._condition_on_output(out_values, sys_state)] + inputs_ands))

        return self._or(output_ors)


    def _make_transition_assertions(self, terms, sys_states):
        assertions = []

        for sys_state in sys_states:
            explored_clauses = set()
            unexplored_clauses = {_build_clause(terms, self._automaton.initial_sets_list)}

            while unexplored_clauses:
                crt_clause = unexplored_clauses.pop()

                clauses_generated = set()
                assertions.extend(self._make_state_transition_assertions(sys_state,
                    crt_clause,
                    terms,
                    clauses_generated))

                explored_clauses.add(crt_clause)

                unexplored_clauses.update(clauses_generated.difference(explored_clauses))

        return '\n'.join(assertions), explored_clauses


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


    def _build_terminals(self):
        term_clauses = dict([(s, Symbol(s.name)) for s in self._automaton.nodes if s.name != ''])
        true_states = list(filter(lambda x: x.name == '', self._automaton.nodes))

        if true_states is not None and len(true_states) == 1:
            term_clauses[true_states[0]] = TRUE

        return term_clauses


    def encode(self, num_impl_states):
        terminals = self._build_terminals()

        init_state_clause = _build_clause(terminals, self._automaton.initial_sets_list)
        init_state_assertions_str = self._make_initial_states_condition(self._get_smt_name(init_state_clause))

        sys_states = list(map(lambda x: 't_' + str(x), range(0, num_impl_states)))
        transition_assertions_str, spec_state_clauses = self._make_transition_assertions(terminals, sys_states)

        spec_state_clauses_names = [self._get_smt_name(c) for c in spec_state_clauses]
        spec_states_declarations_str = self._make_state_declarations(spec_state_clauses_names, "Q")

        query_blocks = [
            self._make_headers(),
            self._make_set_logic(),
            spec_states_declarations_str,
            self._make_state_declarations(sys_states, "T"),
            self._make_input_declarations(),
            self._make_func_declarations(num_impl_states),
            init_state_assertions_str,
            transition_assertions_str,
            self.CHECK_SAT,
            self._make_get_values(num_impl_states),
            self.EXIT_CALL
            ]

        query_str = '\n\n'.join(query_blocks)

        self._logger.debug(query_str)

        print()
        print()
        clause_automaton = Automaton([{self._get_create_node(init_state_clause)}], [], set(self._my_nodes.values()))
        print('clause automaton: \n' + to_dot(clause_automaton))
        print()
        print('(raw format) clause automaton: \n' + str(clause_automaton))
        print()
        print()
        for k,v in self._my_nodes.items():
            print('{0}:   {1}'.format(k,v.name))
        print()
        print()

        return query_str


    def _true(self):
        return ' true '
    def _false(self):
        return ' false '


    def _is_rejecting_clause(self, spec_state_clause, term_clauses):
        states = _get_spec_states_of_clause(spec_state_clause, term_clauses)

        subst_map = {}
        for state in states:
            subst_map[term_clauses[state]] = TRUE if state not in self._automaton._rejecting_nodes else FALSE

        is_accepting = spec_state_clause.subs(subst_map)

        assert is_accepting == FALSE or is_accepting == TRUE

        return is_accepting == FALSE


    def _counter_greater(self,
                         next_spec_state_clause, next_sys_state,
                         spec_state_clause, sys_state,
                         term_clauses):

        next_counter = self._counter(self._get_smt_name(next_spec_state_clause), next_sys_state)
        crt_counter = self._counter(self._get_smt_name(spec_state_clause), sys_state)

        greater_func = [self._ge, self._gt][self._is_rejecting_clause(next_spec_state_clause, term_clauses)]
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


    def _get_smt_name(self, spec_state_clause):
        assert spec_state_clause != TRUE and spec_state_clause != FALSE

        s = str(spec_state_clause)
        s = 'q_' + s.replace(' ', '').replace('+', '_or_').replace('*', '_and_').replace('(', '_').replace(')', '_')
        return s


    def _get_next_spec_state_clause(self,
                                    signal_values,
                                    spec_state_clause,
                                    term_clauses):
        # each state is replaced by true/false/next_spec_state_by_automaton
        # then the formula is evaluated:
        # return true/false/next_spec_state_clause

        states = _get_spec_states_of_clause(spec_state_clause, term_clauses)

        if '17' in str(spec_state_clause):
            print('_get_next_spec_state_clause: {0} contains {2} (under {1})'.format(spec_state_clause, signal_values, states))
            for s in states:
                print(':: {0}'.format(str(s)))

        subst_map = {}
        for state in states:
            list_of_next_state_sets = get_next_states(state, signal_values)
            next_state_clause = _build_clause(term_clauses, list_of_next_state_sets)
            if '17' in state.name:
                print('.. next states of 17 is {0} and the clause is {1}'.format(list_of_next_state_sets, next_state_clause))
            subst_map[term_clauses[state]] = next_state_clause

        next_clause = spec_state_clause.subs(subst_map)

        next_normalized_or_clauses = normalize(OR, next_clause)

        if len(next_normalized_or_clauses) > 1:
            return OR(*next_normalized_or_clauses)

        return next_normalized_or_clauses[0]


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
        return sum(map(lambda l: satisfied(l, var_values), labels)) == 0


    def get_relevant_edges(self, var_values, spec_state):
        """ Return dst_sets_list """
        relevant_edges = []

        for label, dst_set_list in spec_state.transitions.items():
            if not satisfied(label, var_values):
                continue #consider only edges with labels that are satisfied by current signal values

            relevant_edges.extend(dst_set_list)

        return relevant_edges



