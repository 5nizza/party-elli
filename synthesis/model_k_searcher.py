import logging

from helpers.logging_helper import log_entrance
from interfaces.LTS import LTS
from interfaces.solver_interface import SolverInterface
from synthesis.coreach_encoder import CoreachEncoder
from synthesis.smt_format import make_check_sat


@log_entrance()
def search(min_size:int, max_size:int,
           max_k:int,
           encoder:CoreachEncoder,
           solver:SolverInterface) -> LTS or None:
    solver += encoder.encode_headers()
    solver += encoder.encode_initialization()

    last_size = 0
    for size in range(min_size, max_size+1):
        k = min(max_k, size//3 + 1)
        logging.info('searching a model: size=%i, k=%i'%(size,k))

        solver += encoder.encode_run_graph(range(size)[last_size:])

        solver.push()  # >>>>>>>>> push
        solver += encoder.encode_model_bound(range(size))
        solver += make_check_sat(encoder.encode_assumption_forbid_k(max_k - k))
        solver += encoder.encode_get_model_values()
        ret = solver.solve()
        if ret:
            return encoder.parse_model(ret)
        solver.pop()   # <<<<<<<<<< pop

        last_size = size

    return None
