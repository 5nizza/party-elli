from io import StringIO
import logging

from helpers.logging import log_entrance
from helpers.python_ext import StrAwareList, FileAsStringEmulator
from synthesis.generic_smt_encoder import GenericEncoder
from synthesis.local_en_process_impl import LocalENImpl
from synthesis.par_impl import ParImpl
from synthesis.smt_helper import comment
from synthesis.smt_logic import UFLIA
from synthesis.z3 import Z3


@log_entrance(logging.getLogger(), logging.INFO)
def search(logic, automaton, nof_processes,
           anon_inputs, anon_outputs,
                        local_bounds,
                        z3solver,
                        sched_id_prefix,
                        active_var_name,
                        sends_anon_var_name,
                        has_tok_var_prefix,
                        sends_prev_var_name,
                        smt_file_name):
    logger = logging.getLogger()

    sys_state_type = 'T'
    tau_name = 'tau'

    for bound in local_bounds:
        global_encoder = GenericEncoder(logic, 'GQ', 'g')

        impl = ParImpl(automaton, anon_inputs, anon_outputs, nof_processes, bound,
            sched_id_prefix, active_var_name, sends_anon_var_name, sends_prev_var_name, has_tok_var_prefix,
            sys_state_type, tau_name, '')

        smt_file = open(smt_file_name, 'w')

        query_lines = StrAwareList(FileAsStringEmulator(smt_file))
        query_lines += comment('global_encoder')

        global_encoder.encode(impl, query_lines)

        logger.info('smt query has %i lines', len(query_lines))

        smt_file.close()
        status, data_lines = z3solver.solve_file(smt_file_name)

        if status == Z3.SAT:
            return global_encoder.parse_model(data_lines, impl)

    return None