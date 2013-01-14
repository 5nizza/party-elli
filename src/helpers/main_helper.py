import logging
import os
import sys
from helpers.python_ext import lfilter

from synthesis.z3 import Z3
from translation2uct.ltl2automaton import Ltl2UCW


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


def _get_tool_path(tool_name:str, lines) -> str:
    tool_lines = lfilter(lambda l: l.startswith(tool_name), lines)
    assert len(tool_lines) == 1, 'broken config file: cannot find line z3=/path/to/z3 or several lines'

    path_tokens = [t.strip() for t in tool_lines[0].split('=') if t.strip()]
    assert len(path_tokens) == 2, 'unknown format of the path (the path itself should not contain "=")'

    path_to_the_tool = path_tokens[1]
    path_to_the_tool = path_to_the_tool.strip('"').strip("'")

    return path_to_the_tool


def create_spec_converter_z3(logger:logging.Logger):
    """ Return ltl to automaton converter, Z3 solver """

    #make paths independent of current working directory
    rel_path = str(os.path.relpath(__file__))
    bosy_dir_toks = ['./'] + rel_path.split(os.sep) #abspath returns 'windows' (not cygwin) path
    root_dir = ('/'.join(bosy_dir_toks[:-1]) + '/..') #root dir is one level up compared to bosy.py

    config_file_name = root_dir + '/../config'
    try:
        with open(config_file_name) as config_file:
            lines = [l.strip() for l in config_file.readlines() if l.strip()]
            z3_path = _get_tool_path('z3', lines)
            ltl2ba_path = _get_tool_path('ltl3ba', lines)

    except IOError:
        logger.exception('Cannot read config file (create it as described in readme file)')
        return None, None

    #TODO: port to other platforms
#    import platform
    flag_marker = '-'
#    if 'windows' in platform.system().lower() or 'nt' in platform.system().lower():
#        ltl2ba_path += '.exe'
#        flag_marker = '/'

    return Ltl2UCW(ltl2ba_path), Z3(z3_path, flag_marker)

