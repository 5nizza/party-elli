#!/usr/bin/env python3

import argparse
import os
import stat

CONFIG_PY_NAME = 'config.py'

CONFIG_PY_TEXT = """
Z3_PATH = 'z3'
LTL3BA_PATH = '/home/ayrat/projects/ltl3ba/ltl3ba-1.1.2/ltl3ba'

# The following are needed only by `rally.py`.
# Ignore them if you don't need `rally.py`.

ABC_PATH='/home/ayrat/projects/abc/abc'
VL2MV_PATH='/home/ayrat/projects/vl2mv-2.4/vl2mv'
AIGTOAIG_PATH='/home/ayrat/projects/aiger-1.9.4/aigtoaig'
SMVTOAIG_PATH='/home/ayrat/projects/aiger-1.9.4/smvtoaig'
COMBINEAIGER_PATH='/home/ayrat/projects/syntcomp/tools/aiger-ltl-model-checker/combine-aiger'
SYFCO_PATH='syfco'


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
