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
    def __init__(self, logic):
        self._logic = logic
        self._logger = logging.getLogger(__name__)


    def _condition_on_output(self, outputs, label, sys_state):
        and_args = []
        for var in outputs:
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


    def _make_trans_condition_on_output_vars(self, label, sys_state, outputs):
        and_args = []
        for var in outputs:
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


    def _make_state_transition_assertions(self, automaton, inputs, outputs, sys_states):
        assertions = []

        state_to_rejecting_scc = build_state_to_rejecting_scc(automaton)

        self._logger.info('number of automaton states requiring counting is %i out of %i',
            len(state_to_rejecting_scc.keys()),
            len(automaton.nodes))

        for spec_state in automaton.nodes:
            for label, dst_set_list in spec_state.transitions.items():
                for sys_state_name in sys_states:

                    implication_left_1 = _lambdaB(self._get_smt_name_spec_state(spec_state),
                        sys_state_name)
                    implication_left_2 = self._make_trans_condition_on_output_vars(label,
                        sys_state_name, outputs)

                    if len(implication_left_2) > 0:
                        implication_left = op_and([implication_left_1, implication_left_2])
                    else:
                        implication_left = implication_left_1

                    input_values = {}
                    for input_var in inputs:
                        if input_var in label:
                            input_values[input_var] = label[input_var]

                    tau_args, free_input_vars = self._make_tau_arg_list(input_values, inputs)
                    sys_next_state = _tau(sys_state_name, tau_args)

                    assert len(dst_set_list) == 1, 'alternative transitions are not supported'

                    dst_set = dst_set_list[0]
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

                    smt_addition = make_assert(implies(implication_left,
                                                       forall(free_input_vars, op_and(and_args))))

                    assertions.append(smt_addition)

        return assertions


    def _define_tau_sched_wrapper(self, name, tau_name, state_type, sch_id_type, proc_id_type):
        return """
        (define-fun {tau_wrapper} ((state {state}) (sched_id {sched}) (proc_id {proc}) (sends_prev Bool)) {state}
        (ite (or (= sched_id proc_id) sends_prev) ({tau} state sends_prev) state)
        )
        """.format_map({'tau_wrapper':name,
                        'tau': tau_name,
                        'proc':proc_id_type,
                        'sched':sch_id_type,
                        'state':state_type})


#    def _define_proj_function(self, proj_name, getter, global_ty, local_ty):
#        return """
#        (define-fun {proj} ((global_state {global_ty})) {local_ty}
#        ({getter} global_state)
#        )
#        """.format_map({'proj': proj_name,
#                        'getter': getter,
#                        'global_ty':global_ty,
#                        'local_ty':local_ty})


#    def _define_combine_function(self, combine_name, global_ty, args):
#        args_str = ' '.join(args)
#        return """ (define-fun {combine} ({args}) {global}
#        ()
#        )
#        """.format_map({'args':args_str,
#                        'combine':combine_name,
#                        'global':global_ty})


    def _define_vector_function(self, global_tau_name, local_tau_name, proj_name, combine_name,
                                global_state_type, sched_id_type,
                                nof_processes):
        new_states = ' '.join(map(lambda i: '({tau} ({proj} vector_state) {proc_id} sched_id)'.format_map(
                                                                                    {'tau':local_tau_name,
                                                                                     'proj':proj_name+str(i),
                                                                                     'proc_id':str(i)}),
                                  range(nof_processes)))

        return """
        (define-fun {vector_tau} (vector_state {vector_state} sched_id {sched_id}) {vector_state}
        ({combine} {new_states})
        )
        """.format_map({'vector_tau':global_tau_name,
                        'vector_state': global_state_type,
                        'sched_id':sched_id_type,
                        'new_states':new_states,
                        'combine':combine_name})

    #NOTE
    # there are three cases:
    # 1. properties are local (each refer to one process)
    # 2. properties are not local but they are symmetric
    #    a) symmetric and talks about subset of processes
    #    b)                         ... all the processes
    # aside note1: for EN cases, for (i,i+1) it is enough to check (0,1) in the ring of (0,1,2)
    # but should we check it with different initial token distributions?
    # (which is equivalent to checking (0,1) and (1,2) and (2,0)
    #
    # aside note2: if properties are not symmetric and it is a parametrized case, then it is reduced to case (2)

    #TODO: optimize
    # divide properties into two parts: local and global (intra and inter)
    # for local ones use separate lambda counter

    @log_entrance(logging.getLogger(), logging.INFO)
    def encode_parametrized(self, nof_local_states,
                            inputs_outputs_pairs,
                            global_automaton_spec,
                            sch_id_prefix):

        assert len(inputs_outputs_pairs)
        assert len(nof_local_states)

        smt_lines = [make_headers(),
                     make_set_logic(self._logic)]

        local_states_type = 'LS'
        smt_lines += [declare_enum(local_states_type, [local_states_type + str(i)
                                                            for i in range(nof_local_states)])]

        for inputs, outputs in inputs_outputs_pairs:
            smt_lines += [declare_inputs(inputs)]
            smt_lines += [declare_outputs(outputs)]

        local_tau_name = 'local_tau'
        smt_lines += declare_fun(local_tau_name,
            [local_states_type] + ['Bool']*len(inputs_outputs_pairs[0][0]),
            local_states_type)

        sch_id_type = sch_id_prefix
        nof_processes = len(inputs_outputs_pairs)
        smt_lines += [declare_enum(sch_id_type, [str(i) for i in range(nof_processes)])]

        tau_sched_wrapper_name = local_tau_name + 'wrapper'
        smt_lines += [self._define_tau_sched_wrapper(tau_sched_wrapper_name, local_tau_name,
            local_states_type, sch_id_type, sch_id_type)]

