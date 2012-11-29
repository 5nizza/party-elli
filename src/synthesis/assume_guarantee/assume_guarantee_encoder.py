from collections import defaultdict
from itertools import product, chain
import logging
from helpers.automata_helper import get_intersection, is_dead_end
from helpers.hashable import HashableDict

from helpers.logging import log_entrance
from helpers.python_ext import StrAwareList
from interfaces.automata import  DEAD_END
from interfaces.lts import LTS
from synthesis.rejecting_states_finder import build_state_to_rejecting_scc
from synthesis.smt_helper import *


#TODO: in general: lots of vars in arguments

class AssumeGuaranteeEncoder: #TODO: current - new counting construction?
    def __init__(self, logic, ass_spec_states_prefix, gua_spec_states_prefix, counters_postfix):
        self._logger = logging.getLogger(__name__)

        self._logic = logic

        self._ass_spec_states_type = ass_spec_states_prefix
        self._gua_spec_states_type = gua_spec_states_prefix

        self._laB_name = 'laB'+counters_postfix
        self._laC_name = 'laC'+counters_postfix



    def _get_assumption_on_output_vars(self, label, sys_state_vector, impl):
        and_args = []
        for i in range(impl.nof_processes):
            for var_name, value in label.items():
                if var_name not in impl.all_outputs[i]:
                    continue

                state_name = self._get_smt_name_proc_state(i, sys_state_vector, impl.proc_states_descs)

                out_condition = call_func(impl.get_output_func_name(var_name), [state_name]) #TODO: hack
                if not label[var_name]:
                    out_condition = op_not(out_condition)

                and_args.append(out_condition)

        return op_and(and_args)


    def _encode_transition(self,
                           sys_state_vector,
                           label,
                           ass_spec_state, ass_dst_set,
                           gua_spec_state, gua_dst_set, gua_impl,
                           state_to_rejecting_scc):
        ass_spec_state_name = self._get_smt_name_spec_state(ass_spec_state, self._ass_spec_states_type)
        gua_spec_state_name = self._get_smt_name_spec_state(gua_spec_state, self._gua_spec_states_type)

        sys_state_name = self._get_smt_name_sys_state(sys_state_vector, gua_impl.proc_states_descs)

        next_sys_state = []
        for i in range(gua_impl.nof_processes):
            tau_concr_args_dict = self._get_proc_tau_args(
                sys_state_vector,
                gua_impl.filter_label_by_process(label, i),
                i,
                gua_impl)

            tau_args_dict = gua_impl.convert_global_args_to_local(tau_concr_args_dict)

            tau_args = gua_impl.taus_descs[i].get_args_list(tau_args_dict)

            next_sys_state.append(call_func(gua_impl.taus_descs[i].name, tau_args))

        free_input_vars = self._get_free_vars(label, gua_impl)

        next_sys_state_name = ' '.join(next_sys_state)

        assume_laB = self._laB(ass_spec_state_name, gua_spec_state_name, sys_state_name)

        assume_out = self._get_assumption_on_output_vars(label, sys_state_vector, gua_impl)

        ##addition: scheduling+topology
        assume_is_active = gua_impl.get_architecture_trans_assumption(label, sys_state_vector)

        premise = op_and([assume_laB, assume_out, assume_is_active])

        and_args = [true()]
        for ass_spec_next_state, _ in ass_dst_set:
            if is_dead_end(ass_spec_next_state):
                and_args = [true()]
                break #env violated its assumptions and we don't model check this
            for gua_spec_next_state, gua_is_rejecting in gua_dst_set:
                if gua_spec_next_state is DEAD_END or gua_spec_next_state.name == 'accept_all': #TODO: hack
                    and_args = [false()]
                    break
                else:
                    ass_next_spec_state_name = self._get_smt_name_spec_state(ass_spec_next_state, self._ass_spec_states_type)
                    gua_next_spec_state_name = self._get_smt_name_spec_state(gua_spec_next_state, self._gua_spec_states_type)

                    laB_conclusion = self._laB(ass_next_spec_state_name, gua_next_spec_state_name, next_sys_state_name)
                    laS_conclusion = self._get_implication_right_counter(
                        ass_spec_state, ass_spec_next_state,
                        gua_spec_state, gua_spec_next_state,
                        gua_is_rejecting,
                        sys_state_name,
                        next_sys_state_name,
                        state_to_rejecting_scc) or true()

                    conclusion = op_and([laB_conclusion, laS_conclusion])

                and_args.append(conclusion)

        condition = forall_bool(free_input_vars, op_implies(premise, op_and(and_args)))
        return condition


    def encode_run_graph_headers(self, ass_automaton, gua_impl, smt_lines):
        if ass_automaton:
            smt_lines += self._define_automaton_states(list(ass_automaton.nodes), self._ass_spec_states_type)
        if gua_impl.automaton:
            smt_lines += self._define_automaton_states(gua_impl.automaton.nodes, self._gua_spec_states_type)

        smt_lines += self._define_counters(gua_impl.proc_states_descs)

        return smt_lines


    def partition_node_transitions(self, node, external_label):
        """ Return: label, dst_set. Requires full transition in node. """

        result = []
        for label, dst_set_list in node.transitions.items():
            common_label = get_intersection(label, external_label)
            if common_label:
                assert len(dst_set_list) == 1
                dst_set = dst_set_list[0]
                result.append((common_label, dst_set))

        return result


    def get_run_graph_conjunctions(self, ass_automaton, gua_impl):
        conjunction = StrAwareList()
        conjunction += gua_impl.get_architecture_conditions() #TODO: looks hacky! replace with two different encoders?

        if not gua_impl.automaton: #TODO: see above, make sense if there are architecture assertions and no automaton
            return conjunction

        assert len(gua_impl.automaton.initial_sets_list) == 1, 'nondet not supported'
        assert len(ass_automaton.initial_sets_list) == 1, 'nondet not supported'

        assert len(ass_automaton.initial_sets_list[0]) == 1, 'universal initial state is not supported!'
        assert len(gua_impl.automaton.initial_sets_list[0]) == 1, 'universal initial state is not supported!'

        ass_init_spec_state = list(ass_automaton.initial_sets_list[0])[0]
        gua_init_spec_state = list(gua_impl.automaton.initial_sets_list[0])[0]


        for init_sys_state in gua_impl.init_states:
            conjunction += self._make_init_states_condition(
                self._get_smt_name_spec_state(ass_init_spec_state, self._ass_spec_states_type),
                self._get_smt_name_spec_state(gua_init_spec_state, self._gua_spec_states_type),
                self._get_smt_name_sys_state(init_sys_state, gua_impl.proc_states_descs))

        global_sys_states = list(product(*[range(len(proc_states_desc[1])) for proc_states_desc in gua_impl.proc_states_descs]))

        #only the second automaton can be liveness
        gua_state_to_rejecting_scc = build_state_to_rejecting_scc(gua_impl.automaton)

        ass_gua_spec_states = product(ass_automaton.nodes, gua_impl.automaton.nodes)

        for ass_spec_state, gua_spec_state in ass_gua_spec_states:
            for global_sys_state in global_sys_states:
                for gua_label, gua_dst_set_list in gua_spec_state.transitions.items():
                    assert len(gua_dst_set_list) == 1

                    gua_dst_set = gua_dst_set_list[0]

                    for ass_label, ass_dst_set in self.partition_node_transitions(ass_spec_state, gua_label):
                        assert (len(ass_dst_set) > 0) and (ass_label is not None)

                        transition_condition = self._encode_transition(
                            global_sys_state,
                            ass_label,
                            ass_spec_state, ass_dst_set,
                            gua_spec_state, gua_dst_set, gua_impl,
                            gua_state_to_rejecting_scc)

                        conjunction += transition_condition

        return conjunction


    def encode_run_graph(self, ass_automaton, gua_impl, smt_lines):
        conjunctions = self.get_run_graph_conjunctions(ass_automaton, gua_impl)
        for c in conjunctions:
            smt_lines += make_assert(c)
        return smt_lines

