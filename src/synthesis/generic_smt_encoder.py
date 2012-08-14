from collections import defaultdict
from itertools import product, chain
import logging
from helpers.hashable import HashableDict

from helpers.logging import log_entrance
from helpers.python_ext import SmarterList
from interfaces.automata import  DEAD_END
from interfaces.lts import LTS
from synthesis.rejecting_states_finder import build_state_to_rejecting_scc
from synthesis.smt_helper import *


class GenericEncoder:
    def __init__(self, logic, spec_state_prefix, counters_prefix):
        self._logger = logging.getLogger(__name__)

        self._logic = logic

        self._spec_states_type = spec_state_prefix

        self._laB_name = counters_prefix+'laB'
        self._laC_name = counters_prefix+'laC'


    def _get_assumption_on_output_vars(self, label, sys_state_vector, impl):
        and_args = []
        for i in range(impl.nof_processes):
            for var_name, value in label.items():
                if var_name not in impl.outputs[i]:
                    continue

                state_name = self._get_smt_name_sys_state([sys_state_vector[i]], impl.proc_states_descs)

                out_condition = call_func(impl.get_output_func_name(var_name), [state_name]) #TODO: hack
                if not label[var_name]:
                    out_condition = op_not(out_condition)

                and_args.append(out_condition)

        return op_and(and_args)


    def _encode_transition(self,
                           spec_state,
                           sys_state_vector,
                           label,
                           state_to_rejecting_scc,
                           impl):
        spec_state_name = self._get_smt_name_spec_state(spec_state)
        sys_state_name = self._get_smt_name_sys_state(sys_state_vector, impl.proc_states_descs)

        next_sys_state = map(lambda i: call_func(impl.taus_descs[i][0],
                                                 self._get_proc_tau_args(sys_state_vector, impl.filter_label_by_process(label, i), i, impl)),
                             range(impl.nof_processes))

        next_sys_state_name = ' '.join(next_sys_state)

        assume_laB = self._laB(spec_state_name, sys_state_name)

        assume_out = self._get_assumption_on_output_vars(label, sys_state_vector, impl)

        ##addition: scheduling+topology
        assume_is_active = impl.get_architecture_assumptions(label, sys_state_vector)

        implication_left = op_and([assume_laB, assume_out, assume_is_active])

        dst_set_list = spec_state.transitions[label]
        assert len(dst_set_list) == 1, 'nondet. transitions are not supported'
        dst_set = dst_set_list[0]

        and_args = []
        for spec_next_state, is_rejecting in dst_set:
            if spec_next_state is DEAD_END:
                implication_right = false()
            else:
                next_spec_state_name = self._get_smt_name_spec_state(spec_next_state)

                implication_right_lambdaB = self._laB(next_spec_state_name, next_sys_state_name)

                implication_right_counter = self._get_implication_right_counter(spec_state,
                    spec_next_state,
                    is_rejecting,
                    sys_state_name,
                    next_sys_state_name,
                    state_to_rejecting_scc)

                if implication_right_counter is None:
                    implication_right = implication_right_lambdaB
                else:
                    implication_right = op_and([implication_right_lambdaB, implication_right_counter])

            and_args.append(implication_right)

        #TODO: forall is evil!
        free_input_vars = self._get_free_vars(label, impl)
        return make_assert(forall_bool(free_input_vars, op_implies(implication_left, op_and(and_args))))


    def encode_automaton(self, impl):
        assert len(impl.automaton.initial_sets_list) == 1, 'nondet not supported'

        smt_lines = SmarterList()

        smt_lines += self._define_automaton_states(impl.automaton)

        smt_lines += self._define_counters(impl.proc_states_descs)

        init_sys_state = impl.init_state

        for init_spec_state in impl.automaton.initial_sets_list[0]:
            smt_lines += self._make_init_states_condition(
                self._get_smt_name_spec_state(init_spec_state),
                self._get_smt_name_sys_state(init_sys_state, impl.proc_states_descs))

        global_states = list(product(*[range(len(proc_states_desc[1])) for proc_states_desc in impl.proc_states_descs]))

        state_to_rejecting_scc = build_state_to_rejecting_scc(impl.automaton)

        spec_states = impl.automaton.nodes
        for spec_state in spec_states:
            for global_state in global_states:
                for label, dst_set_list in spec_state.transitions.items():
                    smt_lines += self._encode_transition(
                        spec_state,
                        global_state,
                        label,
                        state_to_rejecting_scc,
                        impl)

        return smt_lines


    def encode_sys_functions(self, impl):
        smt_lines = SmarterList()

        smt_lines += self._define_sys_states(impl.proc_states_descs)

        func_descs = impl.aux_func_descs + list(chain(*impl.outputs_descs)) + impl.taus_descs
        smt_lines += self._define_declare_functions(func_descs)

        smt_lines += impl.get_architecture_assertions()

        return smt_lines

    @log_entrance(logging.getLogger(), logging.INFO)
    def encode(self, impl):
        smt_lines = self.encode_headers()

        smt_lines += self.encode_sys_functions(impl)
        smt_lines += self.encode_automaton(impl)

        smt_lines += self.encode_footings(impl)

        return smt_lines


    def _get_smt_name_spec_state(self, spec_state):
        return '{0}_{1}'.format(self._spec_states_type.lower(), spec_state.name)


    def _get_smt_name_sys_state(self, sys_state_vector, proc_states_descs):
        sys_state_values = list(map(lambda iv: proc_states_descs[iv[0]][1][iv[1]], enumerate(sys_state_vector)))
        return  ' '.join(sys_state_values)


    def _get_proc_tau_args(self, sys_state, proc_label, proc_index, impl):
        """ Return tuple (list of tau args(in correct order), free vars):
            free variables (to be enumerated) called ?var_name.
        """

        proc_state = sys_state[proc_index]

        tau_args = self._get_tau_args_from_label(proc_state, impl.inputs[proc_index], proc_label, impl.proc_states_descs)

        tau_args += impl.get_proc_tau_additional_args(proc_label, sys_state, proc_index)

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

        crt_sharp = self._counter(self._get_smt_name_spec_state(spec_state), sys_state_name)
        next_sharp = self._counter(self._get_smt_name_spec_state(next_spec_state), next_sys_state_name)
        greater = [ge, gt][is_rejecting]

        return greater(next_sharp, crt_sharp, self._logic)


    def _make_get_values(self, impl):
        smt_lines = SmarterList()

        unique_tau_descs = []
        for proc_index, tau_desc in enumerate(impl.model_taus_descs):
            if tau_desc in unique_tau_descs:
                continue
            unique_tau_descs.append(tau_desc)

            for s in impl.proc_states_descs[proc_index][1]:
                for raw_values in product([False, True], repeat=len(tau_desc[1])-1): #first arg is the state
                    values = [str(v).lower() for v in raw_values]
                    smt_lines += get_value(call_func(tau_desc[0], [s] + values))

        processed_outputs = []
        for proc_index, outputs in enumerate(impl.outputs):
            for output_var in outputs:
                output_func = impl.get_output_func_name(output_var)
                if output_func in processed_outputs:
                    continue
                processed_outputs.append(output_func)

                for s in impl.proc_states_descs[proc_index][1]:
                    smt_lines += get_value(call_func(output_func, [s]))

        return '\n'.join(smt_lines)


    def _get_free_vars(self, label, impl):
        free_vars = []

        for proc_index in range(impl.nof_processes):
            for var_name in impl.inputs[proc_index]:
                if var_name not in label:
                    value = '?{0}'.format(var_name)
                    free_vars.append(value)

        free_vars += impl.get_free_sched_vars(label)

        return free_vars


    def parse_model(self, get_value_lines, impl):
        models = []
        processed_tau_descs = []
        for proc_index, (tau_desc, outputs_descs) in enumerate(zip(impl.model_taus_descs, impl.outputs_descs)):
            if tau_desc in processed_tau_descs:
                continue
            processed_tau_descs.append(tau_desc)

            tau_get_value_lines = list(filter(lambda l: tau_desc[0] in l, get_value_lines))

            outputs_get_value_lines = SmarterList()
            for output_desc in outputs_descs:
                outputs_get_value_lines += list(filter(lambda l: output_desc[0] in l, get_value_lines))

            init_state = impl.proc_states_descs[proc_index][1][1] #first process starts in state 1, others - in 0
            state_to_input_to_new_state = self._get_tau_model(tau_get_value_lines, tau_desc)
            state_to_outname_to_value = self._get_output_model(outputs_get_value_lines)

            models.append(LTS(init_state, state_to_outname_to_value, state_to_input_to_new_state))

        return models #TODO: should return nof_processes models?


    def _get_tau_model(self, tau_lines, tau_desc):
        state_to_input_to_new_state = defaultdict(lambda: defaultdict(lambda: {}))
        for l in tau_lines:
            parts = l.replace("(", "").replace(")", "").replace(tau_desc[0], "").strip().split()

            old_state_part = parts[0]
            input_vals = list(map(lambda v: v=='true', parts[1:-1]))
            input_vars = list(map(lambda arg: arg[0], tau_desc[1][1:])) #[1:] due to first var being the state
            inputs = HashableDict(zip(input_vars, input_vals))
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


    def _define_automaton_states(self, automaton):
        smt_lines = SmarterList()
        smt_lines += declare_enum(
            self._spec_states_type, map(lambda n: self._get_smt_name_spec_state(n), automaton.nodes))

        return smt_lines


    def _define_sys_states(self, proc_states_descs):
        smt_lines = SmarterList()

        declared_enums = set()
        for proc_states_desc in proc_states_descs:
            enum_name = proc_states_desc[0]
            if enum_name in declared_enums:
                continue

            smt_lines += declare_enum(enum_name, proc_states_desc[1])
            declared_enums.add(enum_name)

        return smt_lines


    def _define_declare_functions(self, func_defs):
        smt_lines = SmarterList()
        declared_funcs = set()

        for func_name, input_args, output_type, body in func_defs:
            if func_name in declared_funcs:
                continue

            if body is not None:
                smt_lines += body
            else:
                input_types = map(lambda arg: arg[1], input_args)
                smt_lines += declare_fun(func_name, input_types, output_type)

            declared_funcs.add(func_name)

        return smt_lines


    def _get_tau_args_from_label(self, proc_state, proc_inputs, proc_label, proc_states_descs):
        tau_args = [self._get_smt_name_sys_state([proc_state], proc_states_descs)]

        for var_name in proc_inputs:
            if var_name in proc_label:
                tau_args.append(str(proc_label[var_name]).lower())
            else:
                value = '?{0}'.format(var_name)
                tau_args.append(value)

        return tau_args


    def _define_counters(self, proc_states_descs):
        smt_lines = SmarterList()

        counters_args = [self._spec_states_type] + list(map(lambda desc: desc[0], proc_states_descs))

        smt_lines += declare_fun(self._laB_name, counters_args, 'Bool')
        smt_lines += declare_fun(self._laC_name, counters_args, self._logic.counters_type(4))

        return smt_lines


    def _make_init_states_condition(self, init_spec_state_name, init_sys_state_name):
        return make_assert(call_func(self._laB_name, [init_spec_state_name, init_sys_state_name]))


    def _laB(self, spec_state_name, sys_state_expression):
        return call_func(self._laB_name, [spec_state_name, sys_state_expression])


    def _counter(self, spec_state_name, sys_state_name):
        return call_func(self._laC_name, [spec_state_name, sys_state_name])

    def encode_headers(self):
        smt_lines = SmarterList()
        smt_lines += make_headers()
        smt_lines += make_set_logic(self._logic)
        return smt_lines

    def encode_footings(self, impl):
        smt_lines = SmarterList()
        smt_lines += make_check_sat()
        get_values = self._make_get_values(impl)
        smt_lines += get_values
        smt_lines += make_exit()
        return smt_lines


