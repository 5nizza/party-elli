import logging

from helpers.logging_helper import log_entrance
from interfaces.lts import LTS


@log_entrance()
def search(sizes, encoder) -> LTS:
    logger = logging.getLogger()

    max_model_states = list(range(sizes[-1]))
    encoder.encode_headers(max_model_states)
    encoder.encode_initialization()

    last_size = 0
    for size in sizes:
        logger.info('searching a model of size {0}..'.format(size))

        cur_all_states = range(size)
        new_states = cur_all_states[last_size:]
        last_size = size

        encoder.encode_run_graph(new_states)
        encoder.push()
        encoder.encode_model_bound(cur_all_states)

        model = encoder.solve()
        if model:
            return model

        encoder.pop()

    return None
