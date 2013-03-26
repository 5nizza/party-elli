from itertools import permutations
from helpers.python_ext import bin_fixed_list, StrAwareList, index_of, add_dicts, lmap
from interfaces.automata import Label, Automaton
from interfaces.parser_expr import QuantifiedSignal
from parsing.helpers import get_log_bits
from synthesis.blank_impl import BlankImpl
from synthesis.func_description import FuncDescription
from synthesis.smt_helper import op_and, op_not, build_signals_values, call_func


def get_signals_definition(signal_base_name, nof_bits):
    signals = list(map(lambda i: QuantifiedSignal(signal_base_name, i), range(nof_bits)))
    args_defs = list(map(lambda s: (s, 'Bool'), signals))
    return signals, args_defs


def _is_signal_for_index(signal:QuantifiedSignal, index:int) -> bool:
    assert len(signal.binding_indices) == 1

    signal_index = signal.binding_indices[0]
    return signal_index == index


def _filter_by_proc(i, signals) -> list:
    filtered = list(filter(lambda s: s.binding_indices[0] == i, signals))
    return filtered


def _build_model_inputs(nof_processes:int, model_inputs) -> list:
    model_inputs_by_process = dict()
    for i in range(nof_processes):
        proc_signals = list(filter(lambda s: _is_signal_for_index(s, i), model_inputs))
        model_inputs_by_process[i] = proc_signals

    return model_inputs_by_process