#        smt_lines += impl.get_architecture_assertions() #TODO: looks hacky! replace with two different encoders?
#
#        if not impl.automaton: #TODO: see above, make sense if there are architecture assertions and no automaton
#            return smt_lines
#
#        assert len(impl.automaton.initial_sets_list) == 1, 'nondet not supported'
#
#        init_sys_states = impl.init_states
#
#        for init_spec_state in impl.automaton.initial_sets_list[0]:
#            for init_sys_state in init_sys_states:
#                smt_lines += self._make_init_states_condition(
#                    self._get_smt_name_spec_state(init_spec_state),
#                    self._get_smt_name_sys_state(init_sys_state, impl.proc_states_descs))
#
#        global_states = list(product(*[range(len(proc_states_desc[1])) for proc_states_desc in impl.proc_states_descs]))
#
#        state_to_rejecting_scc = build_state_to_rejecting_scc(impl.automaton)
#
#        spec_states = impl.automaton.nodes
#        for spec_state in spec_states:
#            for global_state in global_states:
#                for label, dst_set_list in spec_state.transitions.items():
#                    transition_assertions = self._encode_transition(spec_state, global_state, label, state_to_rejecting_scc, impl)
#
#                    smt_lines += comment(label)
#                    smt_lines += transition_assertions
#
#        return smt_lines


    def encode_sys_model_functions(self, impl, smt_lines):
        self._define_sys_states(impl.proc_states_descs, smt_lines)

        func_descs = list(chain(*impl.all_outputs_descs)) + impl.model_taus_descs
        smt_lines += self._define_declare_functions(func_descs)
        return smt_lines


    def encode_sys_aux_functions(self, impl, smt_lines):
        func_descs = impl.aux_func_descs + (impl.taus_descs if impl.taus_descs != impl.model_taus_descs else [])
        functions = self._define_declare_functions(func_descs)
        smt_lines += functions

        return smt_lines

    @log_entrance(logging.getLogger(), logging.INFO)
    def encode(self, ass_automaton, gua_impl, smt_lines):
        self.encode_headers(smt_lines)

        self.encode_sys_model_functions(gua_impl, smt_lines)
        self.encode_sys_aux_functions(gua_impl, smt_lines)

        self.encode_run_graph_headers(ass_automaton, gua_impl, smt_lines)
        self.encode_run_graph(ass_automaton, gua_impl, smt_lines)

        self.encode_footings(gua_impl, smt_lines)

        return smt_lines


    def _get_smt_name_spec_state(self, spec_state, spec_type):
        return '{0}_{1}'.format(spec_type.lower(), spec_state.name)


    def _get_smt_name_sys_state(self, sys_state_vector, proc_states_desc):
        proc_states = map(lambda iv: proc_states_desc[iv[0]][1][iv[1]], enumerate(sys_state_vector))
        return ' '.join(proc_states)


    def _get_smt_name_proc_state(self, proc_index, sys_state_vector, proc_states_descs):
        return proc_states_descs[proc_index][1][sys_state_vector[proc_index]]


    def _get_proc_tau_args(self, sys_state, proc_label, proc_index, impl):
        """ Return dict: name->value
            free variables (to be enumerated) has called ?var_name value.
        """

        tau_args = dict()

        proc_state = self._get_smt_name_proc_state(proc_index, sys_state, impl.proc_states_descs)
        tau_args.update({'state':proc_state}) #TODO: hack: name 'state'

        label_vals_dict, _ = build_values_from_label(impl.orig_inputs[proc_index], proc_label)
        tau_args.update(label_vals_dict)

        tau_args.update(impl.get_proc_tau_additional_args(proc_label, sys_state, proc_index))

        res = dict(tau_args)

        return res


    def _get_implication_right_counter(self,
                                       ass_spec_state, next_ass_spec_state,
                                       gua_spec_state, next_gua_spec_state,
                                       is_rejecting,
                                       sys_state_name, next_sys_state_name,
                                       state_to_rejecting_scc):

        crt_rejecting_scc = state_to_rejecting_scc.get(gua_spec_state, None)
        next_rejecting_scc = state_to_rejecting_scc.get(next_gua_spec_state, None)

        if crt_rejecting_scc is not next_rejecting_scc:
            return None
        if crt_rejecting_scc is None:
            return None
        if next_rejecting_scc is None:
            return None

        crt_sharp = self._counter(
            self._get_smt_name_spec_state(ass_spec_state, self._ass_spec_states_type),
            self._get_smt_name_spec_state(gua_spec_state, self._gua_spec_states_type),
            sys_state_name)
        next_sharp = self._counter(
            self._get_smt_name_spec_state(next_ass_spec_state, self._ass_spec_states_type),
            self._get_smt_name_spec_state(next_gua_spec_state, self._gua_spec_states_type),
            next_sys_state_name)
        greater = [ge, gt][is_rejecting]

        return greater(next_sharp, crt_sharp, self._logic)


    def _make_get_values(self, impl):
        smt_lines = StrAwareList()

        unique_tau_descs = []
        for proc_index, tau_desc in enumerate(impl.model_taus_descs):
            if tau_desc in unique_tau_descs:
                continue
            unique_tau_descs.append(tau_desc)

            for s in impl.proc_states_descs[proc_index][1]:
                for raw_values in product(['false', 'true'], repeat=len(tau_desc.inputs)-1): #one arg is the state
                    bool_vars = list(filter(lambda name_type: name_type[1] == 'Bool', tau_desc.inputs))
                    bool_var_vals = [(var, val) for (var, type), val in zip(bool_vars, raw_values)]

                    value_from_name = dict(bool_var_vals + [('state',s)]) #TODO: hack: you know the name of state var

                    smt_lines += get_value(call_func(tau_desc.name, tau_desc.get_args_list(value_from_name)))

        processed_outputs = []
        for proc_index, outputs in enumerate(impl.all_outputs):
            for output_var in outputs:
                output_func = impl.get_output_func_name(output_var)
                if output_func in processed_outputs:
                    continue
                processed_outputs.append(output_func)

                for s in impl.proc_states_descs[proc_index][1]:
                    smt_lines += get_value(call_func(output_func, [s]))

        return '\n'.join(smt_lines)


    def _get_free_vars(self, label, impl):
        free_vars = set(chain(*[build_values_from_label(impl.orig_inputs[proc_index], label)[1]
                                for proc_index in range(impl.nof_processes)]))

        free_vars.update(impl.get_free_sched_vars(label))

        return free_vars


    def parse_model(self, get_value_lines, impl):
        models = []
        processed_tau_descs = []
        for proc_index, (tau_desc, outputs_descs) in enumerate(zip(impl.model_taus_descs, impl.all_outputs_descs)):
            if tau_desc in processed_tau_descs:
                continue
            processed_tau_descs.append(tau_desc)

            tau_get_value_lines = list(filter(lambda l: tau_desc.name in l, get_value_lines))

            outputs_get_value_lines = StrAwareList()
            for output_desc in outputs_descs:
                outputs_get_value_lines += list(filter(lambda l: output_desc.name in l, get_value_lines))

            init_state = impl.proc_states_descs[proc_index][1][1] #first process starts in state 1, others - in 0
            state_to_input_to_new_state = self._get_tau_model(tau_get_value_lines, tau_desc)
            state_to_outname_to_value = self._get_output_model(outputs_get_value_lines)

            models.append(LTS(init_state, state_to_outname_to_value, state_to_input_to_new_state))

        return models #TODO: should return nof_processes models?


    def _get_tau_model(self, tau_lines, tau_desc):
        state_to_input_to_new_state = defaultdict(lambda: defaultdict(lambda: {}))
        for l in tau_lines:
            parts = l.replace("(", "").replace(")", "").replace(tau_desc.name, "").strip().split()

            old_state, new_state = list(filter(lambda t: t!='true' and t!='false', parts))
            input_vals = list(map(lambda t: t=='true', filter(lambda t: t=='true' or t=='false', parts)))

            #[1:] due to first var being the state
            input_vars = list(map(lambda arg: arg[0], tau_desc.inputs[1:]))
            inputs = HashableDict(zip(input_vars, input_vals))
            state_to_input_to_new_state[old_state][inputs] = new_state

        return state_to_input_to_new_state


    def _get_output_model(self, output_lines):
        state_to_outname_to_value = defaultdict(lambda: defaultdict(lambda: {}))
        for l in output_lines:
            parts  = l.replace("(", "").replace(")", "").strip().split()
            assert len(parts) == 3, str(parts)
            outname, state, outvalue = parts
            state_to_outname_to_value[state][outname] = outvalue

        return state_to_outname_to_value


    def _define_automaton_states(self, automaton_nodes, states_type):
        smt_lines = StrAwareList()
        smt_lines += declare_enum(
            states_type, map(lambda n: self._get_smt_name_spec_state(n, states_type), automaton_nodes))

        return smt_lines


    def _define_sys_states(self, proc_states_descs, smt_lines):
        declared_enums = set()
        for proc_states_desc in proc_states_descs:
            enum_name = proc_states_desc[0]
            if enum_name in declared_enums:
                continue

            sys_state_names = proc_states_desc[1]

            smt_lines += declare_enum(enum_name, sys_state_names)

            declared_enums.add(enum_name)

        return smt_lines


    def _define_declare_functions(self, func_descs):
        smt_lines = StrAwareList()
        declared_funcs = set()
        for func_desc in func_descs:
