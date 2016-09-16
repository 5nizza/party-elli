#!/usr/bin/env python3
import argparse
import logging

from config import LTL3BA_PATH
from ctl2aht_ import ctl2aht
from helpers import aht2dot
from helpers.main_helper import setup_logging
from interfaces.aht_automaton import SharedAHT, DstFormulaPropMgr
from ltl3ba.ltl2automaton import LTL3BA


def main(spec_file_name:str, should_print_all:bool) -> 0:
    setup_logging(args.verbose)
    logging.info(args)

    ltl3ba = LTL3BA(LTL3BA_PATH)
    shared_aht, dstFormPropMgr = SharedAHT(), DstFormulaPropMgr()
    aht = ctl2aht.ctl2aht(spec, ltl3ba, shared_aht, dstFormPropMgr)

    if should_print_all:
        dot = aht2dot.convert(shared_aht, dstFormPropMgr)
    else:
        dot = aht2dot.convert(aht, dstFormPropMgr)

    print(dot)

    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='ctl* -> aht -> dot. Print the result to stdout.',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('spec', metavar='spec', type=str,
                        help='spec file (python code)')

    args = parser.parse_args()

    status = main(args.spec)
    exit(status)
