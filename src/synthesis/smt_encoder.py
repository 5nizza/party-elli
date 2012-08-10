from collections import defaultdict
from itertools import product, chain
import logging
import math

from helpers.logging import log_entrance
from helpers.python_ext import SmarterList, bin_fixed_list, index
from interfaces.automata import  DEAD_END
from interfaces.lts import LTS
from parsing.en_rings_parser import concretize, parametrize
from synthesis.rejecting_states_finder import build_state_to_rejecting_scc
from synthesis.smt_helper import *

def _make_init_states_condition(init_spec_state_name, init_sys_state_name):
    return make_assert(call_func("lambda_B", [init_spec_state_name, init_sys_state_name]))


def _lambdaB(spec_state_name, sys_state_expression):
    return call_func("lambda_B", [spec_state_name, sys_state_expression])


def _counter(spec_state_name, sys_state_name):
    return call_func("lambda_sharp", [spec_state_name, sys_state_name])


class Encoder:
    def __init__(self, logic,
                 automaton,
                 par_inputs,
                 par_outputs):
        assert len(automaton.initial_sets_list) == 1, 'nondet. is not supported'
        assert len(par_outputs) > 0

        self._logic = logic
        self._logger = logging.getLogger(__name__)

        self._automaton = automaton

        self._inputs = par_inputs
        self._outputs = par_outputs


    def _make_trans_condition_on_output_vars(self, label, sys_state, outputs):
        and_args = []
        for var_name, value in label.items():
            if var_name not in outputs:
                continue

            state_name = self._get_smt_name_sys_state(sys_state)

            out_condition = call_func(get_output_name(var_name), [state_name])
            if not label[var_name]:
                out_condition = op_not(out_condition)

            and_args.append(out_condition)

        return op_and(and_args)


    def _encode_transition(self,
                           spec_state,
                           sys_state,
                           label,
                           state_to_rejecting_scc):

        spec_state_name = self._get_smt_name_spec_state(spec_state)

        assume_lambdaB = _lambdaB(spec_state_name, self._get_smt_name_sys_state(sys_state))

        assume_out = self._make_trans_condition_on_output_vars(label, sys_state, self._outputs)

        implication_left = op_and([assume_lambdaB]+[assume_out])

        sys_next_state_name = call_func(self._tau_name, self._make_tau_arg_list(sys_state, label))

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
                    self._get_smt_name_sys_state(sys_state),
                    sys_next_state_name,
                    state_to_rejecting_scc)

                if implication_right_counter is None:
                    implication_right = implication_right_lambdaB
                else:
                    implication_right = op_and([implication_right_lambdaB, implication_right_counter])

            and_args.append(implication_right)

        #TODO: forall is evil!
        free_input_vars = self._get_free_vars(label)
        return make_assert(forall_bool(free_input_vars, op_implies(implication_left, op_and(and_args))))


    def _define_tau_sched_wrapper(self, is_active_name, state_type):
        _, input_args_def, input_args_call = get_bits_definition('in', len(self._orig_inputs))
        _, sched_args_def, sched_args_call = get_bits_definition('sched', self._nof_bits)
        _, proc_args_def, proc_args_call = get_bits_definition('proc', self._nof_bits)

        return """
(define-fun {tau_wrapper} ((state {state}) {inputs_def} (sends_prev Bool) {sched_def} {proc_def}) {state}
    (ite ({is_active} {sched} {proc} sends_prev) ({tau} state {inputs_call} sends_prev) state)
)
        """.format_map({'tau_wrapper':self._tau_sched_wrapper_name,
                        'tau': self._tau_name,
                        'sched_def': sched_args_def,
                        'proc_def': proc_args_def,
                        'sched': sched_args_call,
                        'proc': proc_args_call,
                        'inputs_call':input_args_call,
                        'inputs_def':input_args_def,
                        'state':state_type,
                        'is_active': is_active_name})


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
    def encode(self, nof_states):
        assert nof_states > 1, 'initial token distribution requires at least two states'

        smt_lines = SmarterList()

        smt_lines += [make_headers(),
                     make_set_logic(self._logic)]

        spec_state_type = 'Q'
        smt_lines += declare_enum(spec_state_type, [self._get_smt_name_spec_state(node)
                                                    for node in self._automaton.nodes])

        local_states_type = 'LS'
        smt_lines += declare_enum(local_states_type, [self._get_smt_name_sys_state(i)
                                                       for i in range(nof_states)])

        smt_lines += declare_fun('lambda_B', [spec_state_type]+[local_states_type],
            'Bool')

        smt_lines += declare_fun('lambda_sharp', [spec_state_type]+[local_states_type],
            self._logic.counters_type(4))

