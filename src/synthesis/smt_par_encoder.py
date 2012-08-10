from collections import Iterable
from itertools import product, chain
import logging
import math

from helpers.logging import log_entrance
from helpers.python_ext import SmarterList, bin_fixed_list, index
from interfaces.automata import enumerate_values, DEAD_END
from parsing.en_rings_parser import concretize, parametrize
from synthesis.rejecting_states_finder import build_state_to_rejecting_scc
from synthesis.smt_helper import *

def _make_init_states_condition(init_spec_state_name, init_sys_state_name):
    return make_assert(call_func("lambda_B", [init_spec_state_name, init_sys_state_name]))


def _lambdaB(spec_state_name, sys_state_expression):
    return call_func("lambda_B", [spec_state_name, sys_state_expression])


def _counter(spec_state_name, sys_state_name):
    return call_func("lambda_sharp", [spec_state_name, sys_state_name])


def _tau(sys_state_name, args):
    return call_func("tau", [sys_state_name] + args)



class ParEncoder:
    def __init__(self, logic,
                 nof_processes,
                 sched_id_prefix,
                 active_var_prefix,
                 sends_var_prefix,
                 automaton,
                 par_inputs,
                 par_outputs):
        assert len(automaton.initial_sets_list) == 1, 'nondet initial state is not supported'
        assert len(par_outputs) > 0

        self._logic = logic
        self._logger = logging.getLogger(__name__)

        self._nof_processes = nof_processes
        self._nof_bits = int(math.ceil(math.log(nof_processes, 2)))

        self._active_var_prefix = active_var_prefix
        self._sends_var_prefix = sends_var_prefix
        self._sends_name = get_output_name(self._sends_var_prefix)

        self._sched_id_prefix = sched_id_prefix
        self._automaton = automaton
        self._inputs = list(filter(lambda i: sends_var_prefix not in i, par_inputs)) #special treatment of sends_prev
        self._outputs = par_outputs


    def _condition_on_output(self, outputs, label, sys_state):
        and_args = []
        for var in outputs:
            if (var in label) and (label[var] is True):
                and_args.append(call_func("fo_" + var, [sys_state])) #TODO: get rid off fo_
            elif (var in label) and (label[var] is False):
                and_args.append(op_not(call_func("fo_" + var, [sys_state])))
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


    def _make_trans_condition_on_output_vars(self, label, sys_state_vector, outputs):
        and_args = []
        for var_name_concrete, value in label.items():
            if len(sys_state_vector) == 1:
                var_name, proc_index = var_name_concrete, 0
            else:
                var_name, proc_index = parametrize(var_name_concrete)

            if var_name not in outputs:
                continue

            state = sys_state_vector[proc_index]
            state_name = self._get_smt_name_sys_state([state])

            out_condition = call_func(get_output_name(var_name), [state_name])
            if not label[var_name_concrete]:
                out_condition = op_not(out_condition)

            and_args.append(out_condition)

        return op_and(and_args)


    def _encode_transition(self,
                           spec_state,
                           sys_state_vector,
                           label,
                           state_to_rejecting_scc,
                           tau_name,
                           is_active_func_name,
                           equals_bits_name):

        spec_state_name = self._get_smt_name_spec_state(spec_state)

        assume_lambdaB = _lambdaB(spec_state_name, self._get_smt_name_sys_state(sys_state_vector))

        assume_out = self._make_trans_condition_on_output_vars(label, sys_state_vector, self._outputs)

        assume_is_active = self._make_assume_is_active(label,
            self._get_sched_values(label),
            is_active_func_name,
            sys_state_vector)

        implication_left = op_and([assume_lambdaB]+[assume_out] +[assume_is_active])

        sys_next_state = [call_func(tau_name,
                                    self._make_tau_arg_list(sys_state_vector, label, proc_index, equals_bits_name))
                          for proc_index in range(self._nof_processes)]

