from helpers.python_ext import SmarterList
from interfaces.automata import Label
from parsing.en_rings_parser import concretize, parametrize, concretize_var
from synthesis.generic_smt_encoder import GenericEncoder
from synthesis.smt_helper import op_and, call_func, op_not, op_implies, forall_bool, build_values_from_label, make_assert

class LocalENImpl:
    def __init__(self, automaton, par_inputs, par_outputs, nof_local_states, sys_state_type,
                 has_tok_var_name,
                 sends_var_name,
                 sends_prev_var_name,
                 init_state):
        self.automaton = automaton

        self._state_type = sys_state_type
        self.nof_processes = 1
        self.proc_states_descs = self._create_proc_descs(nof_local_states)

        self._nof_local_states = nof_local_states

        self._par_inputs = list(par_inputs)
        self._par_outputs = list(par_outputs)

        self.inputs = [concretize(self._par_inputs, 0)]
        self.outputs = [concretize(self._par_outputs, 0)]

        self._tau_name = 'tau'
        self._has_tok_var_prefix = has_tok_var_name
        self._sends_prev_var_name = sends_prev_var_name
        self._init_state = init_state
        self._sends_var_name = sends_var_name

    @property
    def aux_func_descs(self):
        return []

    @property
    def outputs_descs(self):
        assert False, 'not implemented'

    @property
    def taus_descs(self):
        return [(self._tau_name, [('state', self._state_type)] + list(map(lambda i: (str(i), 'Bool'), self._par_inputs[0])),
                 self._state_type, None)]

    @property
    def model_taus_descs(self):
        return self.taus_descs


    def get_proc_tau_additional_args(self, proc_label, sys_state_vector, proc_index):
        return []


    def get_output_func_name(self, concr_var_name):
        return parametrize(concr_var_name)[0]


    def get_architecture_assumptions(self, label, sys_state_vector):
        not_ = op_not(op_and([call_func(self._has_tok_var_prefix, [self.proc_states_descs[0][1][sys_state_vector[0]]]),
                             '?{0}'.format(concretize_var(self._sends_prev_var_name, 0))])) #TODO: hack?
        return not_


    def get_free_sched_vars(self, label):
        return []


    def _create_proc_descs(self, nof_local_states):
        return list(map(lambda proc_i: (self._state_type, list(map(lambda s: self._state_type.lower()+str(s), range(nof_local_states)))),
                        range(self.nof_processes)))


    def filter_label_by_process(self, label, proc_index):
        assert proc_index == 0, str(proc_index)
        return label

    @property
    def init_state(self):
        return [self._init_state] #should be the same as in ParImpl process with the token


    def _get_tok_rings_safety_props(self):
        smt_lines = SmarterList()
        for state in range(self._nof_local_states):
            state_str = self.proc_states_descs[0][1][state]

            has_tok_str = call_func(self._has_tok_var_prefix, [state_str])
            sends_tok_str = call_func(self._sends_var_name, [state_str])

            tau_args, free_vars = build_values_from_label(self._par_inputs, Label({self._sends_prev_var_name:False}))

            next_state_str = call_func(self.taus_descs[0][0], [state_str] + tau_args)
            next_tok_str = call_func(self._has_tok_var_prefix, [next_state_str])

            #tok_dont_disappear = 'G(({tok}i && !{sends}i) -> X{tok}i)'
            smt_lines += make_assert(forall_bool(free_vars, op_implies(op_and([has_tok_str, op_not(sends_tok_str)]), next_tok_str)))
            #sends_with_token_only = "G({sends}i -> {tok}i)"
#            smt_lines += make_assert(forall_bool(free_vars, op_implies(sends_tok_str, has_tok_str)))

        return smt_lines


    def get_architecture_assertions(self):
#        return []
        smt_lines = self._get_tok_rings_safety_props()

        return smt_lines






















