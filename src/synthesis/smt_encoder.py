import itertools
import logging

from helpers.boolean import AND, OR, Symbol, normalize, FALSE, TRUE
from helpers.logging import log_entrance
from interfaces.automata import  Node, enumerate_values, DEAD_END
from synthesis.rejecting_states_finder import  build_state_to_rejecting_scc
from synthesis.smt_helper import *


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
    def __init__(self, automaton, inputs, outputs, logic):
        self._automaton = automaton
        self._inputs = inputs
        self._outputs = outputs
        self._logic = logic
        self._logger = logging.getLogger(__name__)


    def _lambdaB(self, spec_state, sys_state_expression):
        return func("lambda_B", [self._get_smt_name_spec_state(spec_state), sys_state_expression])

    def _counter(self, spec_state_name, sys_state_expression):
        return func("lambda_sharp", [spec_state_name, sys_state_expression])


    def _tau(self, sys_state, args_str):
        return func("tau", [sys_state] + args_str)


    def _make_initial_states_condition(self, initial_spec_state_name):
        return make_assert(func("lambda_B", [initial_spec_state_name, "t_0"]))


    def _condition_on_output(self, label, sys_state):
        and_args = []
        for var in self._outputs:
            if (var in label) and (label[var] is True):
                and_args.append(func("fo_" + var, [sys_state])) #TODO: get rid off fo_
            elif (var in label) and (label[var] is False):
                and_args.append(op_not(func("fo_" + var, [sys_state])))
            elif var not in label:
                pass
            else:
                assert False, "Error: wrong variable value: " + label[var]

        smt_str = ' '
        if len(and_args) > 1:
            smt_str = op_and(and_args)
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
            guarantee = true()
        elif spec_state_clause == FALSE:
            guarantee = false()
        else:
            def convert_and_to_lambdaB(and_clause):
                clause_to_state = dict(map(lambda item: (item[1], item[0]), term_clauses.items()))
                and_state_names = map(lambda l: self._get_smt_name_spec_state(clause_to_state[l]), and_clause.literals)
                ands = list(map(lambda name: self._lambdaB(name, sys_state), and_state_names))
                assert len(ands) > 0
                return op_and(ands)

            ors = list(map(convert_and_to_lambdaB, normalize(OR, spec_state_clause)))
            assert len(ors) > 0
            guarantee = op_or(ors)

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
                and_args.append(func("fo_" + var, [sys_state]))
            elif (var in label) and (label[var] is False):
                and_args.append(op_not(func("fo_" + var, [sys_state])))
            elif var not in label:
                pass
            else:
                assert False, "Error: Variable in label has wrong value: " + label[var]

        smt_str = ' '
        if len(and_args) > 1:
            smt_str = op_and(and_args)
        elif len(and_args) == 1:
            smt_str = and_args[0]

        return smt_str


    def _make_state_transition_assertions(self, sys_states):
        assertions = []

        state_to_rejecting_scc = build_state_to_rejecting_scc(self._automaton)

        self._logger.info('number of automaton states requiring counting is %i out of %i',
            len(state_to_rejecting_scc.keys()),
            len(self._automaton.nodes))

        for spec_state in self._automaton.nodes:
            for label, dst_set_list in spec_state.transitions.items():
                if len(list(itertools.chain(*dst_set_list))) == 0: #TODO: why?
                    continue

                for sys_state in sys_states:
                    implication_left_1 = self._lambdaB(spec_state, sys_state)
                    implication_left_2 = self._make_trans_condition_on_output_vars(label, sys_state)

                    if len(implication_left_2) > 0:
                        implication_left = op_and([implication_left_1, implication_left_2])
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
                                implication_right = false()
                            else:
                                implication_right_lambdaB = self._lambdaB(spec_next_state, sys_next_state)
                                implication_right_counter = self._get_implication_right_counter(spec_state, spec_next_state,
                                    is_rejecting,
                                    sys_state, sys_next_state,
                                    state_to_rejecting_scc)

                                if implication_right_counter is None:
                                    implication_right = implication_right_lambdaB
                                else:
                                    implication_right = op_and([implication_right_lambdaB, implication_right_counter])

                            and_args.append(implication_right)

                        or_args.append(op_and(and_args))

                    smt_addition = make_assert(implies(implication_left,
                                                              forall(free_input_vars, op_or(or_args))))

                    assertions.append(smt_addition)

        return assertions


    def _make_get_values(self, num_impl_states):
        smt_str = ''
        for s in range(0, num_impl_states):
            for input_values in enumerate_values(self._inputs):
                smt_str += "(get-value ({0}))\n".format(func("tau", ['t_'+str(s)] + self._make_tau_arg_list(input_values)[0]))
        for s in range(0, num_impl_states):
            smt_str += "(get-value (t_{0}))\n".format(s)

        for output in self._outputs:
            for s in range(0, num_impl_states):
                smt_str += "(get-value ((fo_{0} t_{1})))\n".format(output, s)

        return smt_str


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

        smt_lines = [make_headers(),
                     make_set_logic(self._logic),

                     make_state_declarations(map(self._get_smt_name_spec_state, self._automaton.nodes),
                         "Q"),
                     make_state_declarations(map(self._get_smt_name_sys_state, range(num_impl_states)),
                         "T"),

                     make_input_declarations(self._inputs),
                     make_func_declarations(self._inputs, self._outputs, self._logic),

                     self._make_initial_states_condition(self._get_smt_name_spec_state(init_spec_state)),

                     '\n'.join(self._make_state_transition_assertions(sys_states)),

                     make_check_sat(),
                     self._make_get_values(num_impl_states),
                     make_exit()]

        smt_query = '\n'.join(smt_lines)

        self._logger.debug(smt_query)

        return smt_query


    def _is_rejecting_clause(self, spec_state_clause, term_clauses):
        states = _get_spec_states_of_clause(spec_state_clause, term_clauses)

        subst_map = {}
        for state in states:
            subst_map[term_clauses[state]] = TRUE if state not in self._automaton._rejecting_nodes else FALSE

        is_accepting = spec_state_clause.subs(subst_map)

        assert is_accepting == FALSE or is_accepting == TRUE

        return is_accepting == FALSE


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
                valued_vars.append(get_valued_var_name(var_name, input_values[var_name]))
            else:
                valued_vars.append(var_name)
                free_vars.add(var_name)

        return valued_vars, free_vars


    def _get_implication_right_counter(self, spec_state, next_spec_state,
                                       is_rejecting,
                                       sys_state, next_sys_state,
                                       state_to_rejecting_scc):

        crt_rejecting_scc = state_to_rejecting_scc.get(spec_state, None)
        next_rejecting_scc = state_to_rejecting_scc.get(next_spec_state, None)

        if crt_rejecting_scc is not next_rejecting_scc:
            return None
        if crt_rejecting_scc is None:
            return None
        if next_rejecting_scc is None:
            return None

        crt_sharp = func("lambda_sharp", ["q_" + spec_state.name, sys_state])
        next_sharp = func("lambda_sharp", ["q_" + next_spec_state.name, next_sys_state])
        greater = [ge, gt][is_rejecting]

        return greater(next_sharp, crt_sharp, self._logic)