#        print()
#        print('label', label)
#        print('inputs', inputs)
#        print('all_free_vars', all_free_vars)

        sys_next_state_name = ' '.join(sys_next_state)

        dst_set_list = spec_state.transitions[label]
        assert len(dst_set_list) == 1, 'nondet. transitions are not supported'
        dst_set = dst_set_list[0]

        and_args = []
        for spec_next_state, is_rejecting in dst_set:
            if spec_next_state is DEAD_END:
                implication_right = false()
            else:
                implication_right_lambdaB = _lambdaB(self._get_smt_name_spec_state(spec_next_state),
                    sys_next_state_name)
                implication_right_counter = self._get_implication_right_counter(spec_state, spec_next_state,
                    is_rejecting,
                    self._get_smt_name_sys_state(sys_state_vector),
                    sys_next_state_name,
                    state_to_rejecting_scc)

                if implication_right_counter is None:
                    implication_right = implication_right_lambdaB
                else:
                    implication_right = op_and([implication_right_lambdaB, implication_right_counter])

            and_args.append(implication_right)

        #TODO: forall is evil!
        free_input_vars = self._get_free_vars(label)
        return make_assert(op_implies(implication_left, forall_bool(free_input_vars, op_and(and_args))))


    def _define_tau_sched_wrapper(self, name, tau_name, is_active_name, state_type):
        input_def_args = ' '.join(map(lambda i: '(in{0} Bool)'.format(i), range(len(self._inputs))))
        input_call_args = ' '.join(map(lambda i: 'in'+str(i), range(len(self._inputs))))

        _, sched_args_def, sched_args_call = get_bits_definition('sched', self._nof_bits)
        _, proc_args_def, proc_args_call = get_bits_definition('proc', self._nof_bits)

        return """
(define-fun {tau_wrapper} ((state {state}) {inputs_def} {sched_def} {proc_def} (sends_prev Bool)) {state}
    (ite ({is_active} {sched} {proc} sends_prev) ({tau} state {inputs_call} sends_prev) state)
)
        """.format_map({'tau_wrapper':name,
                        'tau': tau_name,
                        'sched_def': sched_args_def,
                        'proc_def': proc_args_def,
                        'sched': sched_args_call,
                        'proc': proc_args_call,
                        'inputs_call':input_call_args,
                        'inputs_def':input_def_args,
                        'state':state_type,
                        'is_active': is_active_name})


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

#    def _define_vector_function(self, global_tau_name, local_tau_name, proj_name, combine_name,
#                                global_state_type, sched_id_type,
#                                nof_processes):
#        new_states = ' '.join(map(lambda i: '({tau} ({proj} vector_state) {proc_id} sched_id)'.format_map(
#                {'tau':local_tau_name,
#                 'proj':proj_name+str(i),
#                 'proc_id':str(i)}),
#            range(nof_processes)))
#
#        return """
#        (define-fun {vector_tau} (vector_state {vector_state} sched_id {sched_id}) {vector_state}
#        ({combine} {new_states})
#        )
#        """.format_map({'vector_tau':global_tau_name,
#                        'vector_state': global_state_type,
#                        'sched_id':sched_id_type,
#                        'new_states':new_states,
#                        'combine':combine_name})

