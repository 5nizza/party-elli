import logging

from helpers.logging_helper import log_entrance
from interfaces.LTS import LTS
from interfaces.solver_interface import SolverInterface
from synthesis.cobuchi_smt_encoder import CoBuchiEncoder
from synthesis.smt_format import make_check_sat


@log_entrance()
def search(min_size:int, max_size:int, encoder:CoBuchiEncoder, solver:SolverInterface) -> LTS or None:
    solver += encoder.encode_headers(list(range(max_size)))
    solver += encoder.encode_initialization()

    last_size = 0
    for size in range(min_size, max_size+1):
        logging.info('searching a model of size {0}..'.format(size))

        cur_all_states = range(size)
        new_states = cur_all_states[last_size:]
        last_size = size

        solver += encoder.encode_run_graph(new_states)
        solver.push()
        solver += encoder.encode_model_bound(cur_all_states)
        solver += make_check_sat()
        solver += encoder.encode_get_model_values()

        ret = solver.solve()
        if ret:
            return encoder.parse_model(ret)
        solver.pop()

    return None
