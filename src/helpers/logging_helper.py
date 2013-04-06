def log_entrance(logger, log_level):
    def wrap(func):
        def wrapped_func(*args):
            logger.log(log_level, func.__name__)
            return func(*args)

        return wrapped_func
    return wrap