#    def _define_sends_prev(self, sends_prev_name, sends_name, nof_processes): #TODO: hardcode
#        smt = """
#(define-fun {name} ((proc_id Int)) Bool
#(
# (ite (= proc_id 0) ({sends} {max_proc_id})
#                    ({sends} (- proc_id 1))
# )
#)
#        """.format_map({'name': sends_prev_name,
#                        'sends': sends_name,
#                        'max_proc_id': })
#        return smt

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
    def encode_parametrized(self, nof_local_states):

        assert nof_local_states > 1, 'initial token distribution requires > 1 local states'

        smt_lines = SmarterList()

        smt_lines += [make_headers(),
                     make_set_logic(self._logic)]

        spec_state_type = 'Q'
        smt_lines += declare_enum(spec_state_type, [self._get_smt_name_spec_state(node)
                                                    for node in self._automaton.nodes])

        local_states_type = 'LS'
        smt_lines += declare_enum(local_states_type, [self._get_smt_name_sys_state([i])
                                                       for i in range(nof_local_states)])

        smt_lines += declare_fun('lambda_B', [spec_state_type]+[local_states_type]*self._nof_processes,
            'Bool')

        smt_lines += declare_fun('lambda_sharp', [spec_state_type]+[local_states_type]*self._nof_processes,
            self._logic.counters_type(4))

        equal_bits_name = 'equal_bits'
        smt_lines += self._define_equal_bools(equal_bits_name)

        equal_to_prev_name = 'equal_to_prev'
        smt_lines += self._define_equal_to_prev(equal_to_prev_name, equal_bits_name)

        is_active_name = 'is_active'
        smt_lines += self._define_is_active(is_active_name, equal_bits_name, equal_to_prev_name)

        tau_name = 'local_tau'
        smt_lines += declare_fun(tau_name,
            [local_states_type] + ['Bool']*(len(self._inputs)+1),
            local_states_type)

        tau_sched_wrapper_name = tau_name + '_wrapper'
        sched_wrapper_def = self._define_tau_sched_wrapper(tau_sched_wrapper_name,
            tau_name,
            is_active_name,
            local_states_type)
        smt_lines += [sched_wrapper_def]

        smt_lines += list(map(lambda o: declare_output(o, local_states_type), self._outputs))

        init_sys_state = [1] + [0]*(self._nof_processes-1)
        for init_state in chain(*self._automaton.initial_sets_list):
            smt_lines += _make_init_states_condition(self._get_smt_name_spec_state(init_state),
                self._get_smt_name_sys_state(init_sys_state))

        global_states = list(product(*[range(nof_local_states)]*self._nof_processes))

        state_to_rejecting_scc = build_state_to_rejecting_scc(self._automaton)

        spec_states = self._automaton.nodes
        for global_state in global_states:
            for spec_state in spec_states:
                for label, dst_set_list in spec_state.transitions.items():
                    smt_lines += self._encode_transition(spec_state,
                        global_state,
                        label,
                        state_to_rejecting_scc,
                        tau_sched_wrapper_name,
                        is_active_name,
                        equal_bits_name)

        smt_lines += make_check_sat()
        smt_lines += make_get_model()
        smt_lines += make_exit()

        return '\n'.join(smt_lines)


    @log_entrance(logging.getLogger(), logging.INFO)
    def encode(self, automaton, inputs, outputs, nof_sys_states):
        assert len(automaton.initial_sets_list) == 1, 'universal init state is not supported'
        assert len(automaton.initial_sets_list[0]) == 1

        init_spec_state = list(automaton.initial_sets_list[0])[0]
        sys_states = [[i] for i in range(nof_sys_states)]
        init_sys_state = [0]

        smt_lines = [make_headers(),
                     make_set_logic(self._logic),

                     declare_enum("Q", map(self._get_smt_name_spec_state, automaton.nodes)),
                     declare_enum("T", map(lambda s: self._get_smt_name_sys_state(s), chain(sys_states))),

                     declare_inputs(inputs),
                     declare_outputs(outputs, 'T'),
                     declare_fun("tau", ['T'] + ['Bool'] * len(inputs), 'T'),
                     declare_counters(self._logic, 'T', 'Q'),

                     _make_init_states_condition(self._get_smt_name_spec_state(init_spec_state),
                                                 self._get_smt_name_sys_state(init_sys_state)),

                     '\n'.join(self._make_state_transition_assertions(automaton, inputs, outputs,
                         sys_states, 'tau')),

                     make_check_sat(),
                     self._make_get_values(inputs, outputs, nof_sys_states),
                     make_exit()]

        smt_query = '\n'.join(smt_lines)

        self._logger.debug(smt_query)

        return smt_query


    def _get_smt_name_spec_state(self, spec_state):
        return 'q_' + spec_state.name


    def _get_smt_name_sys_state(self, sys_state_vector):
        return  ' '.join(map(lambda s: 't_' + str(s), sys_state_vector))


    def _make_tau_arg_list(self,
                           sys_state_vector,
                           label,
                           proc_index,
                           equals_bits_name):
        """ Return tuple (list of tau args(in correct order), free vars):
            free variables (to be enumerated) called ?var_name.
        """

        tau_args = [self._get_smt_name_sys_state([sys_state_vector[proc_index]])]

        for concr_var_name in concretize(self._inputs, proc_index):
            if concr_var_name in label:
                tau_args.append(str(label[concr_var_name]).lower())
            else:
                _, proc_index_of_var = parametrize(concr_var_name)
                if proc_index_of_var == proc_index: #label may contain variables due to a different process
                    value = '?{0}'.format(concr_var_name)
                    tau_args.append(value)

        sched_values = self._get_sched_values(label)
        tau_args += sched_values

