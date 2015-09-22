import logging

from helpers.logging_helper import log_entrance
from interfaces.lts import LTS


@log_entrance(logging.getLogger(), logging.INFO)
def search(sizes, encoder) -> LTS:
    logger = logging.getLogger()

    for size in sizes:
        logger.info('searching a model of size {0}..'.format(size))

        cur_all_states = range(size)  # TODO: no incrementality here

        encoder.push()

        encoder.encode_headers(cur_all_states)
        encoder.encode_initialization()
        encoder.encode_run_graph(cur_all_states)
        encoder.encode_model_bound(cur_all_states)

        model = encoder.solve()
        if model:
            return model

        encoder.pop()

    return None

