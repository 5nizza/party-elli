from helpers.python_ext import StrAwareList
from interfaces.automata import Label
from synthesis.func_description import FuncDescription
from synthesis.smt_helper import op_and, call_func, op_not, op_implies, forall_bool, build_values_from_label, make_assert

class LocalENImpl:
    def __init__(self, automaton, anon_inputs, anon_outputs, nof_local_states, sys_state_type,
                 has_tok_var_prefix,
                 sends_var_name,
                 sends_prev_var_name,
                 tau_name,
                 init_states):
        #TODO: if introduce has_tok optimization - be careful about initial states! (case of HOT encoding)
        self.automaton = automaton

        self._state_type = sys_state_type

        self.nof_processes = 1
        self.proc_states_descs = self._create_proc_descs(nof_local_states)

        self._nof_local_states = nof_local_states

        #no architecture => all architecture specific inputs/outputs
        self.orig_inputs = [list(anon_inputs)]
        self.orig_outputs = self.all_outputs = [list(anon_outputs)]

        self._tau_name = tau_name
        self._has_tok_var_prefix = has_tok_var_prefix
        self._sends_prev_var_name = sends_prev_var_name
        self._init_states = init_states
        self._sends_var_name = sends_var_name

    @property
    def aux_func_descs(self):
        return []

    @property
    def taus_descs(self):
        argname_to_type = dict([('state', self._state_type)] + list(map(lambda i: (str(i), 'Bool'), self.orig_inputs[0])))
        tau_desc = FuncDescription(self._tau_name,
            argname_to_type,
            set(),
            self._state_type,
            None)

        return [tau_desc]

    @property
    def model_taus_descs(self):
        return self.taus_descs


    def get_proc_tau_additional_args(self, proc_label, sys_state_vector, proc_index):
        return dict()


    def get_output_func_name(self, concr_var_name):
        return concr_var_name


    def get_architecture_trans_assumptions(self, label, sys_state_vector):
        # ignoring active_i in transition labels

        proc_state = self.proc_states_descs[0][1][sys_state_vector[0]]

        sends_prev_value = label.get(self._sends_prev_var_name, '?' + self._sends_prev_var_name)
        sends_prev_value = str(sends_prev_value).lower()

        tok_and_sends_prev = op_and([call_func(self._has_tok_var_prefix, [proc_state]), sends_prev_value])
        not_tok_and_sends_prev = op_not(tok_and_sends_prev) #TODO: hack?

        return not_tok_and_sends_prev


    def get_free_sched_vars(self, label):
        return []


    def _create_proc_descs(self, nof_local_states):
        return list(map(lambda proc_i: (self._state_type, list(map(lambda s: self._state_type.lower()+str(s), range(nof_local_states)))),
                        range(self.nof_processes)))


    def filter_label_by_process(self, label, proc_index):
        assert proc_index == 0, str(proc_index)
        return label

    def convert_global_argnames_to_proc_argnames(self, argname_to_values):
        return argname_to_values

    @property
    def init_states(self):
        init_set_of_states = list()
        for state in self._init_states:
            init_set_of_states.append([state])
        return init_set_of_states


    def _get_tok_rings_safety_props(self):
        smt_lines = StrAwareList()
        tau_desc = self.taus_descs[0]

        for state in range(self._nof_local_states):
            state_str = self.proc_states_descs[0][1][state]

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
            tok_dont_disappear = make_assert(forall_bool(free_vars,
                op_implies(op_and([has_tok_str, op_not(sends_tok_str)]), next_tok_not_sends_prev_str)))

            sends_with_token_only = make_assert(forall_bool(free_vars,
                op_implies(sends_tok_str, has_tok_str)))

            sends_means_release = make_assert(forall_bool(free_vars,
                op_implies(sends_tok_str, op_not(next_tok_not_sends_prev_str))))

            sends_prev_means_acquire = make_assert(forall_bool(free_vars,
                next_tok_sends_prev_str))

            no_sends_prev_no_tok_means_no_next_tok = make_assert(forall_bool(free_vars,
                op_implies(op_not(has_tok_str), op_not(next_tok_not_sends_prev_str))))

            smt_lines += [tok_dont_disappear,
                          sends_with_token_only,
                          sends_means_release,
                          sends_prev_means_acquire,
                          no_sends_prev_no_tok_means_no_next_tok]

        return smt_lines


    def get_architecture_assertions(self):
        smt_lines = self._get_tok_rings_safety_props()

#        smt_lines += '(assert (and (not (tok_ lt2)) (g_ lt2)))'

        return smt_lines
