#        global_state_prefix = 'GS'
#        tuple_getter = 'get'
#        global_state_component_types = [local_states_type]*nof_processes
#        smt_lines += [declare_tuple(global_state_prefix, global_state_component_types, tuple_getter)]
#        global_state_type = tuple_type(global_state_prefix, global_state_component_types)

#        proj_prefix = 'proj'
#        smt_lines += [self._define_proj_function(proj_prefix+str(i),
#                                                 'get'+str(i),
#                                                 global_state_type,
#                                                 local_states_type)
#                      for i in range(nof_processes)]

#        combine_name = 'combine'
#        smt_lines += [self._define_combine_function(combine_name)]

#        global_tau_name = 'global_tau'
#        smt_lines += [self._define_vector_function(global_tau_name, local_tau_name,
#            proj_prefix, combine_name, global_state_type, sch_id_type, nof_processes)]

        return '\n'.join(smt_lines)


    @log_entrance(logging.getLogger(), logging.INFO)
    def encode(self, automaton, inputs, outputs, nof_sys_states):
        assert len(automaton.initial_sets_list) == 1, 'universal init state is not supported'
        assert len(automaton.initial_sets_list[0]) == 1

        init_spec_state = list(automaton.initial_sets_list[0])[0]
        sys_states = [self._get_smt_name_sys_state(i) for i in range(nof_sys_states)]
        init_sys_state = 0

        smt_lines = [make_headers(),
                     make_set_logic(self._logic),

                     declare_enum("Q", map(self._get_smt_name_spec_state, automaton.nodes)),
                     declare_enum("T", map(self._get_smt_name_sys_state, range(nof_sys_states))),

                     declare_inputs(inputs),
                     declare_outputs(outputs),
                     declare_fun("tau", ['T'] + ['Bool'] * len(inputs), 'T'),
                     declare_counters(self._logic),

                     _make_init_states_condition(self._get_smt_name_spec_state(init_spec_state),
                                                 self._get_smt_name_sys_state(init_sys_state)),

                     '\n'.join(self._make_state_transition_assertions(automaton, inputs, outputs,
                         sys_states)),

                     make_check_sat(),
                     self._make_get_values(inputs, outputs, nof_sys_states),
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
        sys_state_vector = sys_state if isinstance(sys_state, list) else [sys_state]
        return ' '.join(map(lambda s: 't_' + str(s), sys_state_vector))


    def _make_tau_arg_list(self, input_values, inputs): #TODO: use ?var_name instead of var_name in forall
        """ Return tuple (list of tau args(in correct order), free vars):
            for variables without values use variable name (you should enumerate them afterwards).
        """

        valued_vars = []
        free_vars = set()
        for var_name in inputs:
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

        crt_sharp = _counter(self._get_smt_name_spec_state(spec_state), sys_state)
        next_sharp = _counter(self._get_smt_name_spec_state(next_spec_state), next_sys_state)
        greater = [ge, gt][is_rejecting]

        return greater(next_sharp, crt_sharp, self._logic)


    def _make_get_values(self, inputs, outputs, num_impl_states):
        smt_lines = []
        for s in range(num_impl_states):
            for input_values in enumerate_values(inputs):
                smt_lines.append(
                    get_value(_tau(self._get_smt_name_sys_state(s),
                                        self._make_tau_arg_list(input_values, inputs)[0])))

        for s in range(num_impl_states):
            smt_lines.append(
                get_value(self._get_smt_name_sys_state(s)))

        for output in outputs:
            for s in range(num_impl_states):
                smt_lines.append(
                    get_value(func('fo_'+str(output), [self._get_smt_name_sys_state(s)])))

        return '\n'.join(smt_lines)