#        print(label)
#        print('proc_index', proc_index)
#        print('before updating proc', tau_args)
#        print('before updating', free_vars)

        tau_args += list(map(lambda b: str(b).lower(), bin_fixed_list(proc_index, self._nof_bits)))


        prev_proc = (proc_index - 1) % self._nof_processes
        prev_proc_id_values = list(map(lambda b: str(b).lower(), bin_fixed_list(prev_proc, self._nof_bits)))
        sched_prev = call_func(equals_bits_name, sched_values+prev_proc_id_values)

        sends_prev = self._get_sends_prev_expr(proc_index, sys_state_vector)
        modified_sends_prev = op_and([sends_prev, sched_prev])

        print(modified_sends_prev)

        tau_args += [modified_sends_prev]
#        print('after updating', tau_args)
#        print('after updating', free_vars)
#        print()

        return tau_args


    def _get_implication_right_counter(self, spec_state, next_spec_state,
                                       is_rejecting,
                                       sys_state_name, next_sys_state_name,
                                       state_to_rejecting_scc):

        crt_rejecting_scc = state_to_rejecting_scc.get(spec_state, None)
        next_rejecting_scc = state_to_rejecting_scc.get(next_spec_state, None)

        if crt_rejecting_scc is not next_rejecting_scc:
            return None
        if crt_rejecting_scc is None:
            return None
        if next_rejecting_scc is None:
            return None

        crt_sharp = _counter(self._get_smt_name_spec_state(spec_state), sys_state_name)
        next_sharp = _counter(self._get_smt_name_spec_state(next_spec_state), next_sys_state_name)
        greater = [ge, gt][is_rejecting]

        return greater(next_sharp, crt_sharp, self._logic)


    def _make_get_values(self, inputs, outputs, num_impl_states):
        return '' #TODO
