#!/usr/bin/env python3
import logging
import signal
from typing import List

import elli
from LTL_to_atm import translator_via_spot
from config import Z3_PATH
from syntcomp.rally_template import main_template
from syntcomp.task import Task
from syntcomp.task_creator import TaskCreator
from synthesis.z3_via_pipe import Z3InteractiveViaPipes


class ElliBoolRealTask(Task):
    def __init__(self, name, ltl_text, part_text, is_moore, min_size, max_size, max_k:int):
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
            self.model = elli.synthesize_real(self.ltl_text, self.part_text,
                                              self.is_moore,
                                              translator_via_spot.LTLToAtmViaSpot(),
                                              solver,
                                              self.max_k,
                                              self.min_size, self.max_size, 0)
            self.answer = self.model is not None
        finally:
            solver.die()


class ElliBoolUnrealTask(Task):
    def __init__(self, name, ltl_text, part_text, is_moore, min_size, max_size, max_k:int, timeout):
        super().__init__(name, False)
        self.ltl_text = ltl_text
        self.part_text = part_text
        self.is_moore = is_moore
        self.min_size = min_size
        self.max_size = max_size
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
            self.model = elli.synthesize_unreal(self.ltl_text, self.part_text,
                                                self.is_moore,
                                                translator_via_spot.LTLToAtmViaSpot(),
                                                solver,
                                                self.max_k,
                                                self.min_size, self.max_size, 0)

            self.answer = self.model is not None
        except TimeoutException:
            logging.debug("ElliBoolUnrealTask: timeout reached")
            self.answer = False
        finally:
            solver.die()


if __name__ == "__main__":
    class ElliBoolTasksCreator(TaskCreator):
        @staticmethod
        def create(ltl_text:str, part_text:str, is_moore:bool) -> List[Task]:
            elli_int_real = ElliBoolRealTask('elli.bool.real',
                                             ltl_text, part_text, is_moore,
                                             1, 20, 8)
            elli_int_unreal = ElliBoolUnrealTask('elli.unreal.short',
                                                 ltl_text, part_text, is_moore,
                                                 1, 20, 8, timeout=1200)
            return [elli_int_real, elli_int_unreal]

    main_template("SMT-based bounded synthesizer, with UCW -> k-LA and thus no integer ranks",
                  ElliBoolTasksCreator())
