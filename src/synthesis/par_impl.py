from itertools import permutations, chain
import math
from helpers.python_ext import bin_fixed_list, StrAwareList, index_of
from interfaces.automata import Label
from synthesis.blank_impl import BlankImpl
from synthesis.func_description import FuncDescription
from synthesis.smt_helper import call_func, op_and, get_bits_definition, op_not


class ParImpl(BlankImpl): #TODO: separate architecture from the spec
    def __init__(self, automaton,
                 is_mealy,
                 anon_inputs, anon_outputs, nof_processes, nof_local_states,
                 sched_var_prefix, active_anon_var_name,
                 sends_anon_var_name,
                 sends_prev_anon_var_name,
                 has_tok_var_prefix, state_type,
                 tau_name, internal_funcs_postfix):
        super().__init__(is_mealy)

        anon_inputs = list(anon_inputs)
        anon_outputs = list(anon_outputs)

        self._state_type = state_type
        self._prev_name = sends_prev_anon_var_name
        self._tau_name = tau_name
        self._is_active_name = 'is_active' + internal_funcs_postfix
        self._equal_bits_name = 'equal_bits' + internal_funcs_postfix
        self._prev_is_sched_name = 'prev_is_sched' + internal_funcs_postfix
        self._tau_sched_wrapper_name = 'tau_sch' + internal_funcs_postfix
        self._proc_id_prefix = 'proc'
        self._active_var_prefix = active_anon_var_name[:-1]
        self._sends_name = sends_anon_var_name
        self._has_tok_var_prefix = has_tok_var_prefix
        self._sched_var_prefix = sched_var_prefix

        self._nof_bits = int(max(1, math.ceil(math.log(nof_processes, 2))))
        self._sched_vars, self._sched_args_defs = get_bits_definition(self._sched_var_prefix, self._nof_bits)
        self._proc_vars, self._proc_args_defs = get_bits_definition(self._proc_id_prefix, self._nof_bits)
        self._equals_first_args, _ = get_bits_definition('x', self._nof_bits)
        self._equals_second_args, _ = get_bits_definition('y', self._nof_bits)

        self.automaton = automaton
        self.nof_processes = nof_processes

        self.states_by_process = [tuple([self._get_state_name(self._state_type, i) for i in range(nof_local_states)])]\
                                 * self.nof_processes
        self.state_types_by_process = [self._state_type] * self.nof_processes

        self.orig_inputs = self._build_orig_inputs(nof_processes, anon_inputs, sends_prev_anon_var_name)

        self.init_states = self._build_init_states()
        self.aux_func_descs = self._build_aux_func_descs()

        self.outvar_desc_by_process = self._build_outvar_desc_by_process(anon_outputs,
            sends_anon_var_name, has_tok_var_prefix,
            anon_inputs, nof_processes)

        self.taus_descs = self._build_taus_descs(anon_inputs)
        self.model_taus_descs = self._build_model_taus_descs(anon_inputs)


    def _build_outvar_desc_by_process(self, anon_outputs,
                                      sends_anon_var_name, has_tok_var_prefix,
                                      anon_inputs, nof_processes):
        all_var_desc = []
        for i in range(nof_processes):
            var_desc = []
            for o in anon_outputs:
                argname_to_type = {self.state_arg_name:self._state_type}
                if self.is_mealy and o not in (sends_anon_var_name, has_tok_var_prefix):
                    argname_to_type.update((i, 'Bool') for i in anon_inputs)

                description = FuncDescription(str(o), argname_to_type, set(), 'Bool', None)

                label_var = concretize_anon_var(o, i)
                var_desc.append((label_var, description))

            all_var_desc.append(tuple(var_desc))

        return tuple(all_var_desc)


    def _build_taus_descs(self, anon_inputs):
        return [self._get_desc_tau_sched_wrapper(anon_inputs)]*self.nof_processes


    def _build_orig_inputs(self, nof_processes, anon_inputs, prev_name):
        assert nof_processes >= 0

        if nof_processes > 1:
            inputs = [i for i in anon_inputs if input != prev_name]
        else: #case of async hub
            inputs = anon_inputs

        return [concretize_anon_vars(inputs, i) for i in range(nof_processes)]


    def _build_aux_func_descs(self):
        """ Return func_name, input_types, output_type, body[optional]
        """
        return [self._get_desc_equal_bools(),
                self._get_desc_prev_is_sched(),
                self._get_desc_is_active()]


    def _build_model_taus_descs(self, anon_inputs):
        return [self._get_desc_local_tau(anon_inputs)]*self.nof_processes


    def convert_global_args_to_local(self, arg_values_dict):
        # all tau desc accept anon values, they know nothing about concrete values
        # should they know? but they are 'local', they know nothing about global system
        anon_args_dict = dict()

        for argname, argvalue in arg_values_dict.items():
            if argname not in self._sched_vars \
               and argname not in self._proc_vars \
               and argname != self.state_arg_name:
                argname, _ = anonymize_concr_var(argname)
            anon_args_dict[argname] = argvalue

        return anon_args_dict


    def get_proc_tau_additional_args(self, proc_label, sys_state_vector, proc_index):
        tau_args = dict()

        sched_values = self._get_sched_values(proc_label)
        tau_args.update(sched_values)

        if self.nof_processes > 1:
            sends_prev = self._get_sends_prev_expr(proc_index, sys_state_vector)
            tau_args.update(sends_prev)

        proc_id_values = self._get_proc_id_values(proc_index)
        tau_args.update(proc_id_values)

        return tau_args


    def get_output_func_name(self, concr_var_name):
        par_var_name, proc_index = anonymize_concr_var(concr_var_name) #TODO: bad dependence on parser
        return par_var_name


    def get_architecture_trans_assumption(self, label, sys_state_vector):
        index_of_prev = index_of(lambda var_name: anonymize_concr_var(var_name)[0] == self._prev_name, label.keys())
        assert not (self.nof_processes > 1 and index_of_prev is not None), 'not implemented'

        var_names = list(label.keys())

        active_var_index = index_of(lambda concr_var_name: self._active_var_prefix in concr_var_name,
            var_names)

        if active_var_index is None:
            return ''

        concr_active_variable = var_names[active_var_index]
        _, proc_index = anonymize_concr_var(concr_active_variable)

        proc_id_args = self._get_proc_id_values(proc_index)
        if self.nof_processes > 1:
            sends_prev_value = self._get_sends_prev_expr(proc_index, sys_state_vector)
        else:
            prev = concretize_anon_var(self._prev_name, 0)
            sends_prev_value = {prev: str(label.get(prev, '?' + prev)).lower()} #TODO: hack: knowledge of format

        sched_vals = self._get_sched_values(label)

        is_active_concrt_args_dict = dict(chain(sched_vals.items(), proc_id_args.items(), sends_prev_value.items()))

        is_active_proc_args_dict = self.convert_global_args_to_local(is_active_concrt_args_dict)

        is_active_args = self._get_desc_is_active().get_args_list(is_active_proc_args_dict)

        func = call_func(self._is_active_name, is_active_args)

        return func


    def get_free_sched_vars(self, label):
        free_sched_vars = []
        sched_vars = list(map(lambda i: '{0}{1}'.format(self._sched_var_prefix, i), range(self._nof_bits)))
        for sched_var_name in sched_vars:
            if sched_var_name not in label:
                free_sched_vars.append('?{0}'.format(sched_var_name))

        return free_sched_vars


    def _get_desc_tau_sched_wrapper(self, anon_inputs):
        local_tau_inputs = self._get_desc_local_tau(anon_inputs).inputs

        argname_to_type = dict(local_tau_inputs + \
                               list(map(lambda sch_arg: (sch_arg, 'Bool'), self._sched_vars)) +\
                               list(map(lambda proc_arg: (proc_arg, 'Bool'), self._proc_vars)))

        local_tau_args = list(map(lambda input_type: input_type[0], local_tau_inputs))

        is_active_desc = self._get_desc_is_active()
        is_active_inputs = list(map(lambda input: input[0], is_active_desc.inputs)) #TODO: hack: knowledge: var names are the same

        body = """
        (ite ({is_active} {is_active_inputs}) ({tau} {local_tau_inputs}) {state})
        """.format_map({'tau': self._tau_name,
                        'local_tau_inputs': ' '.join(local_tau_args),
                        'state':self.state_arg_name,
                        'is_active': self._is_active_name,
                        'is_active_inputs': ' '.join(is_active_inputs)})

        architecture_inputs = set(chain([self._prev_name], self._sched_vars, self._proc_vars))

        description = FuncDescription(self._tau_sched_wrapper_name, argname_to_type, architecture_inputs,
            self._state_type,
            body)

        return description


    def _get_desc_equal_bools(self):
        cmp_stmnt = op_and(map(lambda p: '(= {0} {1})'.format(p[0],p[1]), zip(self._equals_first_args, self._equals_second_args)))

        body = """
        {cmp}
        """.format(cmp = cmp_stmnt)

        inputname_to_type = dict(list(map(lambda i: (str(i), 'Bool'), self._equals_first_args)) +\
                                 list(map(lambda i: (str(i), 'Bool'), self._equals_second_args)))

        description = FuncDescription(self._equal_bits_name,
            inputname_to_type, set(),
            'Bool',
            body)

        return description


    def _get_desc_is_active(self):
        argname_to_type = dict([(self._prev_name, 'Bool')] + self._sched_args_defs + self._proc_args_defs)

        sched_eq_proc_args_dict = self._get_equal_func_args(self._sched_vars, self._proc_vars)
        sched_eq_proc_args = self._get_desc_equal_bools().get_args_list(sched_eq_proc_args_dict)

        prev_is_sched_args = map(lambda var_type: var_type[0], self._get_desc_prev_is_sched().inputs) #order is important

        body = """
        (or (and (not {sends_prev}) ({equal_bits} {sched_eq_proc_args})) (and {sends_prev} ({prev_is_sched} {prev_is_sched_args})))
        """.format_map({'equal_bits':self._equal_bits_name,
                        'sched_eq_proc_args': ' '.join(sched_eq_proc_args),
                        'prev_is_sched': self._prev_is_sched_name,
                        'prev_is_sched_args': ' '.join(prev_is_sched_args),
                        'sends_prev': self._prev_name
        })

        description = FuncDescription(self._is_active_name,
            argname_to_type, set(),
            'Bool',
            body)

        return description


    def _get_equal_func_args(self, first_arg_values, second_arg_values):
        index_to_first_arg = dict(zip(map(lambda a: int(a[-1]), self._equals_first_args), self._equals_first_args))
        index_to_second_arg = dict(zip(map(lambda a: int(a[-1]), self._equals_second_args), self._equals_second_args))

        equal_func_args = dict()
        for i in range(len(first_arg_values)):
            equal_func_args[index_to_first_arg[i]] = first_arg_values[i]
            equal_func_args[index_to_second_arg[i]] = second_arg_values[i]
        return equal_func_args


    def _get_desc_prev_is_sched(self): #TODO: optimize
        enum_clauses = []

        def accumulator(prev, crt):
            equal_bits_desc = self._get_desc_equal_bools()

            proc_eq_crt_args_dict = self._get_equal_func_args(self._proc_vars, crt)
            sched_eq_prev_args_dict = self._get_equal_func_args(self._sched_vars, prev)

            proc_eq_crt_args = equal_bits_desc.get_args_list(proc_eq_crt_args_dict)
            sched_eq_prev_args = equal_bits_desc.get_args_list(sched_eq_prev_args_dict)

            enum_clauses.append('(and ({equals} {proc_eq_crt}) ({equals} {sched_eq_prev}))'
            .format_map({'equals': self._equal_bits_name,
                         'proc_eq_crt': ' '.join(proc_eq_crt_args),
                         'sched_eq_prev': ' '.join(sched_eq_prev_args)
            }))


        self._ring_modulo_iterate(self.nof_processes, accumulator)

        argname_to_type = dict(self._sched_args_defs + self._proc_args_defs)

        body = """(or {enum_clauses})""".format(enum_clauses = '\n\t'.join(enum_clauses))

        description = FuncDescription(self._prev_is_sched_name,
            argname_to_type, set(),
            'Bool',
            body)

        return description


    def _ring_modulo_iterate(self, nof_processes, function):

        def to_smt_bools(int_val):
            return list(map(lambda b: str(b).lower(), bin_fixed_list(int_val, self._nof_bits)))

        if nof_processes == 1:
            crt = to_smt_bools(0)
            prev = to_smt_bools(1)
            function(prev, crt)
            return

        for crt_index in range(nof_processes):
            crt = to_smt_bools(crt_index)
            prev = to_smt_bools((crt_index-1) % nof_processes)
            function(prev, crt)


    def _get_desc_local_tau(self, anon_inputs):
        argname_to_type = dict([(self.state_arg_name, self._state_type)] + \
                               list(map(lambda input: (str(input), 'Bool'), anon_inputs)))

        description = FuncDescription(self._tau_name, argname_to_type, set(), self._state_type, None)

        return description

    #TODO: duplications
    def _get_sched_values(self, label):
        sched_values = dict()
        for sched_var_name in self._sched_vars:
            if sched_var_name in label:
                sched_value = str(label[sched_var_name]).lower()
                sched_values[sched_var_name] = sched_value
            else:
                sched_value = '?{0}'.format(sched_var_name) #TODO: bad: sacral knowledge about format
                sched_values[sched_var_name] = sched_value

        return sched_values

    def _get_proc_id_values(self, proc_index):
        bits_list = bin_fixed_list(proc_index, self._nof_bits)
        bits_vals_as_str_list = list(map(lambda b: str(b).lower(), bits_list))
        bits_dict = dict(zip(self._proc_vars, bits_vals_as_str_list))

        return bits_dict


    def _get_sends_prev_expr(self, proc_index, sys_states_vector):
        assert self.nof_processes > 1, 'nonsense'

        prev_proc = (proc_index-1) % self.nof_processes

        prev_proc_state = sys_states_vector[prev_proc]

        expr = '({sends} {state})'.format_map({'sends': self._sends_name,
                                               'state': prev_proc_state})

        return {concretize_anon_var(self._prev_name, proc_index): expr} #TODO: bad reversed dependence


    def filter_label_by_process(self, label, proc_index): #TODO: hack
        filtered_label = dict()

        for var_name, var_value in label.items():
            if var_name.startswith(self._sched_var_prefix): #TODO: use Signal instead of these hacks
                filtered_label[var_name] = var_value

            elif var_name.startswith(self._active_var_prefix):
                filtered_label[var_name] = var_value

            else:
                _, var_proc_index = anonymize_concr_var(var_name)
                if proc_index == var_proc_index:
                    filtered_label[var_name] = var_value

        return Label(filtered_label)


    def get_architecture_conditions(self):
        conditions = StrAwareList()

        #first process possesses the token, others - don't
        #consider the only init state - others are isomorphic and don't add to the conditions

        state_by_proc = self.init_states[0]

        #TODO: hack - don't use get_args
        conditions += call_func(self._has_tok_var_prefix, [state_by_proc[0]])

        if self.nof_processes > 1:
            conditions += op_not(call_func(self._has_tok_var_prefix, [state_by_proc[1]]))

        return conditions


    def _build_init_states(self):
        #TODO: hardcoded: state 0 no tok, state 1 tok

        states = self.states_by_process[0]
        if self.nof_processes == 1:
            return [(states[1],), (states[0],)] #TODO: the order matters

        init_sys_state = [states[1]] + [states[0]] * (self.nof_processes-1) #states of all processes are the same
        permutations_of_init_state = list(permutations(init_sys_state))

        result = []
        for sys_state in permutations_of_init_state:
            result.append(sys_state)

        return result

