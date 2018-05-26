import logging
from multiprocessing import Process, Queue
from typing import List, Iterable

from interfaces.LTS import LTS
from syntcomp.task import Task


def _starter(q:Queue, task:Task):
    try:
        task.do()
        q.put(task)
    except Exception as e:
        logging.info("Task '%s' crashed!" % task.name)
        task.err_msg = str(e)
        q.put(task)
        raise e  # we raise e, in order to print the crash on the output (hm..)


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


def run_tasks(tasks:List[Task]) -> Task or None:
    """
    :return: the returned Task does not equal to any of the input tasks, because of multi-thread sharing
    """
    queue = Queue()

    processes = [Process(name=t.name, target=_starter, args=(queue, t)) for t in tasks]
    for p in processes:
        p.start()

    try:
        for trial_num in range(len(processes)):
            task = queue.get()                      # type: Task

            if task.err_msg is not None:
                logging.error('='*10 + 'Task crashed. This should never happen.' + '='*10)
                logging.error('I continue though..')
                continue

            assert task.answer in [False, True], str(task)
            if task.answer is False:
                logging.info('Task %s finished, but did not succeed in proving (un)realizability.' % task.name)
            else:
                logging.info('%s won!' % task.name)
                return task

        return None
    finally:
        _kill_them(processes)
        # note: don't use the queue, it may be corrupted
