from helpers.cached_property import cached_property
from synthesis.blank_impl import BlankImpl
from synthesis.func_description import FuncDescription

class SolitaryImpl(BlankImpl):
    def __init__(self, automaton, inputs, outputs, nof_local_states, sys_state_type):
        super().__init__()

        self._state_type = sys_state_type
        self._tau_name = 'tau'


        self.automaton = automaton
        self.nof_processes = 1
        self.init_states = [(0,)]
        self.proc_states_descs = self._get_proc_descs(nof_local_states)

        self.inputs = [inputs]
        self.orig_inputs = self.inputs

        self.outputs = [outputs]
        self.all_outputs = self.outputs

        self.aux_func_descs = []

        self.outputs_descs = [[FuncDescription(str(o), {'state': self._state_type}, set(), 'Bool', None) for o in self.outputs[0]]]
        self.all_outputs_descs = self._get_all_outputs_descs()

        self.taus_descs = self._get_taus_descs()
        self.model_taus_descs = self.taus_descs


    def _get_all_outputs_descs(self):
        descs = []
        for o in self.outputs[0]:
            argname_to_type = {'state': self._state_type}

            description = FuncDescription(str(o), argname_to_type, set(), 'Bool', None)

            descs.append(description)

        return [descs]

    def _get_taus_descs(self):
        tau_desc = FuncDescription('tau',
            dict([('state', self._state_type)] + list(map(lambda i: (str(i), 'Bool'), self.inputs[0]))),
            set(),
            self._state_type,
            None)

        return [tau_desc]

    def _get_proc_descs(self, nof_local_states):
        return list(map(lambda proc_i: (self._state_type, list(map(lambda s: 't'+str(s), range(nof_local_states)))),
            range(self.nof_processes)))
