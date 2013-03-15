import logging
import os
import sys
from helpers.python_ext import lfilter

from synthesis.z3 import Z3
from translation2uct.ltl2automaton import Ltl2UCW


def get_root_dir() -> str:
    #make paths independent of current working directory
    rel_path = str(os.path.relpath(__file__))
    bosy_dir_toks = ['./'] + rel_path.split(os.sep)   # abspath returns 'windows' (not cygwin) path
    root_dir = ('/'.join(bosy_dir_toks[:-1]) + '/../../')   # root dir is two levels up compared to helpers/.
    return root_dir


def setup_logging(verbose):
    level = None
    if verbose is 0:
        level = logging.INFO
    elif verbose >= 1:
        level = logging.DEBUG

    logging.basicConfig(format="%(asctime)-10s%(message)s",
                        datefmt="%H:%M:%S",
                        level=level,
                        stream=sys.stdout)

    return logging.getLogger(__name__)


def create_spec_converter_z3(logger:logging.Logger):
    """ Return ltl to automaton converter, Z3 solver """

    # TODO: port to other platforms
    flag_marker = '-'

    from config import z3_path, ltl3ba_path
    return Ltl2UCW(ltl3ba_path), Z3(z3_path, flag_marker)


def remove_files_prefixed(file_prefix:str):
    """ Remove files from the current directory prefixed with a given prefix """
    for f in os.listdir():
        if f.startswith(file_prefix):
            os.remove(f)
