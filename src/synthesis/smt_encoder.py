import itertools
import logging

from helpers.logging import log_entrance
from interfaces.automata import enumerate_values, DEAD_END
from synthesis.rejecting_states_finder import build_state_to_rejecting_scc
from synthesis.smt_helper import *


def _make_init_states_condition(init_spec_state_name, init_sys_state_name):
    return make_assert(func("lambda_B", [init_spec_state_name, init_sys_state_name]))


def _lambdaB(spec_state_name, sys_state_expression):
    return func("lambda_B", [spec_state_name, sys_state_expression])


def _counter(spec_state_name, sys_state_expression):
    return func("lambda_sharp", [spec_state_name, sys_state_expression])


def _tau(sys_state, args_str):
    return func("tau", [sys_state] + args_str)



class Encoder:
    def __init__(self, automaton, inputs, outputs, logic):
        self._automaton = automaton
        self._inputs = inputs
        self._outputs = outputs
        self._logic = logic
        self._logger = logging.getLogger(__name__)


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


    def _map_spec_states_to_smt_names(self, spec_states):
        return map(self._get_smt_name_spec_state, spec_states)


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

                for sys_state_name in sys_states:
                    implication_left_1 = _lambdaB(self._get_smt_name_spec_state(spec_state),
                        sys_state_name)
                    implication_left_2 = self._make_trans_condition_on_output_vars(label, sys_state_name)

                    if len(implication_left_2) > 0:
                        implication_left = op_and([implication_left_1, implication_left_2])
                    else:
                        implication_left = implication_left_1

                    input_values = {}
                    for input_var in self._inputs:
                        if input_var in label:
                            input_values[input_var] = label[input_var]

                    tau_args, free_input_vars = self._make_tau_arg_list(input_values)
                    sys_next_state = _tau(sys_state_name, tau_args)

                    or_args = []
                    for dst_set in dst_set_list:
                        and_args = []
                        for spec_next_state, is_rejecting in dst_set:
                            if spec_next_state is DEAD_END:
                                implication_right = false()
                            else:
                                implication_right_lambdaB = _lambdaB(self._get_smt_name_spec_state(spec_next_state),
                                    sys_next_state)
                                implication_right_counter = self._get_implication_right_counter(spec_state, spec_next_state,
                                    is_rejecting,
                                    sys_state_name, sys_next_state,
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


    def encode_parametrized(self, local_specs, global_spec_automaton):
        smt_lines = []

        for local_spec in local_specs:
            smt_lines += [self.encode(local_spec)]

        smt_lines += [self.encode(global_spec_automaton)]

        return '\n'.join(smt_lines)


    @log_entrance(logging.getLogger(), logging.INFO)
    def encode(self, num_impl_states):
        assert len(self._automaton.initial_sets_list) == 1, 'universal init state is not supported'
        assert len(self._automaton.initial_sets_list[0]) == 1

        init_spec_state = list(self._automaton.initial_sets_list[0])[0]
        sys_states = [self._get_smt_name_sys_state(i) for i in range(num_impl_states)]
        init_sys_state = 0

        smt_lines = [make_headers(),
                     make_set_logic(self._logic),

                     make_state_declarations(map(self._get_smt_name_spec_state, self._automaton.nodes),
                         "Q"),
                     make_state_declarations(map(self._get_smt_name_sys_state, range(num_impl_states)),
                         "T"),

                     make_input_declarations(self._inputs),
                     make_func_declarations(self._inputs, self._outputs, self._logic),

                     _make_init_states_condition(self._get_smt_name_spec_state(init_spec_state),
                                                    self._get_smt_name_sys_state(init_sys_state)),

                     '\n'.join(self._make_state_transition_assertions(sys_states)),

                     make_check_sat(),
                     self._make_get_values(num_impl_states),
                     make_exit()]

        smt_query = '\n'.join(smt_lines)

        self._logger.debug(smt_query)

        return smt_query


    def _get_smt_name(self, spec_state_clause):
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

        crt_sharp = func("lambda_sharp", [self._get_smt_name_spec_state(spec_state),
                                          sys_state])
        next_sharp = func("lambda_sharp", [self._get_smt_name_spec_state(next_spec_state),
                                           next_sys_state])
        greater = [ge, gt][is_rejecting]

        return greater(next_sharp, crt_sharp, self._logic)


    def _make_get_values(self, num_impl_states):
        smt_lines = []
        for s in range(num_impl_states):
            for input_values in enumerate_values(self._inputs):
                smt_lines.append(
                    get_value(self._tau(self._get_smt_name_sys_state(s),
                                        self._make_tau_arg_list(input_values)[0])))

        for s in range(num_impl_states):
            smt_lines.append(
                get_value(self._get_smt_name_sys_state(s)))

        for output in self._outputs:
            for s in range(num_impl_states):
                smt_lines.append(
                    get_value(func('fo_'+str(output), [self._get_smt_name_sys_state(s)])))

        return '\n'.join(smt_lines)