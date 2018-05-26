#!/usr/bin/env python3

import argparse
import os

CONFIG_PY_NAME = 'config.py'

CONFIG_PY_TEXT = """
from helpers.main_helper import get_root_dir

Z3_PATH = 'z3'

# The following are needed for SYNTCOMP rally_* and related tools.
SDF_HOA_PATH=get_root_dir() + '/additional-tools/sdf-hoa/binary/sdf-hoa'
YOSYS_PATH='/home/ayrat/projects/yosys/yosys'
SDF_PATH='/home/ayrat/projects/sdf/binary/sdf'
AIGTOAIG_PATH='/home/ayrat/projects/aiger-1.9.4/aigtoaig'
SMVTOAIG_PATH='/home/ayrat/projects/aiger-1.9.4/smvtoaig'
COMBINEAIGER_PATH='/home/ayrat/projects/syntcomp/tools/aiger-ltl-model-checker/combine-aiger'
SYFCO_PATH='syfco'
LTL2SMV_PATH='/home/ayrat/projects/NuSMV-2.6.0-Linux/bin/ltl2smv'  # used by smvtoaig

# IIMC is only if you plan to model check the results (e.g. using `check_model.py`)
IIMC_PATH='/home/ayrat/projects/iimc-2.0/iimc'

# LTL3BA is _not_ used by default, but if you request --ltl3ba, then provide this:
LTL3BA_PATH = '/home/ayrat/projects/ltl3ba/ltl3ba-1.1.2/ltl3ba'

# these do not seem to be used anymore by default
VL2MV_PATH='/home/ayrat/projects/vl2mv-2.4/vl2mv'


if __name__ == '__main__':
    print("open me and modify paths")
"""


def _get_root_dir():
    return os.path.dirname(os.path.abspath(__file__))


def _user_confirmed(question):
    answer = input(question + ' [y/N] ').strip() or 'n'  # note: '' _is_ in 'yY'
    assert answer in 'yYnN', answer
    return answer in 'yY'


def _check_files_exist(files):
    existing = list(filter(lambda f: os.path.exists(f), files))
    return existing


def main():
    config_py = os.path.join(_get_root_dir(), CONFIG_PY_NAME)
    existing = _check_files_exist([CONFIG_PY_NAME])
    if not existing or \
            _user_confirmed('{files} already exist(s).\n'.format(files=existing) +
                            'Replace?'):
        with open(config_py, 'w') as file:
            file.write(CONFIG_PY_TEXT)
        print('Created files: {files}\n'
              'Now edit them with your paths.'.
              format(files=','.join([CONFIG_PY_NAME])))
        #
        return True
    #
    return False


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=
                                     'Generate local configuration file')

    args = parser.parse_args()
    res = main()
    print(['not done', 'done'][res])
    exit(res)
