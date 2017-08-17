import time


class Timer:
    def __init__(self):
        self.__origin = self.__last = time.time()

    def sec_restart(self) -> int:
        now = time.time()  # cannot use time.clock() since it does count sub-processes time
        elapsed = int(now - self.__last)
        self.__last = now
        return elapsed

    def sec_from_origin(self) -> int:
        """ Note: to get elapsed time from the process start,
                  you can also call `time.clock()`
        """
        return int(time.time() - self.__origin)
