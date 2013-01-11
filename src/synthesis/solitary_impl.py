from synthesis.blank_impl import BlankImpl
from synthesis.func_description import FuncDescription

class SolitaryImpl(BlankImpl):
    def __init__(self, automaton, is_mealy, inputs, outputs, nof_local_states, sys_state_type):
        super().__init__(is_mealy)

        inputs = tuple(inputs)
        outputs = tuple(outputs)

        self._state_type = sys_state_type
        self._tau_name = 'tau'

        self.automaton = automaton
        self.nof_processes = 1

        self.states_by_process = [tuple(self._get_state_name(self._state_type, s)
                                        for s in range(nof_local_states))]
        self.state_types_by_process = [self._state_type]

        self.init_states = [(self.states_by_process[0][0],)]

        self.orig_inputs = [inputs]
        self.aux_func_descs_ordered = []

        self.outvar_desc_by_process = self._build_outvar_desc_by_process(outputs, inputs if is_mealy else ())

        self.taus_descs = self._get_taus_descs(inputs)
        self.model_taus_descs = self.taus_descs


    def _build_outvar_desc_by_process(self, outputs, inputs):
        descs = []
        for o in outputs:
            argname_to_type = {self.state_arg_name: self._state_type}
            if self.is_mealy:
                argname_to_type.update((input, 'Bool') for input in inputs)

            description = FuncDescription(str(o), argname_to_type, set(), 'Bool', None)

            descs.append((o, description))

        return tuple([descs])


    def _get_taus_descs(self, inputs):
        tau_desc = FuncDescription('tau',
            dict([(self.state_arg_name, self._state_type)] + list(map(lambda i: (str(i), 'Bool'), inputs))),
            set(),
            self._state_type,
            None)

        return [tau_desc]