#            func_name, input_args, output_type, body
            if func_desc.name in declared_funcs:
                continue

            if func_desc.definition is not None:
                smt_lines += func_desc.definition
            else:
                input_types = map(lambda i_t: i_t[1], func_desc.inputs)
                smt_lines += declare_fun(func_desc.name, input_types, func_desc.output)

            declared_funcs.add(func_desc.name)

        return smt_lines


    def _define_counters(self, proc_states_descs):
        smt_lines = StrAwareList()
        global_sys_state = list(map(lambda desc: desc[0], proc_states_descs))
        counters_args = [self._ass_spec_states_type, self._gua_spec_states_type] + global_sys_state

        smt_lines += declare_fun(self._laB_name, counters_args, 'Bool')
        smt_lines += declare_fun(self._laC_name, counters_args, self._logic.counters_type())

        return smt_lines


    def _make_init_states_condition(self, ass_init_spec_state_name, gua_init_spec_state_name, init_sys_state_name):
        return call_func(self._laB_name, [ass_init_spec_state_name, gua_init_spec_state_name, init_sys_state_name])


    def _laB(self, ass_spec_state_name, gua_spec_state_name, sys_state_expression):
        return call_func(self._laB_name, [ass_spec_state_name, gua_spec_state_name, sys_state_expression])


    def _counter(self, ass_spec_state_name, gua_spec_state_name, sys_state_name):
        return call_func(self._laC_name, [ass_spec_state_name, gua_spec_state_name, sys_state_name])


    def encode_headers(self, smt_lines):
        smt_lines += make_headers()
        smt_lines += make_set_logic(self._logic)
        return smt_lines


    def encode_footings(self, impl, smt_lines):
        smt_lines += make_check_sat()
        get_values = self._make_get_values(impl)
        smt_lines += get_values
        smt_lines += make_exit()
        return smt_lines
