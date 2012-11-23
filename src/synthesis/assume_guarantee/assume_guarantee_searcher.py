import logging
from helpers.automata_helper import complement_with_live_ends
from helpers.logging import log_entrance
from helpers.python_ext import StrAwareList, FileAsStringEmulator
from synthesis.assume_guarantee.assume_guarantee_encoder import AssumeGuaranteeEncoder
from synthesis.solitary_impl import SolitaryImpl
from synthesis.z3 import Z3


@log_entrance(logging.getLogger(), logging.INFO)
def search(ass_automaton, gua_automaton, inputs, outputs, bounds, z3solver, logic, smt_file_prefix):
    #TODO: hack: mutating input argument

    logger = logging.getLogger()

    complement_with_live_ends(ass_automaton, inputs + outputs)

    for bound in bounds:
        logger.info('searching a model of size {0}..'.format(bound))

        with open(smt_file_prefix+'_'+str(bound), 'w') as smt_file:
            logger.info('using smt file ' + str(smt_file.name))

            query_lines = StrAwareList(FileAsStringEmulator(smt_file))

            sys_states_type = 'T'

            ass_automaton_states_type = 'A'
            gua_automaton_states_type = 'G'

            gua_impl = SolitaryImpl(gua_automaton, inputs, outputs, bound, sys_states_type)
            encoder = AssumeGuaranteeEncoder(logic, ass_automaton_states_type, gua_automaton_states_type, '')
            encoder.encode(ass_automaton, gua_impl, query_lines)

        status, data = z3solver.solve_file(smt_file.name)

        if status == Z3.SAT:
            return encoder.parse_model(data, gua_impl)

    return None
