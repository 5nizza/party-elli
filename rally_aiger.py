#!/usr/bin/env python3
import logging
import signal
from typing import List

import elli
import kid
from LTL_to_atm import translator_via_spot
from LTL_to_atm.translator_via_spot import LTLToAtmViaSpot
from config import Z3_PATH
from rally_template import main_template
from syntcomp.task_creator import TaskCreator
from syntcomp.task import Task
from synthesis.z3_via_pipe import Z3InteractiveViaPipes


class KidRealTask(Task):
    def __init__(self, name, ltl_text, part_text, is_moore, max_k:int):
        super().__init__(name, True)
        self.name = name
        self.ltl_text = ltl_text
        self.part_text = part_text
        self.is_moore = is_moore
        self.min_size = min_size
        self.max_size = max_size
        self.max_k = max_k

    def do(self):
        solver = Z3InteractiveViaPipes(Z3_PATH)
        try:
            return kid.check_real(self.ltl_text, self.part_text, self.is_moore,
                                  LTLToAtmViaSpot(),
                                  max_k, 0)
        finally:
            solver.die()


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
                    raise TimeoutException("CheckUnrealTask: timeout reached")
            signal.signal(signal.SIGALRM, signal_handler)
            signal.alarm(self.timeout)

        solver = Z3InteractiveViaPipes(Z3_PATH)
        try:
            return kid.check_unreal(self.ltl_text, self.part_text, self.is_moore,
                                    LTLToAtmViaSpot(),
                                    max_k)
        except TimeoutException:
            return None
        finally:
            solver.die()


if __name__ == "__main__":
    class ElliBoolTasksCreator(TaskCreator):
        @staticmethod
        def create(ltl_text:str, part_text:str, is_moore:bool) -> List[Task]:
            elli_int_real = ElliBoolRealTask('check real',
                                             ltl_text, part_text, is_moore,
                                             1, 20, 8)
            elli_int_unreal = ElliBoolUnrealTask('check unreal (short)',
                                                 ltl_text, part_text, is_moore,
                                                 1, 10, 6, timeout=1200)
            return [elli_int_real, elli_int_unreal]

    main_template("SMT-based bounded synthesizer, with UCW -> k-LA and thus no integer ranks",
                  ElliBoolTasksCreator())
