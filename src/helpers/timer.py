import time


__origin = __last = time.clock()


def sec_restart() -> int:
    global __origin, __last
    now = time.clock()
    elapsed = int(now - __last)
    __last = now
    return elapsed


def sec_from_origin() -> int:
    """ Note: to get elapsed time from the process start,
              you can also call `time.clock()`
    """
    global __origin, __last
    return int(time.clock() - __origin)