#        smt_lines = []
#        for s in range(num_impl_states):
#            for input_values in enumerate_values(inputs):
#                smt_lines.append(
#                    get_value(_tau(self._get_smt_name_sys_state(s),
#                                        self._make_tau_arg_list(input_values, inputs)[0])))
#
#        for s in range(num_impl_states):
#            smt_lines.append(
#                get_value(self._get_smt_name_sys_state(s)))
#
#        for output in outputs:
#            for s in range(num_impl_states):
#                smt_lines.append(
#                    get_value(func('fo_'+str(output), [self._get_smt_name_sys_state(s)])))
#
#        return '\n'.join(smt_lines)


    def _define_equal_bools(self, equal_bits_name):
        first_args, first_args_def, first_args_call = get_bits_definition('x', self._nof_bits)
        second_args, second_args_def, second_args_call = get_bits_definition('y', self._nof_bits)

        cmp_stmnt = op_and(map(lambda p: '(= {0} {1})'.format(p[0],p[1]), zip(first_args, second_args)))


        smt = """
(define-fun {equal_bits} ({first_def} {second_def}) Bool
  {cmp}
)
        """.format_map({'first_def': first_args_def,
                        'second_def': second_args_def,
                        'cmp': cmp_stmnt,
                        'equal_bits': equal_bits_name
                        })

        return smt


    def _define_is_active(self, is_active_name,
                          equal_bools_func_name, equal_to_prev_id_func_name):
        _, proc_id_args_def, proc_id_args_call = get_bits_definition('proc', self._nof_bits)
        _, sched_id_args_def, sched_id_args_call = get_bits_definition('sched', self._nof_bits)

        smt = """
(define-fun {is_active} ({sched_id_def} {proc_id_def} (sends_prev Bool)) Bool
    (or ({equal_bools} {sched_id} {proc_id}) (and sends_prev ({equal_prev} {sched_id} {proc_id})))
)
        """.format_map({'is_active': is_active_name,
                        'equal_bools':equal_bools_func_name,
                        'equal_prev': equal_to_prev_id_func_name,
                        'proc_id_def': proc_id_args_def,
                        'sched_id_def': sched_id_args_def,
                        'proc_id': proc_id_args_call,
                        'sched_id': sched_id_args_call
                        })

        return smt


    def _ring_modulo_iterate(self, nof_processes, function):
        nof_bits = math.ceil(math.log(nof_processes, 2))

        def to_smt_bools(int_val):
            return ' '.join(map(lambda b: str(b), bin_fixed_list(int_val, nof_bits))).lower()

        for crt in range(nof_processes):
            crt_str = to_smt_bools(crt)
            crt_prev_str = to_smt_bools((crt-1) % nof_processes)
            function(crt_prev_str, crt_str)


    def _define_equal_to_prev(self, equal_to_prev_name, equals_name): #TODO: optimize
        _, sched_args_def, sched_args_call = get_bits_definition('sch', self._nof_bits)
        _, proc_args_def, proc_args_call = get_bits_definition('proc', self._nof_bits)

        enum_clauses = []
        def accumulator(prev_str, crt_str):
            enum_clauses.append('(and ({equals} {proc} {crt}) ({equals} {sched} {crt_prev}))'
                                .format_map({'equals': equals_name,
                                             'sched': sched_args_call,
                                             'proc': proc_args_call,
                                             'crt':crt_str,
                                             'crt_prev': prev_str}))


        self._ring_modulo_iterate(self._nof_processes, accumulator)

        smt = """
(define-fun {equal_to_prev} ({sched_def} {proc_def}) Bool
(or {enum_clauses})
)
        """.format_map({'equal_to_prev': equal_to_prev_name,
                        'sched_def': sched_args_def,
                        'proc_def': proc_args_def,
                        'enum_clauses': '\n   '.join(enum_clauses)})

        return smt


    def _get_sends_prev_expr(self, proc_index, sys_states_vector):
        prev_proc = (proc_index-1) % self._nof_processes

        prev_proc_state = sys_states_vector[prev_proc]

        return '({sends} {state})'.format_map({'sends': self._sends_name,
                                               'state': self._get_smt_name_sys_state([prev_proc_state])})


    def _define_sends_prev(self, sends_prev_name, sends_name, equals_name):
        _, proc_args_def, proc_args_call = get_bits_definition('proc', self._nof_bits)

        selector_clauses = []
        def accumulator(prev_str, crt_str):
            selector_clauses.append('(=> ({equals} {proc} {crt}) ({sends} {prev}))'
                                    .format_map({'equals': equals_name,
                                                 'proc': proc_args_call,
                                                 'crt':crt_str,
                                                 'sends': sends_name,
                                                 'prev': prev_str}))

        self._ring_modulo_iterate(self._nof_processes, accumulator)

        smt = """
(define-fun {sends_prev} ({proc_def}) Bool
  {selector_clauses}
)
        """.format_map({'sends_prev': sends_prev_name,
                        'proc_def': proc_args_def,
                        'selector_clauses': op_and(selector_clauses)})

        return smt


    def _make_assume_is_active(self, label, sched_vals, is_active_func_name, sys_states_vector):
        var_names = list(label.keys())

        active_var_index = index(lambda concr_var_name: self._active_var_prefix in concr_var_name,
                                 var_names)

        if active_var_index is None:
            return ''

        concr_active_variable = var_names[active_var_index]
        _, proc_index = parametrize(concr_active_variable)

        proc_id_args = list(map(lambda b: str(b).lower(), bin_fixed_list(proc_index, self._nof_bits)))

        sends_prev = self._get_sends_prev_expr(proc_index, sys_states_vector)

        return call_func(is_active_func_name, proc_id_args + sched_vals + [sends_prev])


    def _get_sched_values(self, label):
        sched_vars = list(map(lambda i: '{0}{1}'.format(self._sched_id_prefix, i), range(self._nof_bits)))
        sched_values = []
        for sched_var_name in sched_vars:
            if sched_var_name in label:
                sched_value = str(label[sched_var_name]).lower()
                sched_values.append(sched_value)
            else:
                sched_value = '?{0}'.format(sched_var_name)
                sched_values.append(sched_value)

        return sched_values


    def _get_free_vars(self, label):
        free_vars = []

        for proc_index in range(self._nof_processes):
            for concr_var_name in concretize(self._inputs, proc_index):
                if concr_var_name not in label:
                    value = '?{0}'.format(concr_var_name)
                    free_vars.append(value)

        sched_vars = list(map(lambda i: '{0}{1}'.format(self._sched_id_prefix, i), range(self._nof_bits)))
        for sched_var_name in sched_vars:
            if sched_var_name not in label:
                free_vars.append('?{0}'.format(sched_var_name))

        return free_vars











