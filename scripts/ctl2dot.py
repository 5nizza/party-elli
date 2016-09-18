#!/usr/bin/env python3


#########################################################################
# To fix the problem with imports
# (if we run `./scripts/ctl2dot.py`, then party-elli root folder is not in sys.path),
# we do:
import sys
import os

PACKAGE_PARENT = '..'
SCRIPT_DIR = os.path.dirname(os.path.realpath(os.path.join(os.getcwd(), os.path.expanduser(__file__))))
sys.path.append(os.path.normpath(os.path.join(SCRIPT_DIR, PACKAGE_PARENT)))

# source:
# http://stackoverflow.com/a/16985066/801203
#########################################################################


import argparse
import logging
import importlib
from config import LTL3BA_PATH
from ctl2aht_ import ctl2aht
from helpers import aht2dot
from helpers.main_helper import setup_logging
from interfaces.aht_automaton import SharedAHT, DstFormulaPropMgr, get_reachable_from
from interfaces.spec import Spec
from ltl3ba.ltl2automaton import LTL3BA


def parse_python_spec(spec_file_name:str) -> Spec:
    code_dir = os.path.dirname(spec_file_name)
    code_file = os.path.basename(spec_file_name.strip('.py'))

    sys.path.append(code_dir)

    saved_path = sys.path   # to ensure we import the right file
    # (imagine you want /tmp/spec.py but there is also ./spec.py,
    # then python prioritizes to ./spec.py)
    # To force the right version we change sys.path temporarily.
    sys.path = [code_dir]
    spec_module = importlib.import_module(code_file)
    sys.path = saved_path

    spec = spec_module.spec

    return spec


def main(spec_file_name:str, should_print_all:bool) -> 0:

    ltl3ba = LTL3BA(LTL3BA_PATH)
    shared_aht, dstFormPropMgr = SharedAHT(), DstFormulaPropMgr()
    spec = parse_python_spec(spec_file_name)
    aht = ctl2aht.ctl2aht(spec, ltl3ba, shared_aht, dstFormPropMgr)

    dot = aht2dot.convert(None if should_print_all else aht.init_node,
                          shared_aht,
                          dstFormPropMgr)

    print(dot)

    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='ctl* -> aht -> dot. Print the result to stdout.',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('spec', metavar='spec', type=str,
                        help='spec file (python code)')

    parser.add_argument('--all', action='store_true', required=False, default=False,
                        help='print all automata and transitions generated'
                             '(rather than only those belonging to AHT)')

    parser.add_argument('-v', '--verbose', action='count', default=0)

    args = parser.parse_args()

    setup_logging(args.verbose)
    logging.debug(args)

    status = main(args.spec, args.all)
    exit(status)
