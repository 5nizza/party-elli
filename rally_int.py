#!/usr/bin/env python3
import logging
import signal
from typing import List

import elli
from LTL_to_atm import translator_via_spot
from config import Z3_PATH
from rally_template import main_template
from syntcomp.task_creator import TaskCreator
from syntcomp.task import Task
from synthesis.z3_via_pipe import Z3InteractiveViaPipes


# TODO:
# - last.log from many processes


class ElliIntRealTask(Task):
    def __init__(self, name, ltl_text, part_text, is_moore, min_size, max_size):
        super().__init__(name, True)
        self.name = name
        self.ltl_text = ltl_text
        self.part_text = part_text
        self.is_moore = is_moore
        self.min_size = min_size
        self.max_size = max_size

    def do(self):
        solver = Z3InteractiveViaPipes(Z3_PATH)
        try:
            return elli.check_real(self.ltl_text, self.part_text,
                                   self.is_moore,
                                   translator_via_spot.LTLToAtmViaSpot(),
                                   solver,
                                   0,
                                   self.min_size, self.max_size)
        finally:
            solver.die()


class ElliIntUnrealTask(Task):
    def __init__(self, name, ltl_text, part_text, is_moore, min_size, max_size, timeout):
        super().__init__(name, False)
        self.ltl_text = ltl_text
        self.part_text = part_text
        self.is_moore = is_moore
        self.min_size = min_size
        self.max_size = max_size
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
            return elli.check_unreal(self.ltl_text, self.part_text,
                                     self.is_moore,
                                     translator_via_spot.LTLToAtmViaSpot(),
                                     solver,
                                     0,
                                     self.min_size, self.max_size)
        except TimeoutException:
            return None
        finally:
            solver.die()


if __name__ == "__main__":
    class ElliIntTasksCreator(TaskCreator):
        @staticmethod
        def create(ltl_text:str, part_text:str, is_moore:bool) -> List[Task]:
            elli_int_real = ElliIntRealTask('check real',
                                            ltl_text, part_text, is_moore,
                                            1, 20)
            elli_int_unreal = ElliIntUnrealTask('check unreal (short)',
                                                ltl_text, part_text, is_moore,
                                                1, 10, timeout=1200)
            return [elli_int_real, elli_int_unreal]

    main_template("SMT-based bounded synthesizer, with integers for ranks",
                  ElliIntTasksCreator())
