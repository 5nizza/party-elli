import logging
import os
import sys
from typing import List
from logging import FileHandler
from synthesis.z3_via_files import Z3NonInteractiveViaFiles, FakeSolver
from synthesis.z3_via_pipe import Z3InteractiveViaPipes
from third_party.ansistrm import ColorizingStreamHandler
from interfaces.solver_interface import SolverInterface


def get_root_dir() -> str:
    #make paths independent of current working directory
    rel_path = str(os.path.relpath(__file__))
    bosy_dir_toks = ['./'] + rel_path.split(os.sep)   # abspath returns 'windows' (not cygwin) path
    root_dir = ('/'.join(bosy_dir_toks[:-1]) + '/../')   # root dir is two levels up compared to helpers/.
    return root_dir


def setup_logging(verbose_level:int=0, filename:str=None, name_processes:bool=False):
    level = None
    if verbose_level == -1:
        level = logging.ERROR
    if verbose_level is 0:
        level = logging.INFO
    elif verbose_level >= 1:
        level = logging.DEBUG

    if name_processes:
        formatter = logging.Formatter(fmt="[%(processName)s] %(asctime)-10s%(message)s", datefmt="%H:%M:%S")
    else:
        formatter = logging.Formatter(fmt="%(asctime)-10s%(message)s", datefmt="%H:%M:%S")

    stdout_handler = ColorizingStreamHandler()
    stdout_handler.setFormatter(formatter)
    stdout_handler.stream = sys.stdout

    if not filename:
        filename = 'last.log'
    file_handler = FileHandler(filename=filename, mode='w')
    file_handler.setFormatter(formatter)

    root = logging.getLogger()
    root.addHandler(stdout_handler)
    root.addHandler(file_handler)

    root.setLevel(level)

    return logging.getLogger(__name__)


class Z3SolverFactory:
    def __init__(self,
                 smt_tmp_files_prefix:str, z3_path:str,
                 is_incremental:bool,
                 generate_queries_only:bool,
                 remove_files:bool):
        self.smt_tmp_files_prefix = smt_tmp_files_prefix
        self.z3_path = z3_path
        self.is_incremental = is_incremental
        self.generate_queries = generate_queries_only
        self.remove_files = remove_files
        assert not (self.is_incremental and self.generate_queries)
        self.solvers = []  # type: List[SolverInterface]
        self.seed = 0

    def create(self) -> SolverInterface:
        self.seed += 1
        if self.is_incremental:
            solver = Z3InteractiveViaPipes(self.z3_path)
        elif self.generate_queries:
            solver = FakeSolver(self.smt_tmp_files_prefix+str(self.seed),
                                self.z3_path)
        else:
            solver = Z3NonInteractiveViaFiles(self.smt_tmp_files_prefix+str(self.seed),
                                              self.z3_path,
                                              self.remove_files)

        self.solvers.append(solver)
        return solver

    def down_solvers(self):
        for s in self.solvers:
            s.die()
