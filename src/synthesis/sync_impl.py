from helpers.python_ext import StrAwareList, add_dicts
from interfaces.automata import Label, Automaton
from synthesis.blank_impl import BlankImpl
from synthesis.func_description import FuncDescription
from synthesis.smt_helper import op_and, op_not, op_implies, forall_bool, build_signals_values, call_func


class SyncImpl(BlankImpl):  # TODO: This class was never tested separately from ParImpl.
    """
    Class method "get_architecture_trans_assumption" returns G(tok -> !sends_prev).

    There are no scheduling restrictions, the process is assumed
    to be always scheduled.
    """

    def __init__(self, automaton:Automaton,
                 is_mealy:bool,

                 spec_input_signals, spec_output_signals,
                 nof_local_states:int,
                 sys_state_type,

                 has_tok_signal, sends_signal,

                 sends_prev_signal,
                 tau_name,
                 init_process_states):

        if not init_process_states:
            s1 = self._get_state_name(sys_state_type, 1)
            s0 = self._get_state_name(sys_state_type, 0)
            init_process_states = [s1, s0]

        super().__init__(is_mealy)

        self._tau_name = tau_name
        self._has_tok_signal = has_tok_signal
        self._sends_signal = sends_signal

        self._sends_prev_signal = sends_prev_signal

        self._state_type = sys_state_type
        self._nof_local_states = nof_local_states

        #### BlankImpl interface #TODO: use super().init() with args
        self.automaton = automaton
        self.nof_processes = 1

        self.states_by_process = [tuple(self._get_state_name(self._state_type, i) for i in range(nof_local_states))]
        self.state_types_by_process = [self._state_type]

        self.orig_inputs = [spec_input_signals + [sends_prev_signal]]

        self.init_states = [(s,) for s in init_process_states]
        self.aux_func_descs = []

        archi_outputs = [sends_signal, has_tok_signal]
        all_output_signals = spec_output_signals + archi_outputs
        self.outvar_desc_by_process = [
            self._build_desc_by_outvar(all_output_signals, archi_outputs, self.orig_inputs[0])]

        #no scheduler and is_active inputs
        self.taus_descs = [self._build_tau_desc(self.orig_inputs[0])]
        self.model_taus_descs = self.taus_descs

    def _build_desc_by_outvar(self, output_signals,
                              archi_outputs,
                              all_model_inputs):  # TODO: mess -- self.arg vs arg to the function
        desc_by_signal = dict()
        for s_ in output_signals:
            #: :type: QuantifiedSignal
            s = s_

            type_by_signal = {self.state_arg_name: self._state_type}

            if self.is_mealy and s not in archi_outputs:
                type_by_signal.update((s, 'Bool') for s in all_model_inputs)

            desc_by_signal[s] = FuncDescription(s.name, type_by_signal, 'Bool', None)

        return desc_by_signal

    def _build_tau_desc(self, model_inputs):
        type_by_signal = dict([(self.state_arg_name, self._state_type)] + [(s, 'Bool') for s in model_inputs])
        tau_desc = FuncDescription(self._tau_name,
                                   type_by_signal,
                                   self._state_type,
                                   None)

        return tau_desc

    def get_proc_tau_additional_args(self, proc_label, sys_state_vector, proc_index):
        return dict()

    def get_architecture_trans_assumption(self, label, sys_state_vector):
        # ignore active_i
        # add assumption 'G(!(tok & prev))' #TODO: add on LTL level?

        proc_state = sys_state_vector[0]

        prev_dict, _ = build_signals_values([self._sends_prev_signal], label)
        prev_expr = prev_dict[self._sends_prev_signal]

        #: :type: FuncDescription
        tok_func = self.outvar_desc_by_process[0][self._has_tok_signal]

        tok_expr = call_func(tok_func, {self.state_arg_name: proc_state})

        tok_and_prev = op_and([tok_expr, prev_expr])

        not_and_tok_sends_prev = op_not(tok_and_prev)

        return not_and_tok_sends_prev

    def get_free_sched_vars(self, label):
        for signal in label.keys():
            assert not signal.name.startswith('sch')
        return []

    def filter_label_by_process(self, label, proc_index):
        assert proc_index == 0, str(proc_index)
        return label

    def _get_tok_rings_safety_props(self):
        smt_lines = StrAwareList()

        tau_desc = self.taus_descs[0]
        tau_signals = self.orig_inputs[0]

        tok_func_desc = self.outvar_desc_by_process[0][self._has_tok_signal]
        sends_func_desc = self.outvar_desc_by_process[0][self._sends_signal]

        prev_is_false_label = Label({self._sends_prev_signal: False})
        prev_is_true_label = Label({self._sends_prev_signal: True})

        states = self.states_by_process[0]
        for state in states:
            state_arg = {self.state_arg_name: state}

            has_tok_expr = call_func(tok_func_desc, state_arg)
            sends_tok_expr = call_func(sends_func_desc, state_arg)

            _, free_vars = build_signals_values(tau_signals, prev_is_false_label)

            nprev_arg, _ = build_signals_values(tau_signals, prev_is_false_label)
            nprev_state_arg = add_dicts(nprev_arg, state_arg)

            prev_arg, _ = build_signals_values(tau_signals, prev_is_true_label)
            prev_state_arg = add_dicts(prev_arg, state_arg)

            tau_nprev_expr = call_func(tau_desc, nprev_state_arg)
            tok_of_tau_nprev_expr = call_func(tok_func_desc, {self.state_arg_name: tau_nprev_expr})

            tau_prev_expr = call_func(tau_desc, prev_state_arg)
            tok_of_tau_prev_expr = call_func(tok_func_desc, {self.state_arg_name: tau_prev_expr})

            #
            tok_dont_disappear = forall_bool(free_vars,
                                             op_implies(op_and([has_tok_expr, op_not(sends_tok_expr)]),
                                                        tok_of_tau_nprev_expr))

            sends_with_token_only = forall_bool(free_vars,
                                                op_implies(sends_tok_expr, has_tok_expr))

            sends_means_release = forall_bool(free_vars,
                                              op_implies(sends_tok_expr, op_not(tok_of_tau_nprev_expr)))

            sends_prev_means_acquire = forall_bool(free_vars,
                                                   tok_of_tau_prev_expr)

            no_sends_prev_no_tok_means_no_next_tok = forall_bool(free_vars,
                                                                 op_implies(op_not(has_tok_expr),
                                                                            op_not(tok_of_tau_nprev_expr)))

            smt_lines += [tok_dont_disappear,
                          sends_with_token_only,
                          sends_means_release,
                          sends_prev_means_acquire,
                          no_sends_prev_no_tok_means_no_next_tok]

        return smt_lines

    def get_architecture_requirements(self):
        #TODO: 'One process only possesses the token initially' is added by ParImpl

        smt_lines = self._get_tok_rings_safety_props()

        return smt_lines
























