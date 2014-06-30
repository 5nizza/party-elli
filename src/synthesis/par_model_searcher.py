from itertools import product
import logging
from hardcoded import encode_equality_for_tau, encode_equality_for_output, ASS_LOCKED_BURSTS, ASS_ANY_BURSTS, \
    ASS_ANY_BURSTS_OR_LOCKED_INCR, ASS_TRUE, ASS_BURST_OR_INCR, \
    ZERO_LOCKED_BURSTS_BUSREQ_READY, ZERO_LOCKED_BURSTS_READY, ZERO_LOCKED_BURSTS, ZERO_LOCKED_BURSTS_NOSILENCE, \
    ZERO_ANY_BURSTS_NOSILENCE, ZERO_ANY_BURSTS_ANY_INCR_NOSILENCE, ZERO_ANY_BURSTS
from helpers.console_helpers import print_green

from helpers.logging_helper import log_entrance
from helpers.python_ext import stripped_tokens
from interfaces.automata import Automaton
from interfaces.lts import LTS
from interfaces.parser_expr import QuantifiedSignal
from interfaces.solver_interface import SolverInterface
from parsing.visitor import get_log_bits
from synthesis.func_description import FuncDescription
from synthesis.gr1_encoder import encode_gr1_transitions
from synthesis.blank_impl import BlankImpl
from synthesis.generic_smt_encoder import GenericEncoder
from synthesis.sync_impl import SyncImpl
from synthesis.par_impl import ParImpl, get_signals_definition


model_file = None
_nof_states = None
saved_model_lines = None
already_asked = False


class BaseNames:
    def __init__(self,
                 sched_signals_base_name,
                 active_signal_base_name,
                 sends_signal_base_name,
                 sends_prev_signal_base_name,
                 has_tok_signals_base_name):
        self.sched_signal = sched_signals_base_name
        self.active_signal = active_signal_base_name
        self.sends_signal = sends_signal_base_name
        self.sends_prev_signal = sends_prev_signal_base_name
        self.has_tok_signal = has_tok_signals_base_name


def _encode_prev_funcs(solver:SolverInterface):
    global _nof_states
    global model_file
    global saved_model_lines

    assert model_file

    if not _nof_states:
        saved_model_lines = stripped_tokens(model_file.readlines())
        _nof_states = int(saved_model_lines[0])    # the first line should start with the number of states in the model

    lines = saved_model_lines[1:]

    tau_old_is_present = False
    for l in lines:
        tau_old_is_present = ('tau_old' in l) or tau_old_is_present
    assert tau_old_is_present, 'tau_old is not found in the model file'

    solver.add_raw_smt('\n'.join(lines))


def _get_prev_tau(crt_tau_inputs):
    inputs = dict(
        (sig_typ[0].name if isinstance(sig_typ[0], QuantifiedSignal) else sig_typ[0], sig_typ[1]) for sig_typ in
        crt_tau_inputs)
    return FuncDescription('tau_old', inputs, 'T',
                           None)  # we use body pragmatically, although it is present in the query


def _get_prev_ass():
    global already_asked
    if not already_asked:
        input("I AM USING ASS_ANY_BURSTS. OK?")
        already_asked = True

    return ASS_ANY_BURSTS
    # return ZERO_ANY_BURSTS_ANY_INCR_NOSILENCE
    # return ZERO_LOCKED_BURSTS_NOSILENCE

    # return ZERO_ANY_BURSTS
    # return ZERO_LOCKED_BURSTS
    # return ZERO_ANY_BURSTS_NOSILENCE
    # return ZERO_LOCKED_BURSTS_BUSREQ_READY
    # return ZERO_LOCKED_BURSTS_NOTNOREQ_BUSREQ_READY
    # return ASS_ANY_BURSTS_OR_LOCKED_INCR
    # return ASS_ANY_BURSTS
    # return ASS_TRUE
    # return ASS_LOCKED_BURSTS


def _get_prev_states():
    return ['t' + str(i) for i in range(_nof_states)]


def _get_prev_out(sig, crt_out:FuncDescription):
    return FuncDescription(crt_out.name + '_old', dict(
        (sig_typ[0].name if isinstance(sig_typ[0], QuantifiedSignal) else sig_typ[0], sig_typ[1]) for sig_typ in
        crt_out.inputs), 'Bool', None)  # we use body pragmatically, although it is present in the query


def _encode_prev_ass(prev_ass_func:FuncDescription, solver:SolverInterface):
    solver.define_fun(prev_ass_func)


