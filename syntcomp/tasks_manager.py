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


# def kill_proc_tree(pid, including_parent=True):
#     parent = psutil.Process(pid)
#     children = parent.children(recursive=True)
#     for c in children:
#         c.terminate()
        # c.wait()
    # gone, alive = psutil.wait_procs(children)
    # assert gone == children, str(gone) + ' vs. ' + str(children)
    # if including_parent:
    #     parent.terminate()
    #     parent.wait()


def _kill_them(processes:Iterable[Process]):
    for p in processes:
        # kill_proc_tree(p.pid)
        p.terminate()
        p.join()


def run_synth_tasks(tasks:List[Task]) -> Tuple[bool, LTS or str or None] or Tuple[None, None]:
    queue = Queue()

    processes = [Process(name=t.name, target=_starter, args=(queue, t)) for t in tasks]
    for p in processes:
        p.start()

    task, lts_or_aiger = None, None   # .. to shut up pycharm warnings

    for trial_num in range(len(processes)):
        task, lts_or_aiger = queue.get()  # type: Task, LTS or None or str
        if isinstance(lts_or_aiger, Exception):
            logging.error('='*10 + 'Task crashed. This should never happen.' + '='*10)
            logging.error('I continue though..')
            if trial_num == len(processes) - 1:
                return None, None
            continue
        if lts_or_aiger is None:
            logging.info('task did not succeed: ' + task.name)
            logging.info('waiting for others..')
        else:
            logging.info('%s won!' % task.name)
            break

    _kill_them(processes)  # don't use the queue, it may be corrupted!
    return task.is_doing_real_check, lts_or_aiger
