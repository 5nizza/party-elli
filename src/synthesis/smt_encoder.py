import itertools
import logging
from helpers.boolean import AND, OR, Symbol, normalize, FALSE, TRUE
from helpers.logging import log_entrance
from helpers.ordered_set import OrderedSet
from interfaces.automata import get_next_states, satisfied, Node, Automaton, to_dot, enumerate_values, is_forbidden_label_values, get_relevant_edges, DEAD_END
from itertools import chain


def _get_spec_states_of_clause(spec_state_clause, terminals):
    symbols = spec_state_clause.symbols
    symbol_to_state = dict([(x[1],x[0]) for x in terminals.items()])
    states = set(map(lambda s: symbol_to_state[s], symbols))
    return states


def _build_clause(term_clauses, list_of_state_sets):
    if len(list_of_state_sets) is 0:
        return FALSE

    ors = []
    for state_set in list_of_state_sets:
        if len(state_set) > 1:
            and_args = list(map(lambda s: term_clauses[s], state_set))
            ors.append(AND(*and_args))
        else:
            state = list(state_set)[0]
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
        self._inputs = inputs
        self._outputs = outputs
        self._logic = logic
        self._logger = logging.getLogger(__name__)


    def _lambdaB(self, spec_state, sys_state_expression):
        return self._func("lambda_B", [self._get_smt_name_spec_state(spec_state), sys_state_expression])

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
        for input_var in self._inputs:
            for value in [False, True]:
                smt_str += self._declare_bool_const(self.get_valued_var_name(input_var, value), value)

        smt_str += '\n'
        return smt_str


    def _make_func_declarations(self, nof_impl_states):
        smt_str = self._comment("Declarations of transition relation, output function and annotation")
        smt_str += self._declare_fun("tau", ["T"] + ['Bool'] * len(self._inputs), "T")

        for output in self._outputs:
            smt_str += self._declare_fun("fo_" + output, ["T"], "Bool")

        smt_str += self._declare_fun("lambda_B", ["Q", "T"], "Bool")
        smt_str += self._declare_fun("lambda_sharp", ["Q", "T"], self._logic.counters_type(4))
        smt_str += '\n'

        return smt_str


    def _make_initial_states_condition(self, initial_spec_state_name):
        return self._assert(self._func("lambda_B", [initial_spec_state_name, "t_0"]))


    def _condition_on_output(self, label, sys_state):
        and_args = []
        for var in self._outputs:
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
        for input_var in self._inputs:
            if input_var in label:
                input_values[input_var] = label[input_var]

        return input_values


    def _is_end_node(self, spec_state):
        return spec_state.name == '' #TODO: dirty hack!


    def _map_spec_states_to_smt_names(self, spec_states):
        return map(self._get_smt_name_spec_state, spec_states)


    def _convert_state_clause_to_lambdaB_stmt(self,
                                         spec_state_clause,
                                         sys_state,
                                         term_clauses):
        if (str(spec_state_clause)) == '0':
            assert spec_state_clause == FALSE

        if spec_state_clause == TRUE:
            guarantee = self._true()
        elif spec_state_clause == FALSE:
            guarantee = self._false()
        else:
            def convert_and_to_lambdaB(and_clause):
                clause_to_state = dict(map(lambda item: (item[1], item[0]), term_clauses.items()))
                and_state_names = map(lambda l: self._get_smt_name_spec_state(clause_to_state[l]), and_clause.literals)
                ands = list(map(lambda name: self._lambdaB(name, sys_state), and_state_names))
                assert len(ands) > 0
                return self._and(ands)

            ors = list(map(convert_and_to_lambdaB, normalize(OR, spec_state_clause)))
            assert len(ors) > 0
            guarantee = self._or(ors)

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


    def _make_trans_condition_on_output_vars(self, label, sys_state):
        and_args = []
        for var in self._outputs:
            if (var in label) and (label[var] is True):
                and_args.append(self._func("fo_" + var, [sys_state]))
            elif (var in label) and (label[var] is False):
                and_args.append(self._not(self._func("fo_" + var, [sys_state])))
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


    def _make_state_transition_assertions(self, sys_states):
        assertions = []

        for spec_state in self._automaton.nodes:
            for label, dst_set_list in spec_state.transitions.items():
                if not len(list(itertools.chain(*dst_set_list))): #TODO: why?
                    continue

                for sys_state in sys_states:
                    implication_left_1 = self._lambdaB(spec_state, sys_state)
                    implication_left_2 = self._make_trans_condition_on_output_vars(label, sys_state)

                    if len(implication_left_2) > 0:
                        implication_left = self._and([implication_left_1, implication_left_2])
                    else:
                        implication_left = implication_left_1

                    input_values = {}
                    for input_var in self._inputs:
                        if input_var in label:
                            input_values[input_var] = label[input_var]

                    tau_args, free_input_vars = self._make_tau_arg_list(input_values)
                    sys_next_state = self._tau(sys_state, tau_args)

                    or_args = []
                    for dst_set in dst_set_list:
                        and_args = []
                        for spec_next_state, is_rejecting in dst_set:
                            if spec_next_state is DEAD_END:
                                implication_right = self._false()
                            else:
                                implication_right_1 = self._lambdaB(spec_next_state, sys_next_state)

                                crt_sharp = self._func("lambda_sharp", ["q_" + spec_state.name, sys_state])
                                next_sharp = self._func("lambda_sharp", ["q_" + spec_next_state.name, sys_next_state])
                                greater = [self._ge, self._gt][is_rejecting]
                                implication_right_2 = greater(next_sharp, crt_sharp)

                                implication_right = self._and([implication_right_1, implication_right_2])

                            and_args.append(implication_right)

                        or_args.append(self._and(and_args))

                    smt_addition = self._assert(self._implies(implication_left,
                                                              self._forall(free_input_vars, self._or(or_args))))

                    assertions.append(smt_addition)

        return assertions


    def _make_set_logic(self):
        return ';(set-logic {0})\n'.format(self._logic.smt_name)


    def _make_headers(self):
        return '(set-option :produce-models true)\n'


    def _make_get_values(self, num_impl_states):
        smt_str = ''
        for s in range(0, num_impl_states):
            for input_values in enumerate_values(self._inputs):
                smt_str += "(get-value ({0}))\n".format(self._func("tau", ['t_'+str(s)] + self._make_tau_arg_list(input_values)[0]))
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


    def _build_terminal_clauses(self):
        term_clauses = dict([(s, Symbol(s.name)) for s in self._automaton.nodes if s.name != ''])
        true_states = list(filter(lambda x: x.name == '', self._automaton.nodes))

        if true_states is not None and len(true_states) == 1:
            term_clauses[true_states[0]] = TRUE

        return term_clauses


    @log_entrance(logging.getLogger(), logging.INFO)
    def encode(self, num_impl_states):
        assert len(self._automaton.initial_sets_list) == 1, 'universal init state is not supported'
        assert len(self._automaton.initial_sets_list[0]) == 1

        init_spec_state = list(self._automaton.initial_sets_list[0])[0]
        sys_states = ['t_'+str(i) for i in range(num_impl_states)]

        smt_lines = [self._make_headers(),
                     self._make_set_logic(),
                     self._make_state_declarations(map(self._get_smt_name_spec_state, self._automaton.nodes),
                         "Q"),
                     self._make_state_declarations(map(self._get_smt_name_sys_state, range(num_impl_states)),
                         "T"),
                     self._make_input_declarations(),
                     self._make_func_declarations(2),
                     self._make_initial_states_condition(self._get_smt_name_spec_state(init_spec_state)),

                     '\n'.join(self._make_state_transition_assertions(sys_states)),

                     self.CHECK_SAT,
                     self._make_get_values(num_impl_states),
                     self.EXIT_CALL]

        smt_query = '\n'.join(smt_lines)

        self._logger.debug(smt_query)

        return smt_query


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


    def _get_smt_name_spec_state(self, spec_state):
        return 'q_' + spec_state.name


    def _get_smt_name_sys_state(self, sys_state):
        return 't_' + str(sys_state)


    def _make_tau_arg_list(self, input_values): #TODO: use ?var_name instead of var_name in forall
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



