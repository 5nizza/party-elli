class BlankImpl:
    """ Blank implementation which does nothing but still can be fed to GenericEncoder """

    def __init__(self):
        self.automaton = None

        self.nof_processes = 0

        self.proc_states_descs = []

#        self.inputs = [[]]
        self.orig_inputs = []

        self.init_states = []
        self.aux_func_descs = []

        self.all_outputs = [[]]
        self.all_outputs_descs = [[]]

        self.taus_descs = []
        self.model_taus_descs = []



    def get_proc_tau_additional_args(self, proc_label, sys_state_vector, proc_index):
        return dict()

    def get_output_func_name(self, concr_var_name):
        return concr_var_name

    def filter_label_by_process(self, label, proc_index): #TODO: hack
        return label

    def get_free_sched_vars(self, label):
        return []

    def get_architecture_trans_assumption(self, label, sys_state_vector):
        return ''

    def get_architecture_conditions(self):
        return []

    def convert_global_argnames_to_proc_argnames(self, arg_values_dict):
        return arg_values_dict
