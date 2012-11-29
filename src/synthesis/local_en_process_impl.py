from helpers.python_ext import StrAwareList
from interfaces.automata import Label
from synthesis.blank_impl import BlankImpl
from synthesis.func_description import FuncDescription
from synthesis.smt_helper import op_and, call_func, op_not, op_implies, forall_bool, build_values_from_label

class SyncImpl(BlankImpl):
    def __init__(self, automaton, anon_inputs, anon_outputs, nof_local_states, sys_state_type,
                 has_tok_var_prefix,
                 sends_var_name,
                 sends_prev_var_name,
                 tau_name,
                 init_states):
        super().__init__()

        self._tau_name = tau_name
        self._has_tok_var_prefix = has_tok_var_prefix
        self._sends_prev_var_name = sends_prev_var_name
        self._sends_var_name = sends_var_name
        self._state_type = sys_state_type
        self._nof_local_states = nof_local_states

        self.automaton = automaton
        self.nof_processes = 1

        self.states_by_process = [tuple(self._get_state_name(self._state_type, i) for i in range(nof_local_states))]
        self.state_types_by_process = [self._state_type]

        self.orig_inputs = [list(anon_inputs)]
        self.inputs = [self.orig_inputs]

        self.init_states = self._build_init_states(init_states)
        self.aux_func_descs = []

        self.outvar_desc_by_process = self._build_outvar_func_by_process(anon_outputs)

        self.taus_descs = self._build_taus_descs()
        self.model_taus_descs = self._build_model_taus_descs()



    def _build_outvar_func_by_process(self, anon_outputs):
        return tuple([tuple((a, FuncDescription(a, {'state':self._state_type}, set(), 'Bool', None)) for a in anon_outputs)])


    def _build_taus_descs(self):
        argname_to_type = dict([('state', self._state_type)] + list(map(lambda i: (str(i), 'Bool'), self.orig_inputs[0])))
        tau_desc = FuncDescription(self._tau_name,
            argname_to_type,
            set(),
            self._state_type,
            None)

        return [tau_desc]


    def _build_model_taus_descs(self):
        return self.taus_descs


    def get_proc_tau_additional_args(self, proc_label, sys_state_vector, proc_index):
        return dict()


    def get_output_func_name(self, concr_var_name):
        return concr_var_name


    def get_architecture_trans_assumption(self, label, sys_state_vector):
        # ignoring active_i in transition labels

        proc_state = sys_state_vector[0]

        sends_prev_value = label.get(self._sends_prev_var_name, '?' + self._sends_prev_var_name)
        sends_prev_value = str(sends_prev_value).lower()

        tok_and_sends_prev = op_and([call_func(self._has_tok_var_prefix, [proc_state]), sends_prev_value])
        not_tok_and_sends_prev = op_not(tok_and_sends_prev) #TODO: hack?

        return not_tok_and_sends_prev


    def get_free_sched_vars(self, label):
        return []


    def filter_label_by_process(self, label, proc_index):
        assert proc_index == 0, str(proc_index)
        return label


    def convert_global_argnames_to_proc_argnames(self, argname_to_values):
        return argname_to_values


    def _build_init_states(self, init_states):
        init_set_of_states = list()
        for state in init_states:
            init_set_of_states.append((state,))
        return init_set_of_states


    def _get_tok_rings_safety_props(self):
        smt_lines = StrAwareList()
        tau_desc = self.taus_descs[0]

        states = self.states_by_process[0]
        for state in states:
            state_str = state

            has_tok_str = call_func(self._has_tok_var_prefix, [state_str])
            sends_tok_str = call_func(self._sends_var_name, [state_str])

            _, free_vars = build_values_from_label(self.orig_inputs[0], Label({self._sends_prev_var_name:False}))

            tau_args_not_sends_prev_raw, _ = build_values_from_label(self.orig_inputs[0], Label({self._sends_prev_var_name:False}))
            tau_args_not_sends_prev_raw.update({'state':state_str})
            tau_args_not_sends_prev = tau_desc.get_args_list(tau_args_not_sends_prev_raw)

            tau_args_sends_prev_raw, _ = build_values_from_label(self.orig_inputs[0], Label({self._sends_prev_var_name:True}))
            tau_args_sends_prev_raw.update({'state':state_str})
            tau_args_sends_prev = tau_desc.get_args_list(tau_args_sends_prev_raw)

            tau_not_sends_prev_str = call_func(tau_desc.name, tau_args_not_sends_prev)
            next_tok_not_sends_prev_str = call_func(self._has_tok_var_prefix, [tau_not_sends_prev_str])

            tau_sends_prev_str = call_func(tau_desc.name, tau_args_sends_prev)
            next_tok_sends_prev_str = call_func(self._has_tok_var_prefix, [tau_sends_prev_str])

            #
            tok_dont_disappear = forall_bool(free_vars,
                op_implies(op_and([has_tok_str, op_not(sends_tok_str)]), next_tok_not_sends_prev_str))

            sends_with_token_only = forall_bool(free_vars,
                op_implies(sends_tok_str, has_tok_str))

            sends_means_release = forall_bool(free_vars,
                op_implies(sends_tok_str, op_not(next_tok_not_sends_prev_str)))

            sends_prev_means_acquire = forall_bool(free_vars,
                next_tok_sends_prev_str)

            no_sends_prev_no_tok_means_no_next_tok = forall_bool(free_vars,
                op_implies(op_not(has_tok_str), op_not(next_tok_not_sends_prev_str)))

            smt_lines += [tok_dont_disappear,
                          sends_with_token_only,
                          sends_means_release,
                          sends_prev_means_acquire,
                          no_sends_prev_no_tok_means_no_next_tok]

        return smt_lines


    def get_architecture_conditions(self):
        smt_lines = self._get_tok_rings_safety_props()

#        smt_lines += '(assert (and (not (tok_ lt2)) (g_ lt2)))'

        return smt_lines
