class ParModelSearcher:
    def __init__(self):
        self._SYS_STATE_TYPE = 'T'
        self._TAU_NAME = 'tau'
        self._loc_spec_state_prefix = 'LQ'
        self._loc_counters_postfix = 'l'

    def check(self,  # TODO: careful with incrementality: nof_states >= 2
              logic,
              is_moore,
              global_automaton_cutoff_pairs,
              sync_automaton:Automaton,

              anon_input_names, anon_output_names,

              solver:SolverInterface,
              base_name_of:BaseNames,
              model:LTS,
              env_ass_func,
              sys_gua_func):
        """
        env_ass_funcs is the list: process_index -> env_function (each process has a single environment function)
        """

        self._logger = logging.getLogger()
        self._logic = logic
        self._is_moore = is_moore
        self._anon_input_names = anon_input_names
        self._anon_output_names = anon_output_names
        self._underlying_solver = solver
        self._names = base_name_of

        model_size = len(model.states)
        self._encode_headers(model_size, sync_automaton, global_automaton_cutoff_pairs)

        init_process_states = self._get_init_process_states(global_automaton_cutoff_pairs, model_size)

        all_states = model.states

        for i, (automaton, nof_processes) in enumerate(global_automaton_cutoff_pairs):
            #noinspection PyTypeChecker
            self._encode_global_automaton(i,
                                          nof_processes,
                                          automaton,
                                          model_size,
                                          all_states,
                [])

        # TODO: use separate impl! -- I use sync automaton to encode token ring properties on SMT level
        encoding_solver, impl = self._encode_local_automaton(sync_automaton,
                                                             model_size,
                                                             init_process_states,
                                                             all_states,
                                                             env_ass_func,
                                                             sys_gua_func)

        encoding_solver.push()

        #ZERO_ANY_BURSTS_NOSILENCe encoding_solver.encode_model_bound(all_states, impl)
        encoding_solver.encode_model_solution(model, impl)

        found_model = encoding_solver.solve(impl)
        return found_model

    def _get_init_process_states(self, global_automaton_cutoff_pairs, max_size):
        if not global_automaton_cutoff_pairs:
            return None

        automaton, nof_processes = global_automaton_cutoff_pairs[0]
        automaton_index = 0

        sys_intern_funcs_postfix = self._get_glob_sys_intern_func_postfix(automaton_index)

        par_impl = self._get_par_impl(automaton,
                                      max_size,
                                      nof_processes,
                                      sys_intern_funcs_postfix)

        init_process_states = set(states[0] for states in par_impl.init_states)

        return init_process_states

    # TODO: bureaucracy in coding.. simplify
    def _encode_headers(self, max_model_size,
                        sync_automaton,
                        global_automaton_cutoff_pairs,
                        env_ass_func,
                        sys_gua_func):
        init_process_states = self._get_init_process_states(global_automaton_cutoff_pairs, max_model_size)
        self._encode_local_headers(max_model_size, init_process_states, sync_automaton)

        for i, (automaton, nof_processes) in enumerate(global_automaton_cutoff_pairs):
            self._encode_global_headers(automaton, i, max_model_size, nof_processes)

        self._underlying_solver.define_fun(env_ass_func)
        self._underlying_solver.define_fun(sys_gua_func)

    def _get_glob_spec_state_type(self, automaton_index:int) -> str:
        spec_states_type = 'Q' + str(automaton_index)
        return spec_states_type

    def _get_glob_sys_intern_func_postfix(self, automaton_index:int) -> str:
        sys_intern_funcs_postfix = '_' + str(automaton_index)
        return sys_intern_funcs_postfix

    @log_entrance(logging.getLogger(), logging.INFO)
    def search(self,  # TODO: careful with incrementality: nof_states >= 2
               logic,
               is_moore,
               global_automaton_cutoff_pairs,
               sync_automaton:Automaton,

               anon_input_names, anon_output_names,

               process_model_bounds,
               solver:SolverInterface,
               base_name_of:BaseNames,
               env_ass_func,
               sys_gua_func):
        for size in process_model_bounds:
            solver.push()
            single_size_process_model_bounds = [size]
            model = self._search_without_push_pop(
                logic,
                is_moore,
                global_automaton_cutoff_pairs,
                sync_automaton,
                anon_input_names, anon_output_names,
                single_size_process_model_bounds,
                solver,
                base_name_of,
                env_ass_func,
                sys_gua_func)
            if model:
                return model
            solver.pop()
        return None

    def _search_without_push_pop(self,  # TODO: careful with incrementality: nof_states >= 2
                                 logic,
                                 is_moore,
                                 global_automaton_cutoff_pairs,
                                 sync_automaton:Automaton,

                                 anon_input_names, anon_output_names,

                                 process_model_bounds,
                                 solver:SolverInterface,
                                 base_name_of:BaseNames,
                                 env_ass_func,
                                 sys_gua_func):
        """
        env_ass_funcs is the list: process_index -> env_function (each process has a single environment function)
        """

        self._logger = logging.getLogger()
        self._logic = logic
        self._is_moore = is_moore
        self._anon_input_names = anon_input_names
        self._anon_output_names = anon_output_names
        self._underlying_solver = solver
        self._names = base_name_of

        self._encode_headers(process_model_bounds[-1], sync_automaton, global_automaton_cutoff_pairs,
                             env_ass_func, sys_gua_func)

        max_size = process_model_bounds[-1]
        init_process_states = self._get_init_process_states(global_automaton_cutoff_pairs, max_size)

        last_size = 0
        first_time = True
        for size in process_model_bounds:
            # TODO: that is a hack!
            cur_all_states = [BlankImpl(False, self._underlying_solver).get_state_name(self._SYS_STATE_TYPE, s)
                              for s in range(size)]
            new_states = cur_all_states[last_size:]
            already_encoded_states = cur_all_states[:last_size]
            last_size = size

            self._logger.info('trying size %i', size)

            for i, (automaton, nof_processes) in enumerate(global_automaton_cutoff_pairs):
                #noinspection PyTypeChecker
                self._encode_global_automaton(i, nof_processes, automaton, size, new_states, already_encoded_states,
                                              env_ass_func, sys_gua_func)

            #TODO: mess -- I use sync automaton to encode token ring properties on SMT level, use separate impl!
            encoding_solver, impl = self._encode_local_automaton(sync_automaton, size, init_process_states, new_states,
                                                                 env_ass_func)

            encode_gr1_transitions(env_ass_func, sys_gua_func,
                                   impl.taus_descs[0],  # assume isomorphism
                                   impl.outvar_desc_by_process,
                                   new_states,
                                   self._underlying_solver)

            if first_time:
                if model_file:
                    # assert size >= len(_get_prev_states())-1, str(size) + ' vs ' + str(len(_get_prev_states())-1)
                    self._logger.info('encoding equalities with the previous model')
                    # Encoding equalities with the previous model
                    _encode_prev_funcs(solver)
                    _encode_prev_ass(_get_prev_ass(), solver)

                    encode_equality_for_tau(_get_prev_tau(impl.taus_descs[0].inputs),
                                            impl.taus_descs[0],
                                            _get_prev_ass(),
                                            _get_prev_states(),
                                            solver)

                    for sig, out_func in impl.outvar_desc_by_process[0].items():
                        encode_equality_for_output(_get_prev_out(sig, out_func),
                                                   out_func,
                                                   _get_prev_states(),
                                                   solver)
                    #
                    first_time = False

            # encoding_solver.push()

            # encoding_solver.encode_model_bound(cur_all_states, impl)

            # if size > 3:
            #     for i in range(1, size):
            #         solver.add_raw_smt('(assert (tok {0}))'.format('t'+str(i)))
            # if size > 5:
            #     for i in range(int(size/2), min(size, int(size/2 + 3))):
            #         solver.add_raw_smt('(assert (tok {0}))'.format('t'+str(i)))
            model = encoding_solver.solve(impl)

            if model:
                return model

                # encoding_solver.pop()

        return None

    def _encode_global_headers(self,
                               automaton,
                               automaton_index:int, max_size:int, nof_processes:int):

        sys_intern_funcs_postfix = self._get_glob_sys_intern_func_postfix(automaton_index)
        spec_state_type = self._get_glob_spec_state_type(automaton_index)

        par_impl = self._get_par_impl(automaton, max_size, nof_processes, sys_intern_funcs_postfix)

        encoding_solver = GenericEncoder(self._logic, spec_state_type, sys_intern_funcs_postfix,
                                         par_impl.state_types_by_process,
                                         self._underlying_solver)

        # encoding_solver.encode_sys_model_functions(par_impl)  # this is done in local encoder
        encoding_solver.encode_sys_aux_functions(par_impl)
        encoding_solver.encode_run_graph_headers(par_impl)

    def _get_global_states_to_encode(self, new_model_states, already_encoded_model_states, nof_processes:int):
        assert set(new_model_states) != set(already_encoded_model_states)
        all_model_states = set(new_model_states)
        all_model_states.update(already_encoded_model_states)

        global_states = set(product(*(nof_processes * [all_model_states])))

        already_encoded_global_states = set(product(*(nof_processes * [already_encoded_model_states])))

        global_states.difference_update(already_encoded_global_states)

        return global_states

    def _encode_global_automaton(self,
                                 automaton_index:int,
                                 nof_processes:int,
                                 automaton:Automaton,
                                 model_size:int,
                                 model_states_to_encode,
                                 already_encoded_model_states,
                                 env_ass_func, sys_gua_func):

        sys_intern_funcs_postfix = self._get_glob_sys_intern_func_postfix(automaton_index)
        spec_state_type = self._get_glob_spec_state_type(automaton_index)

        par_impl = self._get_par_impl(automaton, model_size, nof_processes, sys_intern_funcs_postfix)

        encoding_solver = GenericEncoder(self._logic, spec_state_type, sys_intern_funcs_postfix,
                                         par_impl.state_types_by_process,
                                         self._underlying_solver)

        global_states_to_encode = self._get_global_states_to_encode(model_states_to_encode,
                                                                    already_encoded_model_states,
                                                                    nof_processes)
        # list(product(*(nof_processes * [model_states_to_encode])))
        encoding_solver.encode_run_graph(par_impl, global_states_to_encode, env_ass_func)

        return encoding_solver, par_impl

    def _encode_local_headers(self, max_size:int, init_process_states, sync_automaton:Automaton):
        impl = self._get_sync_impl(max_size, init_process_states, sync_automaton)

        encoding_solver = GenericEncoder(self._logic,
                                         self._loc_spec_state_prefix, self._loc_counters_postfix,
                                         impl.state_types_by_process,
                                         self._underlying_solver)

        encoding_solver.encode_sys_model_functions(impl)
        encoding_solver.encode_sys_aux_functions(impl)
        encoding_solver.encode_run_graph_headers(impl)

    def _get_sync_impl(self, bound, init_process_states, local_automaton):
        impl = SyncImpl(local_automaton,
                        not self._is_moore,
                        [QuantifiedSignal(n, 0) for n in self._anon_input_names],
                        [QuantifiedSignal(n, 0) for n in self._anon_output_names],
                        bound,
                        self._SYS_STATE_TYPE,
                        QuantifiedSignal(self._names.has_tok_signal, 0),
                        QuantifiedSignal(self._names.sends_signal, 0),
                        QuantifiedSignal(self._names.sends_prev_signal, 0),
                        self._TAU_NAME,
                        init_process_states,
                        self._underlying_solver)
        return impl

    def _encode_local_automaton(self, local_automaton,
                                bound,
                                init_process_states,
                                model_states_to_encode,
                                env_ass_func):
        impl = self._get_sync_impl(bound, init_process_states, local_automaton)

        encoding_solver = GenericEncoder(self._logic,
                                         self._loc_spec_state_prefix, self._loc_counters_postfix,
                                         impl.state_types_by_process,
                                         self._underlying_solver)

        encoding_solver.encode_run_graph(impl, list((s,) for s in model_states_to_encode), env_ass_func)
        return encoding_solver, impl

    def _get_par_impl(self,
                      automaton:Automaton,
                      model_size:int, nof_processes:int,
                      sys_intern_funcs_postfix):

        sched_input_signals = get_signals_definition(self._names.sched_signal, get_log_bits(nof_processes))[0]
        is_active_signals = [QuantifiedSignal(self._names.active_signal, i) for i in range(nof_processes)]
        sends_signals = [QuantifiedSignal(self._names.sends_signal, i) for i in range(nof_processes)]
        sends_prev_signals = [QuantifiedSignal(self._names.sends_prev_signal, i) for i in range(nof_processes)]
        has_tok_signals = [QuantifiedSignal(self._names.has_tok_signal, i) for i in range(nof_processes)]

        orig_input_signals = [QuantifiedSignal(n, i) for (n, i) in
                              product(self._anon_input_names, range(nof_processes))]
        orig_output_signals = [QuantifiedSignal(n, i) for (n, i) in
                               product(self._anon_output_names, range(nof_processes))]

        par_impl = ParImpl(automaton,
                           not self._is_moore,
                           orig_input_signals, orig_output_signals,
                           nof_processes, model_size,
                           sched_input_signals, is_active_signals, sends_signals, sends_prev_signals, has_tok_signals,
                           self._SYS_STATE_TYPE,
                           self._TAU_NAME,
                           sys_intern_funcs_postfix,
                           self._underlying_solver)
        return par_impl