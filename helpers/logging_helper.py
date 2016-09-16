import logging


def log_entrance(logger=logging.getLogger(), log_level=logging.INFO):
    def wrap(func):
        def wrapped_func(*args):
            logger.log(log_level, func.__name__)
            return func(*args)

        return wrapped_func
    return wrap