#        equal_bits_name = 'equal_bits'
#        smt_lines += self._define_equal_bools(equal_bits_name)
#
#        equal_to_prev_name = 'equal_to_prev'
#        smt_lines += self._define_equal_to_prev(equal_to_prev_name, equal_bits_name)
#
#        is_active_name = 'is_active'
#        smt_lines += self._define_is_active(is_active_name, equal_bits_name, equal_to_prev_name)

        self._tau_name = 'tau'
        smt_lines += declare_fun(self._tau_name,
            [local_states_type] + ['Bool']*(len(self._inputs)),
            local_states_type)

#        self._tau_sched_wrapper_name = self._tau_name + '_wrapper'
#        sched_wrapper_def = self._define_tau_sched_wrapper(is_active_name,
#            local_states_type)
#        smt_lines += [sched_wrapper_def]

        smt_lines += list(map(lambda o: declare_output(o, local_states_type), self._outputs))

        init_sys_state = 0
        for init_state in chain(*self._automaton.initial_sets_list):
            smt_lines += _make_init_states_condition(self._get_smt_name_spec_state(init_state),
                self._get_smt_name_sys_state(init_sys_state))

        global_states = list(range(nof_states))

        state_to_rejecting_scc = build_state_to_rejecting_scc(self._automaton)

        spec_states = self._automaton.nodes
        for global_state in global_states:
            for spec_state in spec_states:
                for label, dst_set_list in spec_state.transitions.items():
                    smt_lines += self._encode_transition(spec_state,
                        global_state,
                        label,
                        state_to_rejecting_scc)

        smt_lines += make_check_sat()
        get_values = self._make_get_values(nof_states)
        smt_lines += get_values
        smt_lines += make_exit()

        return '\n'.join(smt_lines)


    def _get_smt_name_spec_state(self, spec_state):
        return 'q_' + spec_state.name


    def _get_smt_name_sys_state(self, sys_state):
        return  't_' + str(sys_state)


    def _make_tau_arg_list(self,
                           sys_state,
                           label):
        """ Return tuple (list of tau args(in correct order), free vars):
            free variables (to be enumerated) called ?var_name.
        """

        tau_args = [self._get_smt_name_sys_state(sys_state)]

        for var_name in self._inputs:
            if var_name in label:
                tau_args.append(str(label[var_name]).lower())
            else:
                value = '?{0}'.format(var_name)
                tau_args.append(value)

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


    def _make_get_values(self, nof_sys_states):
        smt_lines = SmarterList()

        for s in range(nof_sys_states):
            for raw_values in product([False, True], repeat=len(self._inputs)):
                values = [str(v).lower() for v in raw_values]
                smt_lines += get_value(call_func(self._tau_name, [self._get_smt_name_sys_state(s)] + values))

        for output in self._outputs:
            for s in range(nof_sys_states):
                smt_lines += get_value(call_func(get_output_name(output), [self._get_smt_name_sys_state(s)]))

        return '\n'.join(smt_lines)


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


    #TODO: duplications
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

#        for proc_index in range(self._nof_processes):
        for var_name in self._inputs:
            if var_name not in label:
                value = '?{0}'.format(var_name)
                free_vars.append(value)

#        sched_vars = list(map(lambda i: '{0}{1}'.format(self._sched_id_prefix, i), range(self._nof_bits)))
#        for sched_var_name in sched_vars:
#            if sched_var_name not in label:
#                free_vars.append('?{0}'.format(sched_var_name))

        return free_vars


    def parse_model(self, get_value_lines):
        tau_get_value_lines = list(filter(lambda l: self._tau_name in l, get_value_lines))
        outputs_get_value_lines = list(filter(lambda l: get_output_name('') in l, get_value_lines))

        state_to_input_to_new_state = self._get_tau_model(tau_get_value_lines)
        state_to_outname_to_value = self._get_output_model(outputs_get_value_lines)

        return LTS(state_to_outname_to_value, state_to_input_to_new_state)


    def _get_tau_model(self, tau_lines):
        state_to_input_to_new_state = defaultdict(lambda: defaultdict(lambda: {}))
        for l in tau_lines:
            parts = l.replace("(", "").replace(")", "").replace(self._tau_name, "").strip().split()

            old_state_part = parts[0]
            inputs = tuple(parts[1:-1])
            new_state_part = parts[-1]
            state_to_input_to_new_state[old_state_part][inputs] = new_state_part

        return state_to_input_to_new_state


    def _get_output_model(self, output_lines):
        state_to_outname_to_value = defaultdict(lambda: defaultdict(lambda: {}))
        for l in output_lines:
            parts  = l.replace("(", "").replace(")", "").strip().split()
            assert len(parts) == 3, str(parts)
            outname, state, outvalue = parts
            state_to_outname_to_value[state][outname] = outvalue

        return state_to_outname_to_value