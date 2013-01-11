class BlankImpl:
    """ Blank implementation which does nothing but still can be fed to GenericEncoder """

    def __init__(self, is_mealy):
        self.is_mealy = is_mealy

        self.state_arg_name = 'state'

        self.automaton = None

        self.nof_processes = 0

        #TODO: rename -- orig_inputs are model_inputs
        #TODO: remove at all -- better to use 'tau_model_args' from taus_desc?
        self.orig_inputs = ()

        self.init_states = ()
        self.aux_func_descs_ordered = ()

        self.outvar_desc_by_process = (dict(),) # ({signal:func_desc}, ..)

        self.taus_descs = ()
        self.model_taus_descs = ()

        self.states_by_process = ()
        self.state_types_by_process = ()


    def _get_state_name(self, state_type:str, state_number:int):
        return '{type_lower}{number}'.format(type_lower=state_type.lower(), number=str(state_number))


    def get_outputs_descs(self):
        result = []
        for proc_record in self.outvar_desc_by_process:
            proc_descs = []
            for var, desc in proc_record.items():
                proc_descs.append(desc)
            result.append(tuple(proc_descs))

        return tuple(result)


    def get_proc_tau_additional_args(self, proc_label, sys_state_vector, proc_index):
        return dict()


#    def get_output_func_name(self, concr_var_name):
#        return concr_var_name


    def filter_label_by_process(self, label, proc_index): #TODO: hack
        return label


    def get_free_sched_vars(self, label):
        return tuple()


    def get_architecture_trans_assumption(self, label, sys_state_vector):
        return ''


    def get_architecture_requirements(self):
        return tuple()

