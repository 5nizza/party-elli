#!/usr/bin/env python3
import logging
import signal
from typing import List

import kid_hoa
from LTL_to_atm.translator_via_spot import LTLToAtmViaSpot
from syntcomp.rally_template import main_template
from syntcomp.task import Task
from syntcomp.task_creator import TaskCreator


class KidHoaRealTask(Task):
    def __init__(self, name,
                 ltl_text, part_text, is_moore,
                 min_k:int,
                 max_k:int,
                 formula_opt:int=0):
        super().__init__(name, True)
        self.name = name
        self.ltl_text = ltl_text
        self.part_text = part_text
        self.is_moore = is_moore
        self.min_k = min_k
        self.max_k = max_k
        self.formula_opt = formula_opt

    def do(self):
        self.answer = kid_hoa.check_real(self.ltl_text, self.part_text, self.is_moore,
                                         LTLToAtmViaSpot(),
                                         self.min_k, self.max_k,
                                         self.formula_opt)


class KidHoaUnrealTask(Task):
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
            self.answer = kid_hoa.check_unreal(self.ltl_text, self.part_text, self.is_moore,
                                               LTLToAtmViaSpot(),
                                               self.min_k, self.max_k, 0)
        except TimeoutException:
            logging.debug('JoyUnrealTask: timeout reached')
            self.answer = False


if __name__ == "__main__":
    class JoyTasksCreator(TaskCreator):
        @staticmethod
        def create(ltl_text:str, part_text:str, is_moore:bool) -> List[Task]:
            return [KidHoaRealTask('kid_hoa.real', ltl_text, part_text, is_moore, 4, 16),
                    KidHoaUnrealTask('kid_hoa.unreal.short', ltl_text, part_text, is_moore, 2, 16, 1200)]

    main_template("LTL synthesizer via reduction to safety, UCW -> k-LA -> solve the game with adapted sdf",
                  JoyTasksCreator())
