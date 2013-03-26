import logging

from itertools import product, chain
from helpers.labels_map import LabelsMap
from helpers.logging import log_entrance
from helpers.python_ext import StrAwareList, lmap, lfilter
from interfaces.automata import DEAD_END, Label
from interfaces.lts import LTS
from interfaces.solver_interface import EncodingSolver, SolverInterface
from synthesis.blank_impl import BlankImpl
from synthesis.func_description import FuncDescription
from synthesis.rejecting_states_finder import build_state_to_rejecting_scc
from synthesis.smt_helper import build_signals_values


class GenericEncoder(EncodingSolver):
    def __init__(self, logic,
                 spec_state_prefix, counters_postfix,
                 sys_state_type_by_process,
                 underlying_solver:SolverInterface):
        self._underlying_solver = underlying_solver

        self._logger = logging.getLogger(__name__)

        self._logic = logic

        self._spec_states_type = spec_state_prefix

        self._la_q_name = 'q'
        self._la_s_name = 's'

        counters_inputs = {self._la_q_name: self._spec_states_type}
        counters_inputs.update((self._la_s_name + str(i), s)
                               for (i, s) in enumerate(sys_state_type_by_process))

        self._laB_func_desc = FuncDescription('laB' + counters_postfix, counters_inputs, 'Bool', None)
        self._laC_func_desc = FuncDescription('laC' + counters_postfix, counters_inputs, logic.counters_type(), None)

        self._last_only_states = None

    def _get_assumption_on_output_vars(self, label:dict, sys_state_vector, impl) -> str:
        conjuncts = []

        output_signals = set(chain(*[d.keys() for d in impl.outvar_desc_by_process]))

        for lbl_signal_, lbl_signal_value in label.items():
            #: :type: QuantifiedSignal
            lbl_signal = lbl_signal_

            if lbl_signal not in output_signals:
                continue

            assert len(lbl_signal.binding_indices) == 1  # TODO: remove when finish non-parameterized case

            proc_index = lbl_signal.binding_indices[0]

            out_desc_by_signal = impl.outvar_desc_by_process[proc_index]

            out_desc = out_desc_by_signal[lbl_signal]

            out_args = self._get_proc_tau_args(sys_state_vector, label, proc_index, impl)

            condition_on_out = self._underlying_solver.call_func(out_desc, out_args)

            if lbl_signal_value is False:
                condition_on_out = self._underlying_solver.op_not(condition_on_out)

            conjuncts.append(condition_on_out)

        assumption_on_outputs_vars = self._underlying_solver.op_and(conjuncts)

        return assumption_on_outputs_vars

    def _encode_transition(self,
                           spec_state,
                           sys_state_vector,
                           label,
                           state_to_rejecting_scc,
                           impl):
        spec_state_name = self._get_smt_name_spec_state(spec_state)
        sys_state_name_dict = {(self._la_s_name + str(i), s)
                               for (i, s) in enumerate(sys_state_vector)}

        next_sys_state = []
        for i in range(impl.nof_processes):
            proc_tau_args = self._get_proc_tau_args(sys_state_vector, label, i, impl)
            next_sys_state.append(self._underlying_solver.call_func(impl.taus_descs[i], proc_tau_args))

        #TODO: forall is evil?
        free_input_vars = self._get_free_vars(label, impl)

        next_sys_state_name_dict = dict((self._la_s_name + str(i), s)
                                        for (i, s) in enumerate(next_sys_state))

        assume_laB = self._laB(spec_state_name, sys_state_name_dict)

        assume_out = self._get_assumption_on_output_vars(label, sys_state_vector, impl)

        ##addition: scheduling+topology
        assume_is_active = impl.get_architecture_trans_assumption(label, sys_state_vector)

        implication_left = self._underlying_solver.op_and([assume_laB, assume_out, assume_is_active])

        dst_set_list = spec_state.transitions[label]
        assert len(dst_set_list) == 1, 'nondetermenistic transitions are not supported'
        dst_set = dst_set_list[0]

        and_args = []
        for spec_next_state, is_rejecting in dst_set:
            if spec_next_state is DEAD_END or spec_next_state.name == 'accept_all':  # TODO: hack
                implication_right = self._underlying_solver.false()
            else:
                next_spec_state_name = self._get_smt_name_spec_state(spec_next_state)

                implication_right_lambdaB = self._laB(next_spec_state_name, next_sys_state_name_dict)

                implication_right_counter = self._get_implication_right_counter(spec_state,
                                                                                spec_next_state,
                                                                                is_rejecting,
                                                                                sys_state_name_dict,
                                                                                next_sys_state_name_dict,
                                                                                state_to_rejecting_scc)

                if implication_right_counter is None:
                    implication_right = implication_right_lambdaB
                else:
                    implication_right = self._underlying_solver.op_and([implication_right_lambdaB,
                                                                        implication_right_counter])

            and_args.append(implication_right)

        quantified_expr = self._underlying_solver.op_implies(implication_left,
                                                             self._underlying_solver.op_and(and_args))
        condition = self._underlying_solver.forall_bool(free_input_vars, quantified_expr)

        return condition

    def encode_run_graph_headers(self, impl):
        if not impl.automaton:  # make sense if there are architecture assertions and no automaton
            return

        self._define_automaton_states(impl.automaton)
        self._define_counters()

    def _get_permissible_states_clause(self, next_state_name, permissible_states) -> str:
        or_clauses = [self._underlying_solver.op_eq(next_state_name, self._get_smt_name_sys_state(s))
                      for s in permissible_states]

        return self._underlying_solver.op_or(or_clauses)

    def _restrict_trans(self, impl, permissible_states):
        #: :type: FuncDescription
        trans_func_desc = impl.taus_descs[0]

        assertions = StrAwareList()

        for curr_state in permissible_states:
            free_input_vars = self._get_free_vars(Label(), impl)
            value_by_arg = self._get_proc_tau_args(curr_state, Label(), 0, impl)
            next_state = self._underlying_solver.call_func(trans_func_desc, value_by_arg)
            assertions += self._underlying_solver.assert_(
                self._underlying_solver.forall_bool(free_input_vars,
                                                    self._get_permissible_states_clause(next_state,
                                                                                        permissible_states)))

        return assertions

    def get_run_graph_assertions(self, impl, model_states_to_encode):
        for a in impl.get_architecture_requirements():  # TODO: looks hacky! replace with two different encoders?
            self._underlying_solver.assert_(a)

        # TODO: see 'todo' above, make sense if there are architecture assertions and no automaton
        if not impl.automaton:
            return

        assert len(impl.automaton.initial_sets_list) == 1, 'nondet not supported'

        init_sys_states = impl.init_states

        for init_spec_state in impl.automaton.initial_sets_list[0]:
            for init_sys_state in init_sys_states:
                init_state_condition = self._make_init_states_condition(init_spec_state, init_sys_state)

                self._underlying_solver.assert_(init_state_condition)

        global_states = list(product(*(impl.nof_processes * [model_states_to_encode])))

        state_to_rejecting_scc = build_state_to_rejecting_scc(impl.automaton)

        spec_states = impl.automaton.nodes

        for global_state in global_states:
            for spec_state in spec_states:
                for label, dst_set_list in spec_state.transitions.items():
                    transition_condition = self._encode_transition(spec_state, global_state, label,
                                                                   state_to_rejecting_scc, impl)

                    self._underlying_solver.assert_(transition_condition)

            self._underlying_solver.comment('encoded state ' + self._get_smt_name_sys_state(global_state))

    def encode_run_graph(self, impl:BlankImpl, model_states_to_encode):
        self.get_run_graph_assertions(impl, model_states_to_encode)

    def encode_sys_model_functions(self, impl):
        states_by_type = dict(zip(impl.state_types_by_process, impl.states_by_process))
        self._define_sys_states(states_by_type)

        func_descs = list(chain(*impl.get_outputs_descs())) + impl.model_taus_descs
        self._define_declare_functions(func_descs)

    def encode_sys_aux_functions(self, impl):
        func_descs = impl.aux_func_descs_ordered + (
            impl.taus_descs if impl.taus_descs != impl.model_taus_descs else [])  # TODO: the comparison looks erroneous

        self._define_declare_functions(func_descs)

    @log_entrance(logging.getLogger(), logging.INFO)
    def encode(self, impl, states_to_encode):
        self.encode_sys_model_functions(impl)
        self.encode_sys_aux_functions(impl)
        self.encode_run_graph_headers(impl)
        self.encode_run_graph(impl, states_to_encode)
        self.encode_footings(impl)

    def _get_smt_name_spec_state(self, spec_state):
        return '{0}_{1}'.format(self._spec_states_type.lower(), spec_state.name)

    def _get_smt_name_sys_state(self, sys_state_vector):
        return ' '.join(sys_state_vector)

    def _get_proc_tau_args(self, sys_state_vector, label, proc_index:int, impl) -> dict:
        """ Return dict: name->value
            free variables (to be enumerated) have ?var_name value.
        """

        proc_label = impl.filter_label_by_process(label, proc_index)

        glob_tau_args = dict()

        proc_state = sys_state_vector[proc_index]
        glob_tau_args.update({impl.state_arg_name: proc_state})

        #TODO: try to use label instead of proc_label
        #      should be the same -- alleviate the need of impl.filter_label_by_process
        label_vals_dict, _ = build_signals_values(impl.orig_inputs[proc_index], proc_label)
        glob_tau_args.update(label_vals_dict)

        glob_tau_args.update(impl.get_proc_tau_additional_args(proc_label, sys_state_vector, proc_index))

        return glob_tau_args

    def _get_implication_right_counter(self, spec_state, next_spec_state,
                                       is_rejecting,
                                       sys_state_name_dict, next_sys_state_name_dict,
                                       state_to_rejecting_scc):

        crt_rejecting_scc = state_to_rejecting_scc.get(spec_state, None)
        next_rejecting_scc = state_to_rejecting_scc.get(next_spec_state, None)

        if crt_rejecting_scc is not next_rejecting_scc:
            return None
        if crt_rejecting_scc is None:
            return None
        if next_rejecting_scc is None:
            return None

        crt_sharp = self._counter(self._get_smt_name_spec_state(spec_state), sys_state_name_dict)
        next_sharp = self._counter(self._get_smt_name_spec_state(next_spec_state), next_sys_state_name_dict)
        greater = [self._underlying_solver.op_ge, self._underlying_solver.op_gt][is_rejecting]

        return greater(next_sharp, crt_sharp, self._logic)

    #TODO: introduce class Type: values, type_name and remove states arg
    def _get_all_possible_inputs(self, states, func_desc:FuncDescription):
        arg_to_type = func_desc.inputs

        value_records = product(*[('true', 'false') if i_t[1] == 'Bool' else states
                                  for i_t in arg_to_type])

        dicts = []
        for vr in value_records:
            typed_values_record = dict((arg_to_type[i][0], v)
                                       for i, v in enumerate(vr))
            dicts.append(typed_values_record)

        return dicts

    def _make_get_values_func_descs(self, impl, func_descs_by_proc):
        if self._last_only_states:
            model_states = self._last_only_states
        else:
            model_states = impl.states_by_process[0]  # TODO: doesn't work in distributive case

        processed_func_names = set()

        for func_descs, states in zip(func_descs_by_proc, impl.nof_processes * [model_states]):

            new_func_descs = dict([(f.name, f) for f in func_descs if f.name not in processed_func_names]).values()

            for func_desc in new_func_descs:
                for input_dict in self._get_all_possible_inputs(states, func_desc):
                    self._underlying_solver.get_value(self._underlying_solver.call_func(func_desc, input_dict))

            processed_func_names.update(f.name for f in func_descs)

    def _make_get_values(self, impl):
        self._make_get_values_func_descs(impl, ((m,) for m in impl.model_taus_descs))
        self._make_get_values_func_descs(impl, impl.get_outputs_descs())

    def _get_free_vars(self, label, impl):
        free_vars = set(chain(*[build_signals_values(impl.orig_inputs[proc_index], label)[1]
                                for proc_index in range(impl.nof_processes)]))

        free_vars.update(impl.get_free_sched_vars(label))

        return free_vars

    def _parse_values(self, values):  # TODO: introduce type class
        return [v == 'true' if v == 'true' or v == 'false' else v for v in values]

    def _build_func_model_from_smt(self, func_smt_lines, func_desc:FuncDescription) -> dict:
        """ Return transition(output) graph {label:output}
        """
        func_model = {}

        for l in func_smt_lines:
        #            (get-value ((tau t0 true true)))
            l = l.replace('get-value', '').replace('(', '').replace(')', '')
            tokens = l.split()
            if tokens[0] != func_desc.name:
                continue

            values = self._parse_values(tokens[1:])  # the very first - func_name
            args = Label(func_desc.get_args_dict(values[:-1]))
            func_model[args] = values[-1]

        return func_model

    def parse_sys_model(self, get_value_lines, impl):  # TODO: depends on SMT format
        models = []
        for i in range(impl.nof_processes):
            tau_func_desc = impl.model_taus_descs[i]

            tau_model = LabelsMap(self._build_func_model_from_smt(get_value_lines, tau_func_desc))

            outputs_descs = impl.get_outputs_descs()[i]
            output_models = dict()
            for output_desc in outputs_descs:
                output_func_model = self._build_func_model_from_smt(get_value_lines, output_desc)

                output_models[output_desc.name] = LabelsMap(output_func_model)

            init_states = set(sys_init_state[i] for sys_init_state in impl.init_states)

            #noinspection PyTypeChecker
            lts = LTS(init_states, output_models, tau_model, 'state',
                      impl.orig_inputs[i], list(impl.outvar_desc_by_process[i].keys()))

            models.append(lts)  # TODO: hack: replace by constant

        return models

    def _define_automaton_states(self, automaton):
        self._underlying_solver.declare_enum(
            self._spec_states_type, map(lambda n: self._get_smt_name_spec_state(n), automaton.nodes))

    def _define_sys_states(self, states_by_type:dict):
        for (ty, states) in states_by_type.items():
            self._underlying_solver.declare_enum(ty, states)

    def _define_declare_functions(self, func_descs):
        #should preserve the order: some functions may depend on others
        desc_by_name = dict((desc.name, (i, desc)) for (i, desc) in enumerate(func_descs))
        # TODO: cannot use set of func descriptions due to hack in FuncDescription

        unique_index_descs_sorted = sorted(desc_by_name.values(), key=lambda i_d: i_d[0])
        unique_descs = lmap(lambda i_d: i_d[1], unique_index_descs_sorted)

        for desc in unique_descs:
            if desc.definition is not None:
                self._underlying_solver.define_fun(desc)
            else:
                self._underlying_solver.declare_fun(desc)

    def _define_counters(self):
        smt_lines = StrAwareList()

        smt_lines += self._underlying_solver.declare_fun(self._laB_func_desc)
        smt_lines += self._underlying_solver.declare_fun(self._laC_func_desc)

        return smt_lines

    def _make_init_states_condition(self, init_spec_state, init_sys_state):
        args_dict = {self._la_q_name: self._get_smt_name_spec_state(init_spec_state)}
        args_dict.update((self._la_s_name + str(i), s)
                         for (i, s) in enumerate(init_sys_state))

        return self._underlying_solver.call_func(self._laB_func_desc, args_dict)

    def _la(self, desc, spec_state_name, sys_state_name_dict):
        args_dict = {self._la_q_name: spec_state_name}
        args_dict.update(sys_state_name_dict)

        return self._underlying_solver.call_func(desc, args_dict)

    def _laB(self, spec_state_name, sys_state_expression_dict):
        return self._la(self._laB_func_desc, spec_state_name, sys_state_expression_dict)

    def _counter(self, spec_state_name, sys_state_name_dict:dict):
        return self._la(self._laC_func_desc, spec_state_name, sys_state_name_dict)

    #### Encoding Solver ####
    def push(self):
        return self._underlying_solver.push()

    def pop(self):
        return self._underlying_solver.pop()

    def solve(self, impl) -> LTS:
        self._underlying_solver.add_check_sat()
        self._make_get_values(impl)   # incremental solvers should not fail for such a strange case if UNSAT:)
        out = self._underlying_solver.solve()
        if not out:
            return None

        model = self.parse_sys_model(out, impl)
        self._last_only_states = None   # TODO: i don't like this state-shit here
        return model

    def _get_next_state_restricted_condition(self, state, only_states,
                                             tau_desc:FuncDescription,
                                             state_arg_name:str):
        input_signals = [var for var,ty in tau_desc.inputs if var != state_arg_name]

        values_by_signal, free_vars = build_signals_values(input_signals, Label())

        args = {state_arg_name: state}
        args.update(values_by_signal)
        next_state_expr = self._underlying_solver.call_func(tau_desc, args)

        or_clauses = []
        for possible_state in only_states:
            or_clauses.append(self._underlying_solver.op_eq(next_state_expr,
                                                            possible_state))

        condition = self._underlying_solver.forall_bool(free_vars,
                                                        self._underlying_solver.op_or(or_clauses))
        return condition

    def encode_model_bound(self, only_states, impl):
        self._last_only_states = only_states

        unique_model_tau_descs = set(impl.model_taus_descs)

        for tau_desc in unique_model_tau_descs:
            for state in only_states:
                condition = self._get_next_state_restricted_condition(state, only_states, tau_desc, impl.state_arg_name)

                self._underlying_solver.assert_(condition)
