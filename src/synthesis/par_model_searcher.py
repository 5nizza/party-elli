from itertools import  product
import logging

from helpers.logging import log_entrance
from helpers.python_ext import StrAwareList, FileAsStringEmulator
from interfaces.automata import Automaton
from interfaces.parser_expr import QuantifiedSignal
from parsing.helpers import get_log_bits
from synthesis.generic_smt_encoder import GenericEncoder
from synthesis.sync_impl import SyncImpl
from synthesis.par_impl import ParImpl, get_signals_definition
from synthesis.smt_helper import comment
from synthesis.z3 import Z3



@log_entrance(logging.getLogger(), logging.INFO)
def search(logic,
           is_moore,
           global_automaton_cutoff_pairs,
           local_automaton:Automaton,
           anon_input_names, anon_output_names,
                        local_bounds,
                        z3solver,
                        sched_signals_base_name:str,
                        active_signal_base_name:str,
                        sends_signal_base_name:str,
                        sends_prev_signal_base_name:str,
                        has_tok_signals_base_name:str,
                        smt_file_name):
    logger = logging.getLogger()

    sys_state_type = 'T'
    tau_name = 'tau'

    for bound in local_bounds:
        logger.info('trying size %i', bound)

        smt_file = open(smt_file_name+'_'+str(bound), 'w')
        query_lines = StrAwareList(FileAsStringEmulator(smt_file))

        encoder=impl=None
        for i, (automaton, nof_processes) in enumerate(global_automaton_cutoff_pairs):
            counters_postfix = sys_intern_funcs_postfix = '_'+str(i)
            spec_states_type = 'Q'+str(i)

            encoder = GenericEncoder(logic, spec_states_type, counters_postfix)

            sched_input_signals, _ = get_signals_definition(sched_signals_base_name, get_log_bits(nof_processes))
            is_active_signals = [QuantifiedSignal(active_signal_base_name, i) for i in range(nof_processes)]
            sends_signals = [QuantifiedSignal(sends_signal_base_name, i) for i in range(nof_processes)]
            sends_prev_signals = [QuantifiedSignal(sends_prev_signal_base_name, i) for i in range(nof_processes)]
            has_tok_signals = [QuantifiedSignal(has_tok_signals_base_name, i) for i in range(nof_processes)]

            orig_input_signals = [QuantifiedSignal(n, i) for (n,i) in product(anon_input_names, range(nof_processes))]
            orig_output_signals = [QuantifiedSignal(n, i) for (n,i) in product(anon_output_names, range(nof_processes))]

            impl = ParImpl(automaton,
                not is_moore,
                orig_input_signals, orig_output_signals,
                nof_processes, bound,
                sched_input_signals, is_active_signals, sends_signals, sends_prev_signals, has_tok_signals,
                sys_state_type,
                tau_name,
                sys_intern_funcs_postfix)

            if i == 0:
                encoder.encode_headers(query_lines)
                encoder.encode_sys_model_functions(impl, query_lines)

                query_lines += comment('local_encoder')

                local_impl = SyncImpl(local_automaton,
                    not is_moore,
                    [QuantifiedSignal(n, 0) for n in anon_input_names],
                    [QuantifiedSignal(n, 0) for n in anon_output_names],
                    bound,
                    sys_state_type,
                    QuantifiedSignal(has_tok_signals_base_name, 0),
                    QuantifiedSignal(sends_signal_base_name, 0),
                    QuantifiedSignal(sends_prev_signal_base_name, 0),
                    tau_name,
                    impl.init_states[0])

                local_encoder = GenericEncoder(logic, 'LQ', 'l')
                local_encoder.encode_run_graph_headers(local_impl, query_lines)
                local_encoder.encode_run_graph(local_impl, query_lines)

            query_lines += comment('global_encoder' + sys_intern_funcs_postfix)

            encoder.encode_sys_aux_functions(impl, query_lines)
            encoder.encode_run_graph_headers(impl, query_lines)
            encoder.encode_run_graph(impl, query_lines)

        encoder.encode_footings(impl, query_lines)

        logger.info('smt query has %i lines', len(query_lines))

        smt_file.close()

        status, data_lines = z3solver.solve_file(smt_file.name)

        if status == Z3.SAT:
            return encoder.parse_sys_model(data_lines, impl)

    return None
