from itertools import permutations, chain
import math
from helpers.python_ext import bin_fixed_list, StrAwareList, index_of
from interfaces.automata import Label
from parsing.en_rings_parser import anonymize_concr_var, concretize_anon_vars, parametrize_anon_var, concretize_anon_var
from synthesis.func_description import FuncDescription
from synthesis.smt_helper import call_func, op_and, get_bits_definition, make_assert, op_not


class ParImpl: #TODO: separate architecture from the spec
    def __init__(self, automaton, anon_inputs, anon_outputs, nof_processes,
                 nof_local_states,
                 sched_var_prefix, active_anon_var_name, sends_anon_var_name, sends_prev_anon_var_name, has_tok_var_prefix,
                 state_type,
                 tau_name,
                 internal_funcs_postfix):
        self.automaton = automaton

        self.nof_processes = nof_processes

        self._state_type = state_type
        self.proc_states_descs = self._create_proc_descs(nof_local_states)

        self._nof_bits = int(max(1, math.ceil(math.log(self.nof_processes, 2))))

        self._prev_name = sends_prev_anon_var_name

        self._anon_inputs = list(anon_inputs)
        self.all_inputs = list(map(lambda i: concretize_anon_vars(self._anon_inputs, i), range(nof_processes)))
        self.orig_inputs = list(map(lambda i: concretize_anon_vars(filter(lambda input: input != sends_prev_anon_var_name, self._anon_inputs), i), range(nof_processes)))

        self._anon_outputs = list(anon_outputs)
        self.all_outputs = list(map(lambda i: concretize_anon_vars(self._anon_outputs, i), range(nof_processes)))
        self.orig_outputs = list(map(lambda i: concretize_anon_vars(filter(lambda out: out not in [has_tok_var_prefix, sends_anon_var_name], self._anon_outputs), i), range(nof_processes)))

        self._tau_name = tau_name
        self._is_active_name = 'is_active'+internal_funcs_postfix
        self._equal_bits_name = 'equal_bits'+internal_funcs_postfix
        self._equal_to_prev_name = 'equal_to_prev'+internal_funcs_postfix
        self._tau_sched_wrapper_name = 'tau_sch'+internal_funcs_postfix

        self._proc_id_prefix = 'proc'
        self._active_var_prefix = active_anon_var_name[:-1]
        self._sends_name = sends_anon_var_name
        self._has_tok_var_prefix = has_tok_var_prefix

        self._sched_var_prefix = sched_var_prefix
        self._sched_vars, self._sched_args_defs = get_bits_definition(self._sched_var_prefix, self._nof_bits)
        self._proc_vars, self._proc_args_defs = get_bits_definition(self._proc_id_prefix, self._nof_bits)


    @property
    def aux_func_descs(self):
        """ Return func_name, input_types, output_type, body[optional]
        """
        return [self._get_desc_equal_bools(),
                self._get_desc_equal_to_prev(),
                self._get_desc_is_active()]

    @property
    def all_outputs_descs(self):
        descs = []
        for o in self._anon_outputs:
            argname_to_type = {'state': self._state_type}

            description = FuncDescription(str(o), argname_to_type, set(), 'Bool', None)

            descs.append(description)

        return [descs]*self.nof_processes


    @property
    def taus_descs(self):
        return [self._get_desc_tau_sched_wrapper()]*self.nof_processes


    @property
    def model_taus_descs(self):
        return [self._get_desc_local_tau()]*self.nof_processes


    def convert_global_argnames_to_proc_argnames(self, arg_values_dict):
        # all tau desc accept anon values, they know nothing about concrete values
        # should they know? but they are 'local', they know nothing about global system
        anon_args_dict = dict()

#        print('pi 164 ', arg_values_dict)
        for argname, argvalue in arg_values_dict.items():
            if argname not in self._sched_vars and argname != 'state' and argname not in self._proc_vars: #todo: hack: state
                argname, _ = anonymize_concr_var(argname)
            anon_args_dict[argname] = argvalue

