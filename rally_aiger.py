#!/usr/bin/env python3
import logging
import signal
from typing import List

import kid
from LTL_to_atm.translator_via_spot import LTLToAtmViaSpot
from rally_template import main_template
from syntcomp.task_creator import TaskCreator
from syntcomp.task import Task


class KidRealTask(Task):
    def __init__(self, name,
                 ltl_text, part_text, is_moore,
                 min_k:int,
                 max_k:int):
        super().__init__(name, True)
        self.name = name
        self.ltl_text = ltl_text
        self.part_text = part_text
        self.is_moore = is_moore
        self.min_k = min_k
        self.max_k = max_k

    def do(self):
        return kid.check_real(self.ltl_text, self.part_text, self.is_moore,
                              LTLToAtmViaSpot(),
                              self.min_k, self.max_k,
                              0)


class KidUnrealTask(Task):
    def __init__(self, name, ltl_text, part_text, is_moore,
                 min_k:int, max_k:int,
                 timeout):
        super().__init__(name, False)
        self.ltl_text = ltl_text
        self.part_text = part_text
        self.is_moore = is_moore
        self.min_k = min_k
        self.max_k = max_k
        self.timeout = timeout

    def do(self):
        class TimeoutException(Exception):
            pass

        if self.timeout:
            logging.info('CheckUnrealTask: setting timeout to %i' % self.timeout)
            def signal_handler(sig, _):
                if sig == signal.SIGALRM:
                    raise TimeoutException()
            signal.signal(signal.SIGALRM, signal_handler)
            signal.alarm(self.timeout)
        try:
            return kid.check_unreal(self.ltl_text, self.part_text, self.is_moore,
                                    LTLToAtmViaSpot(),
                                    self.min_k, self.max_k, 0)
        except TimeoutException:
            logging.debug('timeout reached')
            return None


if __name__ == "__main__":
    class KidTasksCreator(TaskCreator):
        @staticmethod
        def create(ltl_text:str, part_text:str, is_moore:bool) -> List[Task]:
            return [KidRealTask('check real', ltl_text, part_text, is_moore, 2, 20),
                    KidUnrealTask('check unreal (short)', ltl_text, part_text, is_moore, 2, 10, 1200)]

    main_template("LTL synthesizer via AIGER, UCW -> k-LA -> AIGER, then solve with SDF solver",
                  KidTasksCreator())
