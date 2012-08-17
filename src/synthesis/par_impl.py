import math
from helpers.python_ext import bin_fixed_list, SmarterList, index_of
from interfaces.automata import Label
from parsing.en_rings_parser import anonymize_concr_var, concretize_anon_vars
from synthesis.smt_helper import call_func, op_and, get_bits_definition, make_assert, op_not


class ParImpl: #TODO: separate architecture from the spec
    def __init__(self, automaton, par_inputs, par_outputs, nof_processes,
                 nof_local_states,
                 sched_var_prefix, active_anon_var_name, sends_anon_var_name, sends_prev_anon_var_name, has_tok_var_prefix,
                 state_type):
        self.automaton = automaton

        self.nof_processes = nof_processes

        self._state_type = state_type
        self.proc_states_descs = self._create_proc_descs(nof_local_states)

        self._nof_bits = int(max(1, math.ceil(math.log(self.nof_processes, 2))))

        self._par_inputs = list(par_inputs)
        self._par_outputs = list(par_outputs)

        sends_prev_var_prefix = sends_prev_anon_var_name[:-1] #TODO: hack
        self.inputs = list(map(lambda i: concretize_anon_vars(filter(lambda input: not input.startswith(sends_prev_var_prefix), self._par_inputs), i), range(nof_processes)))
        self.outputs = list(map(lambda i: concretize_anon_vars(self._par_outputs, i), range(nof_processes)))

        self._tau_name = 'tau'
        self._is_active_name = 'is_active'
        self._equal_bits_name = 'equal_bits'
        self._equal_to_prev_name = 'equal_to_prev'
        self._tau_sched_wrapper_name = 'tau_sched_wrapper'

        self._sched_args, self._sched_args_def, self._sched_args_call = get_bits_definition('sch', self._nof_bits)
        self._proc_args, self._proc_args_def, self._proc_args_call = get_bits_definition('proc', self._nof_bits)

        self._sched_var_prefix = sched_var_prefix
        self._active_var_prefix = active_anon_var_name[:-1]
        self._sends_name = sends_anon_var_name
        self._has_tok_var_prefix = has_tok_var_prefix


    @property
    def aux_func_descs(self):
        """ Return func_name, input_types, output_type, body[optional]
        """
        return [self._get_desc_equal_bools(),
                self._get_desc_equal_to_prev(),
                self._get_desc_local_tau(),
                self._get_desc_is_active()]

    @property
    def outputs_descs(self):
        return [list(map(lambda o: (str(o), [('state', self._state_type)], 'Bool', None), self._par_outputs))]*self.nof_processes


    @property
    def taus_descs(self):
        return [self._get_desc_tau_sched_wrapper()]*self.nof_processes


    @property
    def model_taus_descs(self):
        return [self._get_desc_local_tau()]*self.nof_processes


    def get_proc_tau_additional_args(self, proc_label, sys_state_vector, proc_index):
        tau_args = SmarterList()

#        prev_proc = (proc_index - 1) % self.nof_processes
#        prev_proc_id_values = list(map(lambda b: str(b).lower(), bin_fixed_list(prev_proc, self._nof_bits)))

        sched_values = self._get_sched_values(proc_label)
#        sched_prev = call_func(self._equal_bits_name, sched_values+prev_proc_id_values)

        sends_prev = self._get_sends_prev_expr(proc_index, sys_state_vector)
#        modified_sends_prev = op_and([sends_prev, sched_prev])
        #        print(modified_sends_prev)

