from synthesis.blank_impl import BlankImpl
from synthesis.func_description import FuncDescription

class SolitaryImpl(BlankImpl):
    def __init__(self, automaton, inputs, outputs, nof_local_states, sys_state_type):
        super().__init__()

        inputs = tuple(inputs)
        outputs = tuple(outputs)

        self._state_type = sys_state_type
        self._tau_name = 'tau'

        self.automaton = automaton
        self.nof_processes = 1

        self.states_by_process = [tuple(self._get_state_name(self._state_type, s)
                                        for s in range(nof_local_states))]
        self.state_types_by_process = [self._state_type]

        self.init_states = [self.states_by_process[0][0]]

        self.orig_inputs = [inputs]
        self.aux_func_descs = []

        self.outvar_desc_by_process = self._build_outvar_desc_by_process(outputs)

        self.taus_descs = self._get_taus_descs(inputs)
        self.model_taus_descs = self.taus_descs


    def _build_outvar_desc_by_process(self, outputs):
        descs = []
        for o in outputs:
            argname_to_type = {'state': self._state_type}

            description = FuncDescription(str(o), argname_to_type, set(), 'Bool', None)

            descs.append((o, description))

        return tuple([descs])


    def _get_taus_descs(self, inputs):
        tau_desc = FuncDescription('tau',
            dict([('state', self._state_type)] + list(map(lambda i: (str(i), 'Bool'), inputs))),
            set(),
            self._state_type,
            None)

        return [tau_desc]


#    def _get_proc_descs(self, nof_local_states):
#        result = [(self._state_type, ['t'+str(s) for s in range(nof_local_states)])] * self.nof_processes
#        return result

