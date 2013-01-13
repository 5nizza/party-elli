from itertools import  product
import logging

from helpers.logging import log_entrance
from helpers.python_ext import StrAwareList, StringEmulatorFromFile
from interfaces.automata import Automaton
from interfaces.parser_expr import QuantifiedSignal
from parsing.helpers import get_log_bits
from synthesis.generic_smt_encoder import GenericEncoder
from synthesis.sync_impl import SyncImpl
from synthesis.par_impl import ParImpl, get_signals_definition
from synthesis.smt_helper import comment
from synthesis.z3 import Z3


class BaseNames:
    def __init__(self,
                 sched_signals_base_name,
                 active_signal_base_name,
                 sends_signal_base_name,
                 sends_prev_signal_base_name,
                 has_tok_signals_base_name):

        self.sched_signal =sched_signals_base_name
        self.active_signal =active_signal_base_name
        self.sends_signal = sends_signal_base_name
        self.sends_prev_signal = sends_prev_signal_base_name
        self.has_tok_signal = has_tok_signals_base_name


class ParModelSearcher:
    def __init__(self):
        self._SYS_STATE_TYPE = 'T'
        self._TAU_NAME = 'tau'


    @log_entrance(logging.getLogger(), logging.INFO)
    def search(self,
               logic,
               is_moore,
               global_automaton_cutoff_pairs,
               sync_automaton:Automaton,

               anon_input_names, anon_output_names,

               process_model_bounds,
               z3solver,
               smt_file_name_prefix,
               base_name_of:BaseNames):

        self.logger = logging.getLogger()
        self.logic = logic
        self.is_moore = is_moore
        self.anon_input_names = anon_input_names
        self.anon_output_names = anon_output_names
        self.z3solver = z3solver
        self.names = base_name_of


        for bound in process_model_bounds:
            self._reset_state()

            self.logger.info('trying size %i', bound)

            smt_file_name = '{prefix}_{bound}.smt2'.format(prefix=smt_file_name_prefix, bound=bound)
            with open(smt_file_name, 'w') as out:
                query_lines = StrAwareList(StringEmulatorFromFile(out))

                init_process_states = None
                for i, (automaton, nof_processes) in enumerate(global_automaton_cutoff_pairs):
                    #noinspection PyTypeChecker
#                    encoder, impl = self._encode_global_automaton(i, nof_processes, automaton, bound, query_lines)
                    _, impl = self._encode_global_automaton(i, nof_processes, automaton, bound, query_lines)
                    init_process_states = impl.init_states[0] #TODO: another hack

                #TODO: mess -- I use local automaton to encode token ring properties on SMT level, use separate impl for that?
#                if local_automaton:
                encoder, impl = self._encode_local_automaton(query_lines, sync_automaton, bound, init_process_states)

                self._ensure_footings_added(encoder, impl, query_lines)

                self.logger.info('smt query has %i lines', len(query_lines))

            status, data_lines = z3solver.solve_file(smt_file_name)

            if status == Z3.SAT:
                return encoder.parse_sys_model(data_lines, impl)

        return None



    def _encode_global_automaton(self,
                                 automaton_index:int,
                                 nof_processes,
                                 automaton:Automaton,
                                 bound:int,
                                 query_lines):

        sys_intern_funcs_postfix = '_'+str(automaton_index)
        spec_states_type = 'Q'+str(automaton_index)

        glob_encoder = GenericEncoder(self.logic, spec_states_type, sys_intern_funcs_postfix)

        sched_input_signals = get_signals_definition(self.names.sched_signal, get_log_bits(nof_processes)) [0]
        is_active_signals =  [QuantifiedSignal(self.names.active_signal, i)     for i in range(nof_processes)]
        sends_signals =      [QuantifiedSignal(self.names.sends_signal, i)      for i in range(nof_processes)]
        sends_prev_signals = [QuantifiedSignal(self.names.sends_prev_signal, i) for i in range(nof_processes)]
        has_tok_signals =    [QuantifiedSignal(self.names.has_tok_signal, i)    for i in range(nof_processes)]

        orig_input_signals = [QuantifiedSignal(n, i) for (n,i) in product(self.anon_input_names, range(nof_processes))]
        orig_output_signals = [QuantifiedSignal(n, i) for (n,i) in product(self.anon_output_names, range(nof_processes))]

        par_impl = ParImpl(automaton,
            not self.is_moore,
            orig_input_signals, orig_output_signals,
            nof_processes, bound,
            sched_input_signals, is_active_signals, sends_signals, sends_prev_signals, has_tok_signals,
            self._SYS_STATE_TYPE,
            self._TAU_NAME,
            sys_intern_funcs_postfix)

        query_lines += comment('global_encoder' + sys_intern_funcs_postfix)

        self._ensure_header_added(glob_encoder, query_lines)
        self._ensure_sys_model_functions_added(glob_encoder, par_impl, query_lines)

        glob_encoder.encode_sys_aux_functions(par_impl, query_lines)
        glob_encoder.encode_run_graph_headers(par_impl, query_lines)
        glob_encoder.encode_run_graph(par_impl, query_lines)
        #ensure_footings_added -- outside

        return glob_encoder, par_impl


    def _encode_local_automaton(self, query_lines, local_automaton, bound, init_process_states):
        query_lines += comment('local_encoder')

        impl = SyncImpl(local_automaton,
            not self.is_moore,
            [QuantifiedSignal(n, 0) for n in self.anon_input_names],
            [QuantifiedSignal(n, 0) for n in self.anon_output_names],
            bound,
            self._SYS_STATE_TYPE,
            QuantifiedSignal(self.names.has_tok_signal, 0),
            QuantifiedSignal(self.names.sends_signal, 0),
            QuantifiedSignal(self.names.sends_prev_signal, 0),
            self._TAU_NAME,
            init_process_states)

        encoder = GenericEncoder(self.logic, 'LQ', 'l')

        self._ensure_header_added(encoder, query_lines)
        self._ensure_sys_model_functions_added(encoder, impl, query_lines)

        encoder.encode_run_graph_headers(impl, query_lines)
        encoder.encode_run_graph(impl, query_lines)
        #ensure_footings_added -- outside

        return encoder, impl


    def _reset_state(self):
        self.is_header_encoded = self.is_sys_models_encoded = self.is_footing_added = False


    def _ensure_header_added(self, encoder:GenericEncoder, query_lines):
        if self.is_header_encoded:
            return

        self.is_header_encoded = True
        encoder.encode_header(query_lines)


    def _ensure_sys_model_functions_added(self, encoder:GenericEncoder, impl, query_lines):
        if self.is_sys_models_encoded:
            return

        self.is_sys_models_encoded = True
        encoder.encode_sys_model_functions(impl, query_lines)


    def _ensure_footings_added(self, encoder:GenericEncoder, impl, query_lines):
        if self.is_footing_added:
            return

        self.is_footing_added = True
        encoder.encode_footings(impl, query_lines)




