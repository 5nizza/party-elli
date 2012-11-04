from helpers.cached_property import cached_property
from synthesis.func_description import FuncDescription

class SolitaryImpl:
    def __init__(self, automaton, inputs, outputs, nof_local_states, sys_state_type):
        self.automaton = automaton

        self._state_type = sys_state_type
        self.nof_processes = 1
        self.proc_states_descs = self._create_proc_descs(nof_local_states)

        self.inputs = [inputs]
        self.orig_inputs = self.inputs

        self.outputs = [outputs]
        self.all_outputs = self.outputs

        self._tau_name = 'tau'

    @property
    def init_states(self):
        return [(0,)]

    @property
    def aux_func_descs(self):
        return []

    @property
    def outputs_descs(self):
        return [[FuncDescription(str(o), {'state': self._state_type}, set(), 'Bool', None) for o in self.outputs[0]]]
#        return [list(map(lambda o: (str(o), [('state', self._state_type)], 'Bool', None), *self.outputs))]


    @property
    def taus_descs(self):
        tau_desc = FuncDescription('tau',
            dict([('state', self._state_type)] + list(map(lambda i: (str(i), 'Bool'), self.inputs[0]))),
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
        return ''


    def get_free_sched_vars(self, label):
        return []



    def _create_proc_descs(self, nof_local_states):
        return list(map(lambda proc_i: (self._state_type, list(map(lambda s: 't'+str(s), range(nof_local_states)))),
                        range(self.nof_processes)))


    def filter_label_by_process(self, label, proc_index): #TODO: hack
        return label


    @property
    def init_state(self):
        return [[0]]

    def get_architecture_assertions(self):
        return []

    @cached_property
    def all_outputs_descs(self):
        descs = []
        for o in self.outputs[0]:
            argname_to_type = {'state': self._state_type}

            description = FuncDescription(str(o), argname_to_type, set(), 'Bool', None)

            descs.append(description)

        return [descs]


    def convert_global_argnames_to_proc_argnames(self, arg_values_dict):
        return arg_values_dict
