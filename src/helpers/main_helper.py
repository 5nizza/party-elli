import logging
import os
import sys

from synthesis.z3 import Z3
from translation2uct.ltl2automaton import Ltl2UCW, Ltl2UCW_thru_ACW


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


def create_spec_converter_z3(use_acw): #TODO: add config file
    """ Return ltl to automaton converter, Z3 solver """

    #make paths independent of current working directory
    rel_path = str(os.path.relpath(__file__))
    bosy_dir_toks = ['./'] + rel_path.split(os.sep) #abspath returns 'windows' (not cygwin) path
    root_dir = ('/'.join(bosy_dir_toks[:-1]) + '/..') #root dir is one level up compared to bosy.py

    z3_path = 'z3' #assume it is in the PATH
    ltl2ba_path = root_dir + '/../lib/ltl3ba/ltl3ba-1.0.1/ltl3ba'
    #

    import platform
    flag_marker = '-'
    if 'windows' in platform.system().lower() or 'nt' in platform.system().lower():
        ltl2ba_path += '.exe'
        flag_marker = '/'

    ltl2ucw = Ltl2UCW_thru_ACW if use_acw else Ltl2UCW
    return ltl2ucw(ltl2ba_path), Z3(z3_path, flag_marker)

