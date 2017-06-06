from typing import List, Iterable, Tuple
from multiprocessing import Process, Queue

import logging

from interfaces.LTS import LTS
from syntcomp.task import Task
import logging
from multiprocessing import Process, Queue
from typing import List, Iterable, Tuple

from interfaces.LTS import LTS
from syntcomp.task import Task


def _starter(q:Queue, task: Task):
    try:
        res = task.do()
        q.put((task, res))
    except Exception as e:
        logging.info("Task '%s' crashed!" % task.name)
        q.put((task, e))
        raise e


def _kill_them(processes:Iterable[Process]):
    for p in processes:
        p.terminate()
        p.join()


def run_synth_tasks(tasks:List[Task]) -> Tuple[bool, LTS or str or None]:
    queue = Queue()

    processes = [Process(name=t.name, target=_starter, args=(queue, t)) for t in tasks]
    for p in processes:
        p.start()

    task, lts_or_aiger = None, None   # .. to shut up pycharm warnings

    for _ in range(len(processes)):
        task, lts_or_aiger = queue.get()  # type: Tuple[Task, LTS or None or str]
        if isinstance(lts_or_aiger, Exception):
            logging.error('='*10 + 'Task crashed. This should never happen.' + '='*10)
            logging.error('I continue though..')
            continue
        if lts_or_aiger is None:
            logging.info('task did not succeed: ' + task.name)
            logging.info('waiting for others..')
        else:
            logging.info('%s won!' % task.name)
            break

    _kill_them(processes)
    return task.is_doing_real_check, lts_or_aiger