#        print('pi 170 ', anon_args_dict)
        return anon_args_dict


    def get_proc_tau_additional_args(self, proc_label, sys_state_vector, proc_index):
        tau_args = dict()

        sched_values = self._get_sched_values(proc_label)
        tau_args.update(sched_values)

        sends_prev = self._get_sends_prev_expr(proc_index, sys_state_vector)
        tau_args.update(sends_prev)

        proc_id_values = self._get_proc_id_values(proc_index)
        tau_args.update(proc_id_values)

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

        proc_id_args = self._get_proc_id_values(proc_index)
        sends_prev = self._get_sends_prev_expr(proc_index, sys_state_vector)
        sched_vals = self._get_sched_values(label)

        is_active_concrt_args_dict = dict(chain(sched_vals.items(), proc_id_args.items(), sends_prev.items()))

        is_active_proc_args_dict = self.convert_global_argnames_to_proc_argnames(is_active_concrt_args_dict)

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


    def _get_desc_tau_sched_wrapper(self):
        state_var_name = 'state'

        local_tau_inputs = self._get_desc_local_tau().inputs

        argname_to_type = dict(local_tau_inputs + \
                               list(map(lambda sch_arg: (sch_arg, 'Bool'), self._sched_vars)) +\
                               list(map(lambda proc_arg: (proc_arg, 'Bool'), self._proc_vars)))

        local_tau_args = list(map(lambda input_type: input_type[0], local_tau_inputs))

        is_active_desc = self._get_desc_is_active()
        is_active_inputs = list(map(lambda input: input[0], is_active_desc.inputs)) #TODO: hack: knowledge about var names

#        print(is_active_desc)
#        print(argname_to_type)
#
#        print(tau_args)
#        assert 0

        body = """
        (ite ({is_active} {is_active_inputs}) ({tau} {local_tau_inputs}) {state})
        """.format_map({'tau': self._tau_name,
                        'local_tau_inputs': ' '.join(local_tau_args),
                        'state':state_var_name,
                        'is_active': self._is_active_name,
                        'is_active_inputs': ' '.join(is_active_inputs)})

        architecture_inputs = set(chain([self._prev_name], self._sched_vars, self._proc_vars))

        description = FuncDescription(self._tau_sched_wrapper_name, argname_to_type, architecture_inputs,
            self._state_type,
            body)

#        print(description)
#        assert 0

        return description

#        return self._tau_sched_wrapper_name, \
#               [self._state_type] + ['b', 'Bool']*(len(input_args) + 1 + len(self._sched_args) + len(self._proc_args)), \
#               self._state_type, \
#               body


    def _get_desc_equal_bools(self):
        first_args, _ = get_bits_definition('x', self._nof_bits)
        second_args, _= get_bits_definition('y', self._nof_bits)

        cmp_stmnt = op_and(map(lambda p: '(= {0} {1})'.format(p[0],p[1]), zip(first_args, second_args)))

        body = """
        {cmp}
        """.format(cmp = cmp_stmnt)

        inputname_to_type = dict(list(map(lambda i: (str(i), 'Bool'), first_args)) +\
                                 list(map(lambda i: (str(i), 'Bool'), second_args)))

        description = FuncDescription(self._equal_bits_name,
            inputname_to_type, set(),
            'Bool',
            body)

        return description

#        return self._equal_bits_name, \
#               list(map(lambda i: (str(i), 'Bool'), first_args)) + list(map(lambda i: (str(i), 'Bool'), second_args)), \
#               'Bool', \
#               body

    #do not change order of variables!
    def _get_desc_is_active(self):
        body = """
        (or (and (not {sends_prev}) ({equal_bools} {sched_id} {proc_id})) (and {sends_prev} ({equal_prev} {sched_id} {proc_id})))
        """.format_map({'equal_bools':self._equal_bits_name,
                        'equal_prev': self._equal_to_prev_name,
                        'proc_id': ' '.join(self._proc_vars),
                        'sched_id': ' '.join(self._sched_vars),
                        'sends_prev': self._prev_name
        })

        argname_to_type = dict([(self._prev_name, 'Bool')] + self._sched_args_defs + self._proc_args_defs)
        description = FuncDescription(self._is_active_name,
            argname_to_type, set(), #TODO: is set() a bug?
            'Bool',
            body)