class ParImpl(BlankImpl):  # TODO: separate architecture from the spec
    def __init__(self, automaton:Automaton,
                 is_mealy:bool,
                 orig_inputs, orig_outputs,
                 nof_processes:int,
                 nof_local_states:int,
                 sched_inputs,
                 is_active_signals,
                 sends_signals,
                 sends_prev_signals,
                 #sends_prev is input signals, sends_signals are output, though essentially they are the same
                 has_tok_signals,  # it is part of the state, but can be emulated as Moore-like output signal
                 state_type,
                 tau_name,
                 internal_funcs_postfix:str):

        super().__init__(is_mealy)

        for s in orig_inputs:  # TODO: remove me after debug
            assert isinstance(s, QuantifiedSignal)
            assert 'prev' not in s.name, str(s)

        for s in orig_outputs:  # TODO: remove me after debug
            assert isinstance(s, QuantifiedSignal)
            assert 'prev' not in s.name, str(s)
            assert 'tok' not in s.name, str(s)

        self.automaton = automaton
        self.nof_processes = nof_processes

        self._state_type = state_type

        self._has_tok_signals = has_tok_signals
        self._sends_prev_signals = sends_prev_signals
        self._sends_signals = sends_signals
        self._is_active_signals = is_active_signals

        self._TAU_NAME = tau_name
        self._IS_ACTIVE_NAME = 'is_active' + internal_funcs_postfix
        self._EQUAL_BITS_NAME = 'equal_bits' + internal_funcs_postfix
        self._PREV_IS_SCHED_NAME = 'prev_is_sched' + internal_funcs_postfix
        self._TAU_SCHED_WRAPPER_NAME = 'tau_sch' + internal_funcs_postfix
        self._PROC_ID_PREFIX = 'proc'  # TODO: check necessity

        self._nof_proc_bits = get_log_bits(nof_processes)

        self._sched_signals = sched_inputs  # TODO: check necessity
        self._sched_arg_type_pairs = [(s, 'Bool') for s in self._sched_signals]

        #intoduced proc_signals to resemble sched_signals
        self._proc_signals = [QuantifiedSignal(self._PROC_ID_PREFIX, i) for i in range(get_log_bits(nof_processes))]
        self._proc_arg_type_pairs = [(s, 'Bool') for s in self._proc_signals]

        self._equals_first_args, _ = get_signals_definition('x', self._nof_proc_bits)
        self._equals_second_args, _ = get_signals_definition('y', self._nof_proc_bits)

        ### BlankImpl interface TODO: use __init__ with arguments?
        self.states_by_process = self.nof_processes * [
            tuple(self.get_state_name(self._state_type, i) for i in range(nof_local_states))]
        self.state_types_by_process = self.nof_processes * [self._state_type]

        archi_inputs = sends_prev_signals
        archi_outputs = has_tok_signals + sends_signals

        all_models_inputs = orig_inputs + archi_inputs
        #TODO: rename to self.model_inputs
        self.orig_inputs = _build_model_inputs(nof_processes, all_models_inputs)

        self.init_states = self._build_init_states()
        self.aux_func_descs_ordered = self._build_aux_func_descs()

        self.outvar_desc_by_process = [self._build_desc_by_out(_filter_by_proc(i, orig_outputs),
                                                               _filter_by_proc(i, archi_outputs),
                                                               _filter_by_proc(i, all_models_inputs))
                                       for i in range(nof_processes)]

        self.taus_descs = self._build_taus_descs(all_models_inputs)
        self.model_taus_descs = self._build_model_taus_descs(all_models_inputs)

    def _do_desc_by_out(self, out_signals, is_mealy:bool, model_inputs) -> dict:
        desc_by_signal = dict()

        for s_ in out_signals:
            #: :type: QuantifiedSignal
            s = s_

            type_by_arg = {self.state_arg_name: self._state_type}

            if is_mealy:
                type_by_arg.update((s, 'Bool') for s in model_inputs)

            desc_by_signal[s] = FuncDescription(s.name, type_by_arg, 'Bool', None)

        return desc_by_signal

    def _build_desc_by_out(self,
                           proc_orig_outputs, proc_archi_outputs,
                           proc_model_inputs) -> dict:

        desc_by_signal = self._do_desc_by_out(proc_orig_outputs, self.is_mealy, proc_model_inputs)
        #architecture outputs are Moore
        desc_by_signal.update(self._do_desc_by_out(proc_archi_outputs, False, proc_model_inputs))

        return desc_by_signal

    def _build_taus_descs(self, all_models_inputs):
        return [self._get_desc_tau_sched_wrapper(i, all_models_inputs)
                for i in range(self.nof_processes)]

    def _build_aux_func_descs(self):
        return [self._get_desc_equal_bools(),
                self._get_desc_prev_is_sched(),
                self._get_desc_is_active(0)]  # TODO: hack: here proc_index does not matter

    def _build_model_taus_descs(self, all_models_input_signals):
        return [self._get_desc_local_tau(_filter_by_proc(i, all_models_input_signals))
                for i in range(self.nof_processes)]

    def get_proc_tau_additional_args(self, proc_label:Label, sys_state_vector, proc_index:int) -> dict:
        value_by_signal = dict()

        value_by_sched, _ = build_signals_values(self._sched_signals, proc_label)
        value_by_signal.update(value_by_sched)

        proc_index_label = self._build_label_from_proc_index(proc_index)  # assume the spec doesn't have proc_index
        value_by_proc, _ = build_signals_values(self._proc_signals, proc_index_label)
        value_by_signal.update(value_by_proc)

        if self.nof_processes > 1:  # for nof_processes=1 sends_prev_expr is not calculated, since it is an input
            sends_prev_signal = _filter_by_proc(proc_index, self._sends_prev_signals)[0]
            sends_prev_expr = self._get_sends_prev_expr(proc_index, sys_state_vector)
            value_by_signal.update({sends_prev_signal: sends_prev_expr})

        return value_by_signal

    def get_architecture_trans_assumption(self, label, sys_state_vector) -> str:
        """ It handles 'is_active' variable in the specification. """

        #TODO: here I can add G(tok -> !prev) for the hub abstraction instead of specifying this on LTL level

        active_signals = list(filter(lambda s: s in label, self._is_active_signals))
        assert len(active_signals) <= 1, 'spec cannot contain > 1 is_active as conjunction'

        index_of_prev = index_of(lambda s: s in label, self._sends_prev_signals)
        assert index_of_prev is None or self.nof_processes == 1, \
            'using prev in the specification is not supported; prev in async hub abstraction works with local properties only'

        if not active_signals and not index_of_prev:
            return ''

        if active_signals:
            #: :type: QuantifiedSignal
            active = active_signals[0]
            proc_index = active.binding_indices[0]
        else:
            proc_index = self._sends_prev_signals[index_of_prev].binding_indices[0]
            assert self.nof_processes == 1, 'should come here only in the case of async hub'

        sends_prev_signal = _filter_by_proc(proc_index, self._sends_prev_signals)[0]

        if self.nof_processes > 1:
            sends_prev_value = self._get_sends_prev_expr(proc_index, sys_state_vector)
        else:
            #async_hub
            value_by_signal, _ = build_signals_values([sends_prev_signal], label)
            sends_prev_value = value_by_signal[sends_prev_signal]

        if not active_signals:
            return sends_prev_value

        value_by_sched, _ = build_signals_values(self._sched_signals, label)
        value_by_proc, _ = build_signals_values(self._proc_signals, self._build_label_from_proc_index(proc_index))

        value_by_signal = add_dicts(value_by_sched, value_by_proc, {sends_prev_signal: sends_prev_value})

        is_active_func_desc = self._get_desc_is_active(proc_index)

        func = call_func(is_active_func_desc, value_by_signal)

        return func

    def get_free_sched_vars(self, label) -> list:
        free_signals = set(filter(lambda sch: sch not in label, self._sched_signals))

        _, free_vars = build_signals_values(free_signals, Label())

        return free_vars

    def _get_desc_tau_sched_wrapper(self, proc_index:int, all_models_inputs) -> FuncDescription:
        local_tau_input_signals = _filter_by_proc(proc_index, all_models_inputs)
        local_tau_arg_type_pairs = self._get_desc_local_tau(local_tau_input_signals).inputs

        type_by_signal = dict(local_tau_arg_type_pairs + self._sched_arg_type_pairs + self._proc_arg_type_pairs)

        local_tau_arg_type_pairs = list(map(lambda signal_type: signal_type[0], local_tau_arg_type_pairs))

        is_active_desc = self._get_desc_is_active(proc_index)
        is_active_inputs = list(
            map(lambda signal: signal[0], is_active_desc.inputs))  # TODO: hack: knowledge: var names are the same

        body = """
        (ite ({is_active} {is_active_inputs}) ({tau} {local_tau_inputs}) {state})
        """.format_map({'tau': self._TAU_NAME,
                        'local_tau_inputs': ' '.join(map(str, local_tau_arg_type_pairs)),
                        'state': self.state_arg_name,
                        'is_active': self._IS_ACTIVE_NAME,
                        'is_active_inputs': ' '.join(map(str, is_active_inputs))})

        description = FuncDescription(self._TAU_SCHED_WRAPPER_NAME, type_by_signal,
                                      self._state_type,
                                      body)

        return description

    def _get_desc_equal_bools(self):
        cmp_stmnt = op_and(
            map(lambda p: '(= {0} {1})'.format(p[0], p[1]), zip(self._equals_first_args, self._equals_second_args)))

        body = '{cmp}'.format(cmp=cmp_stmnt)

        inputname_to_type = dict([(s, 'Bool') for s in self._equals_first_args] + \
                                 [(s, 'Bool') for s in self._equals_second_args])

        description = FuncDescription(self._EQUAL_BITS_NAME,
                                      inputname_to_type,
                                      'Bool',
                                      body)

        return description

    def _get_desc_is_active(self, proc_index:int):   # TODO: should not dependent on proc_index!
        #: :type: QuantifiedSignal
        sends_prev_signal = self._sends_prev_signals[proc_index]

        sched_eq_proc_arg_by_signal = self._get_equal_func_args(lmap(str, self._sched_signals),
                                                                lmap(str, self._proc_signals))

        sched_eq_proc_args = self._get_desc_equal_bools().get_args_list(sched_eq_proc_arg_by_signal)

        prev_is_sched_args = map(lambda signal_type: str(signal_type[0]),
                                 self._get_desc_prev_is_sched().inputs)  # order is important

        if self.nof_processes > 1:
            body_template = '(or (and (not {sends_prev}) ({equal_bits} {sched_eq_proc_args})) ' \
                            '    (and {sends_prev} ({prev_is_sched} {prev_is_sched_args})))'
        elif self.nof_processes == 1:
            body_template = '(or ({equal_bits} {sched_eq_proc_args}) ' \
                            '    {sends_prev})'

        body = body_template.format_map({'equal_bits': self._EQUAL_BITS_NAME,
                                         'sched_eq_proc_args': ' '.join(sched_eq_proc_args),
                                         'prev_is_sched': self._PREV_IS_SCHED_NAME,
                                         'prev_is_sched_args': ' '.join(prev_is_sched_args),
                                         'sends_prev': str(sends_prev_signal)
                                         })

        type_by_arg = dict([(sends_prev_signal, 'Bool')] + self._sched_arg_type_pairs + self._proc_arg_type_pairs)

        description = FuncDescription(self._IS_ACTIVE_NAME,
                                      type_by_arg,
                                      'Bool',
                                      body)

        return description

    def _get_equal_func_args(self, arg1_values, arg2_values) -> dict:
        for a in arg1_values:
            assert isinstance(a, str), str(a.__class__)
        for a in arg2_values:
            assert isinstance(a, str), str(a.__class__)

        assert len(arg1_values) == len(arg2_values), '{0} vs {1}'.format(arg1_values, arg2_values)

        arg1_by_index = dict(zip(map(lambda a: a.binding_indices[0], self._equals_first_args), self._equals_first_args))
        arg2_by_index = dict(
            zip(map(lambda a: a.binding_indices[0], self._equals_second_args), self._equals_second_args))

        value_by_arg = dict()
        for i in range(len(arg1_values)):
            value_by_arg[arg1_by_index[i]] = arg1_values[i]
            value_by_arg[arg2_by_index[i]] = arg2_values[i]

        return value_by_arg

    def _get_desc_prev_is_sched(self):  # TODO: optimize
        enum_clauses = []

        def accumulator(prev_proc, crt_proc):
            equals_desc = self._get_desc_equal_bools()

            proc_eq_crt_args_dict = self._get_equal_func_args(lmap(str, self._proc_signals), crt_proc)
            sched_eq_prev_args_dict = self._get_equal_func_args(lmap(str, self._sched_signals), prev_proc)

            proc_eq_crt_args = equals_desc.get_args_list(proc_eq_crt_args_dict)
            sched_eq_prev_args = equals_desc.get_args_list(sched_eq_prev_args_dict)

            enum_clauses.append('(and ({equals} {proc_eq_crt}) ({equals} {sched_eq_prev}))'
            .format_map({'equals': self._EQUAL_BITS_NAME,
                         'proc_eq_crt': ' '.join(proc_eq_crt_args),
                         'sched_eq_prev': ' '.join(sched_eq_prev_args)
            }))

        self._ring_modulo_iterate(self.nof_processes, accumulator)

        type_by_arg = dict(self._sched_arg_type_pairs + self._proc_arg_type_pairs)

        body = """(or {enum_clauses})""".format(enum_clauses='\n\t'.join(enum_clauses))

        description = FuncDescription(self._PREV_IS_SCHED_NAME,
                                      type_by_arg,
                                      'Bool',
                                      body)

        return description

    def _ring_modulo_iterate(self, nof_processes, function):

        def to_smt_bools(int_val):
            return list(map(lambda b: str(b).lower(), bin_fixed_list(int_val, self._nof_proc_bits)))

        if nof_processes == 1:
            crt = to_smt_bools(0)
            prev = to_smt_bools(1)
            function(prev, crt)
            return

        for crt_index in range(nof_processes):
            crt = to_smt_bools(crt_index)
            prev = to_smt_bools((crt_index - 1) % nof_processes)
            function(prev, crt)

    def _ensure_inputs_are_isomorphic(self, all_models_inputs):
        pass  # don't worry, be happy

    def _get_desc_local_tau(self, local_tau_input_signals) -> FuncDescription:
        type_by_arg = dict([(self.state_arg_name, self._state_type)] + [(s, 'Bool') for s in local_tau_input_signals])

        description = FuncDescription(self._TAU_NAME, type_by_arg, self._state_type, None)

        return description

    def _get_sends_prev_expr(self, proc_index, sys_states_vector) -> str:
        assert self.nof_processes > 1, 'nonsense'

        prev_proc = (proc_index - 1) % self.nof_processes

        prev_proc_state = sys_states_vector[prev_proc]

        #: :type: QuantifiedSignal
        sends_signal = _filter_by_proc(prev_proc, self._sends_signals)[0]
        #: :type: FuncDescription
        sends_func_desc = self.outvar_desc_by_process[prev_proc][sends_signal]

        call_sends = call_func(sends_func_desc, {self.state_arg_name: prev_proc_state})

        expr = '{call_sends}'.format(call_sends=call_sends)
        return expr

    def filter_label_by_process(self, label, proc_index:int):  # TODO: hack
        filtered_label = dict()

        for signal, value in label.items():
            if signal in self._sched_signals:
                filtered_label[signal] = value

            elif signal in self._is_active_signals:  # TODO: why do we need is_active of OTHER processes?!
                filtered_label[signal] = value

            elif signal.binding_indices[0] == proc_index:
                filtered_label[signal] = value

        return Label(filtered_label)

    def get_architecture_requirements(self):
        """
        'One process only possesses the token initially'

        Generic encoder considers different initial configurations of the ring,
        making sure that all possible initial token distributions are verified.
        """
        conditions = StrAwareList()

        states = self.states_by_process[0]
        s0, s1 = states[0], states[1]

        tok_func_desc = self.outvar_desc_by_process[0][self._has_tok_signals[0]]

        conditions += call_func(tok_func_desc, {self.state_arg_name:s1})
        conditions += op_not(call_func(tok_func_desc, {self.state_arg_name:s0}))

        return conditions

    def _build_init_states(self):
        #TODO: hardcoded: state 1 with the token, state 0 without the token,

        states = self.states_by_process[0]
        s0, s1 = states[0], states[1]
        if self.nof_processes == 1:
            return [(s1,), (s0,)]

        init_sys_state = [s1] + [s0] * (self.nof_processes - 1)  # states of all processes are the same

        permutations_of_init_state = list(permutations(init_sys_state))

        return permutations_of_init_state

    def _build_label_from_proc_index(self, proc_index:int) -> Label:
        bits = bin_fixed_list(proc_index, self._nof_proc_bits)

        label = Label(dict(zip(map(lambda at: at[0], self._proc_arg_type_pairs), bits)))

        return label

