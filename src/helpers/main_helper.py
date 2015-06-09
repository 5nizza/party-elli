import logging
from logging import FileHandler
import os
import sys
from synthesis.smt_logic import Logic

from synthesis.solvers import Z3_Smt_NonInteractive_ViaFiles, Z3_Smt_Interactive
from third_party.ansistrm import ColorizingStreamHandler
from automata_translations.ltl2automaton import LTL3BA


def get_root_dir() -> str:
    #make paths independent of current working directory
    rel_path = str(os.path.relpath(__file__))
    bosy_dir_toks = ['./'] + rel_path.split(os.sep)   # abspath returns 'windows' (not cygwin) path
    root_dir = ('/'.join(bosy_dir_toks[:-1]) + '/../../')   # root dir is two levels up compared to helpers/.
    return root_dir


def setup_logging(verbose_level:int):
    level = None
    if verbose_level == -1:
        level = logging.CRITICAL
    if verbose_level is 0:
        level = logging.INFO
    elif verbose_level >= 1:
        level = logging.DEBUG

    handler = ColorizingStreamHandler()
    handler.setFormatter(logging.Formatter(fmt="%(asctime)-10s%(message)s", datefmt="%H:%M:%S"))
    handler.stream = sys.stdout

    root = logging.getLogger()
    root.addHandler(handler)
    root.addHandler(FileHandler(filename='last.log', mode='w'))
    root.setLevel(level)

    return logging.getLogger(__name__)


class Z3SolverFactory:
    def __init__(self, smt_tmp_files_prefix, z3_path, logic, logger, is_incremental:bool):
        self.smt_tmp_files_prefix = smt_tmp_files_prefix
        self.z3_path = z3_path
        self.logic = logic
        self.logger = logger
        self.is_incremental = is_incremental

    def create(self, seed=''):
        if self.is_incremental:
            solver = Z3_Smt_Interactive(self.logic, self.z3_path, self.logger)
        else:
            solver = Z3_Smt_NonInteractive_ViaFiles(self.smt_tmp_files_prefix+seed,
                                                    self.z3_path,
                                                    self.logic,
                                                    self.logger)

        return solver


def create_spec_converter_z3(logger:logging.Logger,
                             logic:Logic,
                             is_incremental:bool,
                             smt_tmp_files_prefix:str=None):
    """ Return ltl to automaton converter, Z3 solver """
    assert smt_tmp_files_prefix or is_incremental

    from config import z3_path, ltl3ba_path

    converter = LTL3BA(ltl3ba_path)
    solver_factory = Z3SolverFactory(smt_tmp_files_prefix, z3_path, logic, logger, is_incremental)

    return converter, solver_factory


def remove_files_prefixed(file_prefix:str):
    """ Remove files from the current directory prefixed with a given prefix """
    for f in os.listdir():
        if f.startswith(file_prefix):
            os.remove(f)