#        tau_args += [modified_sends_prev]
        tau_args += [sends_prev]

        tau_args += sched_values

        proc_id_values = list(map(lambda b: str(b).lower(), bin_fixed_list(proc_index, self._nof_bits)))
        tau_args += proc_id_values

        return tau_args


    def get_output_func_name(self, concr_var_name):
        par_var_name, proc_index = anonymize_concr_var(concr_var_name) #TODO: bad dependence on parser
        return par_var_name


    def get_architecture_trans_assumptions(self, label, sys_state_vector):
        var_names = list(label.keys())

        active_var_index = index_of(lambda concr_var_name: self._active_var_prefix in concr_var_name,
            var_names)

        if active_var_index is None:
            return ''

        concr_active_variable = var_names[active_var_index]
        _, proc_index = anonymize_concr_var(concr_active_variable)

        proc_id_args = list(map(lambda b: str(b).lower(), bin_fixed_list(proc_index, self._nof_bits)))

        sends_prev = self._get_sends_prev_expr(proc_index, sys_state_vector)

        sched_vals = self._get_sched_values(label)

        return call_func(self._is_active_name, proc_id_args + sched_vals + [sends_prev])


    def get_free_sched_vars(self, label):
        free_sched_vars = []
        sched_vars = list(map(lambda i: '{0}{1}'.format(self._sched_var_prefix, i), range(self._nof_bits)))
        for sched_var_name in sched_vars:
            if sched_var_name not in label:
                free_sched_vars.append('?{0}'.format(sched_var_name))

        return free_sched_vars


    def _get_desc_tau_sched_wrapper(self):
        input_args, input_args_def, input_args_call = get_bits_definition('in', len(self._par_inputs)-1) #-sends_prev

        body = """
(define-fun {tau_wrapper} ((state {state}) {inputs_def} (sends_prev Bool) {sched_def} {proc_def}) {state}
    (ite ({is_active} {sched} {proc} sends_prev) ({tau} state {inputs_call} sends_prev) state)
)
        """.format_map({'tau_wrapper':self._tau_sched_wrapper_name,
                        'tau': self._tau_name,
                        'sched_def': self._sched_args_def,
                        'proc_def': self._proc_args_def,
                        'sched': self._sched_args_call,
                        'proc': self._proc_args_call,
                        'inputs_call':input_args_call,
                        'inputs_def':input_args_def,
                        'state':self._state_type,
                        'is_active': self._is_active_name})

        return self._tau_sched_wrapper_name, \
               [self._state_type] + ['b', 'Bool']*(len(input_args) + 1 + len(self._sched_args) + len(self._proc_args)), \
               self._state_type, \
               body


        #NOTE
        # there are three cases:
        # 1. properties are local (each refer to one process)
        # 2. properties are not local but they are symmetric
        #    a) symmetric and talks about subset of processes
        #    b)                         ... all the processes
        # aside note1: for EN cases, for (i,i+1) it is enough to check (0,1) in the ring of (0,1,2)
        # but should we check it with different initial token distributions?
        # (which is equivalent to checking (0,1) and (1,2) and (2,0)
        #
        # aside note2: if properties are not symmetric and it is a parametrized case, then it is reduced to case (2)


    def _get_desc_equal_bools(self):
        first_args, first_args_def, first_args_call = get_bits_definition('x', self._nof_bits)
        second_args, second_args_def, second_args_call = get_bits_definition('y', self._nof_bits)

        cmp_stmnt = op_and(map(lambda p: '(= {0} {1})'.format(p[0],p[1]), zip(first_args, second_args)))

        body = """
    (define-fun {equal_bits} ({first_def} {second_def}) Bool
    {cmp}
    )
        """.format_map({'first_def': first_args_def,
                        'second_def': second_args_def,
                        'cmp': cmp_stmnt,
                        'equal_bits': self._equal_bits_name
        })

        return self._equal_bits_name, \
               list(map(lambda i: (str(i), 'Bool'), first_args)) + list(map(lambda i: (str(i), 'Bool'), second_args)), \
               'Bool', \
               body


    def _get_desc_is_active(self):
        body = """
(define-fun {is_active} ({sched_id_def} {proc_id_def} (sends_prev Bool)) Bool
    (or (and (not sends_prev) ({equal_bools} {sched_id} {proc_id})) (and sends_prev ({equal_prev} {sched_id} {proc_id})))
)
        """.format_map({'is_active': self._is_active_name,
                        'equal_bools':self._equal_bits_name,
                        'equal_prev': self._equal_to_prev_name,
                        'proc_id_def': self._proc_args_def,
                        'sched_id_def': self._sched_args_def,
                        'proc_id': self._proc_args_call,
                        'sched_id': self._sched_args_call
        })

        return self._is_active_name, \
               [('b', 'Bool')]*(len(self._proc_args) + len(self._sched_args) + 1), \
               'Bool', \
               body


    def _get_desc_equal_to_prev(self): #TODO: optimize
        enum_clauses = []
        def accumulator(prev_str, crt_str):
            enum_clauses.append('(and ({equals} {proc} {crt}) ({equals} {sched} {crt_prev}))'
            .format_map({'equals': self._equal_bits_name,
                         'sched': self._sched_args_call,
                         'proc': self._proc_args_call,
                         'crt':crt_str,
                         'crt_prev': prev_str}))


        self._ring_modulo_iterate(self.nof_processes, accumulator)

        body = """
(define-fun {equal_to_prev} ({sched_def} {proc_def}) Bool
(or {enum_clauses})
)
        """.format_map({'equal_to_prev': self._equal_to_prev_name,
                        'sched_def': self._sched_args_def,
                        'proc_def': self._proc_args_def,
                        'enum_clauses': '\n   '.join(enum_clauses)})

        return self._equal_to_prev_name, \
               ['b', 'Bool']*(len(self._sched_args)+len(self._proc_args)), \
               'Bool', \
               body


    def _ring_modulo_iterate(self, nof_processes, function):

        def to_smt_bools(int_val):
            return ' '.join(map(lambda b: str(b), bin_fixed_list(int_val, self._nof_bits))).lower()

        for crt in range(nof_processes):
            crt_str = to_smt_bools(crt)
            crt_prev_str = to_smt_bools((crt-1) % nof_processes)
            function(crt_prev_str, crt_str)


    def _get_desc_local_tau(self):
        return self._tau_name, \
               [('state', self._state_type)] + list(map(lambda i: (str(i), 'Bool'), self._par_inputs)), \
               self._state_type, \
               None


    #TODO: duplications
    def _get_sched_values(self, label):
        sched_vars = list(map(lambda i: '{0}{1}'.format(self._sched_var_prefix, i), range(self._nof_bits)))
        sched_values = []
        for sched_var_name in sched_vars:
            if sched_var_name in label:
                sched_value = str(label[sched_var_name]).lower()
                sched_values.append(sched_value)
            else:
                sched_value = '?{0}'.format(sched_var_name) #TODO: bad: sacral knowledge about format
                sched_values.append(sched_value)

        return sched_values


    def _get_sends_prev_expr(self, proc_index, sys_states_vector):
        prev_proc = (proc_index-1) % self.nof_processes

        prev_proc_state = sys_states_vector[prev_proc]

        return '({sends} {state})'.format_map({'sends': self._sends_name,
                                               'state': self.proc_states_descs[0][1][prev_proc_state]})


    def _create_proc_descs(self, nof_local_states):
        return list(map(lambda proc_i: (self._state_type, list(map(lambda s: self._state_type.lower()+str(s), range(nof_local_states)))),
                        range(self.nof_processes)))


    def filter_label_by_process(self, label, proc_index): #TODO: hack
        filtered_label = dict()

        for var_name, var_value in label.items():
            if var_name.startswith(self._sched_var_prefix):
                filtered_label[var_name] = var_value

            elif var_name.startswith(self._active_var_prefix):
                filtered_label[var_name] = var_value

            else:
                _, var_proc_index = anonymize_concr_var(var_name)
                if proc_index == var_proc_index:
                    filtered_label[var_name] = var_value

        return Label(filtered_label)


    def get_architecture_assertions(self):
        smt_lines = SmarterList()

        smt_lines += make_assert(call_func(self._has_tok_var_prefix, [self.proc_states_descs[0][1][self.init_states[0][0]]]))

        for i in range(1, self.nof_processes):
            smt_lines += make_assert(op_not(call_func(self._has_tok_var_prefix, [self.proc_states_descs[i][1][self.init_states[0][i]]])))

        return smt_lines


    @property
    def init_states(self):
        return [[1] + [0] * (self.nof_processes-1)]




