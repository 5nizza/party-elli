import logging
from helpers.logging import log_entrance
from helpers.automata_helper import to_dot
from helpers.python_ext import StrAwareList, FileAsStringEmulator
from synthesis.generic_smt_encoder import GenericEncoder
from synthesis.solitary_impl import SolitaryImpl
from synthesis.z3 import Z3


@log_entrance(logging.getLogger(), logging.INFO)
def search(automaton, is_mealy, inputs, outputs, bounds, z3solver, logic, smt_file_prefix):
    logger = logging.getLogger()

    logger.debug(automaton)
    logger.debug(to_dot(automaton))

    for bound in bounds:
        logger.info('searching a model of size {0}..'.format(bound))

        with open(smt_file_prefix+'_'+str(bound), 'w') as smt_file:
            logger.info('using smt file ' + str(smt_file.name))

            query_lines = StrAwareList(FileAsStringEmulator(smt_file))

            spec_states_type = 'Q'
            sys_states_type = 'T'

            encoder = GenericEncoder(logic, spec_states_type, '')
            impl = SolitaryImpl(automaton, is_mealy, inputs, outputs, bound, sys_states_type)
            encoder.encode(impl, query_lines)

        status, data = z3solver.solve_file(smt_file.name)

        if status == Z3.SAT:
            return encoder._parse_sys_model(data, impl)

    return None