#        print(description)
#        assert 0
        return description

#        return self._is_active_name, \
#               [('b', 'Bool')]*(len(self._proc_args) + len(self._sched_args) + 1), \
#               'Bool', \
#               body


    def _get_desc_equal_to_prev(self): #TODO: optimize
        enum_clauses = []
        def accumulator(prev_str, crt_str):
            enum_clauses.append('(and ({equals} {proc} {crt}) ({equals} {sched} {crt_prev}))'
            .format_map({'equals': self._equal_bits_name,
                         'sched': ' '.join(self._sched_vars),
                         'proc': ' '.join(self._proc_vars),
                         'crt':crt_str,
                         'crt_prev': prev_str}))

        self._ring_modulo_iterate(self.nof_processes, accumulator)

        argname_to_type = dict(self._sched_args_defs + self._proc_args_defs)

        body = """(or {enum_clauses})""".format(enum_clauses = '\n\t'.join(enum_clauses))

        description = FuncDescription(self._equal_to_prev_name,
            argname_to_type, set(),
            'Bool',
            body)

        return description

#        return self._equal_to_prev_name, \
#               ['b', 'Bool']*(len(self._sched_args)+len(self._proc_args)), \
#               'Bool', \
#               body


    def _ring_modulo_iterate(self, nof_processes, function):

        def to_smt_bools(int_val):
            return ' '.join(map(lambda b: str(b), bin_fixed_list(int_val, self._nof_bits))).lower()

        if nof_processes == 1:
            crt_str = to_smt_bools(0)
            prev_str = to_smt_bools(1)
            function(prev_str, crt_str)
            return

        for crt in range(nof_processes):
            crt_str = to_smt_bools(crt)
            prev_str = to_smt_bools((crt-1) % nof_processes)
            function(prev_str, crt_str)


    def _get_desc_local_tau(self):
        argname_to_type = dict([('state', self._state_type)] + \
                               list(map(lambda input: (str(input), 'Bool'), self._anon_inputs)))

        description = FuncDescription(self._tau_name, argname_to_type, set(), self._state_type, None)
        return description
#        return self._tau_name, \
#               [('state', self._state_type)] + list(map(lambda i: (str(i), 'Bool'), self._anon_inputs)), \
#               self._state_type, \
#               None

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
        prev_proc = (proc_index-1) % self.nof_processes

        prev_proc_state = sys_states_vector[prev_proc]

        expr = '({sends} {state})'.format_map({'sends': self._sends_name,
                                               'state': self.proc_states_descs[0][1][prev_proc_state]})

        return {concretize_anon_var(self._prev_name, proc_index): expr} #TODO: bad reversed dependence


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
        smt_lines = StrAwareList()

        #TODO: hack: why does the order matter?
        smt_lines += make_assert(call_func(self._has_tok_var_prefix, [self.proc_states_descs[0][1][self.init_states[0][0]]]))

        for i in range(1, self.nof_processes):
            smt_lines += make_assert(op_not(call_func(self._has_tok_var_prefix, [self.proc_states_descs[i][1][self.init_states[0][i]]])))

        return smt_lines


    @property
    def init_states(self):
        #TODO: hardcoded knowledge: state 0 no tok, state 1 tok

        if len(self.proc_states_descs) == 1:
            return [(1,), (0,)] #TODO: the order matters

        init_sys_state = [1] + [0] * (self.nof_processes-1)
        permutations_of_init_state = list(permutations(init_sys_state))

        result = []
        for sys_state in permutations_of_init_state:
            result.append(sys_state)

        return result




