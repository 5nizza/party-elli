class SolitaryImpl:
    def __init__(self, automaton, inputs, outputs, nof_local_states):
        self.automaton = automaton

        self._state_type = 'LS'
        self.nof_processes = 1
        self.proc_states_descs = self._create_proc_descs(nof_local_states)

        self.inputs = [inputs]
        self.outputs = [outputs]

        self._tau_name = 'tau'

    @property
    def aux_func_descs(self):
        return []

    @property
    def outputs_descs(self):
        return [list(map(lambda o: (str(o), [('state', self._state_type)], 'Bool', None), *self.outputs))]


    @property
    def taus_descs(self):
        return [(self._tau_name, [('state', self._state_type)] + list(map(lambda i: (str(i), 'Bool'), self.inputs[0])),
                 self._state_type, None)]

    @property
    def model_taus_descs(self):
        return self.taus_descs

    def get_proc_tau_additional_args(self, proc_label, sys_state_vector, proc_index):
        return []


    def get_output_func_name(self, concr_var_name):
        return concr_var_name


    def get_architecture_assumptions(self, label, sys_state_vector):
        return ''


    def get_free_sched_vars(self, label):
        return []



    def _create_proc_descs(self, nof_local_states):
        return list(map(lambda proc_i: (self._state_type, list(map(lambda s: 't'+str(s), range(nof_local_states)))),
                        range(self.nof_processes)))


    def filter_label_by_process(self, label, proc_index): #TODO: hack
        return label


