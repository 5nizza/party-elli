#!/usr/bin/env python3
import argparse
import logging
import os
import tempfile

import sys

from config import SYFCO_PATH, SMVTOAIG_PATH, COMBINEAIGER_PATH, IIMC_PATH
from helpers.get_nof_properties import get_nof_properties
from helpers.main_helper import setup_logging
from helpers.shell import execute_shell, assert_exec_strict, rc_out_err_to_str


def _create_monitor_file(tlsf_file_name) -> str:
    rc, out, err = execute_shell('{syfco} -f smv {tlsf_file} -m fully'.format(syfco=SYFCO_PATH,
                                                                              tlsf_file=tlsf_file_name))
    assert_exec_strict(rc, out, err)

    rc, out, err = execute_shell('{smvtoaig} -a'.format(smvtoaig=SMVTOAIG_PATH), input=out)
    assert rc == 0, rc_out_err_to_str(rc, out, err)   # it outputs the LTL into stderr

    (fd, aag_file_name) = tempfile.mkstemp(text=True, suffix='.aag')
    os.write(fd, bytes(out, encoding=sys.getdefaultencoding()))
    os.close(fd)

    return aag_file_name


def _create_combined(model_file_name, monitor_aiger_file_name) -> str:
    rc, out, err = execute_shell('{combine} {spec_aiger} {model_aiger}'.format(
        combine=COMBINEAIGER_PATH,
        model_aiger=model_file_name,
        spec_aiger=monitor_aiger_file_name))
    assert_exec_strict(rc, out, err)

    (fd, aag_file_name) = tempfile.mkstemp(text=True, suffix='.aag')
    os.write(fd, bytes(out, encoding=sys.getdefaultencoding()))
    os.close(fd)

    return aag_file_name


def _model_check(combined_aiger_file:str) -> int:
    """ :return: 0 if correct, 1 if wrong """
    for pi in range(get_nof_properties(combined_aiger_file)):
        logging.debug('checking property ' + str(pi))
        rc, out, err = execute_shell('{IIMC} {aiger_file} --pi {pi}'.format(
            IIMC=IIMC_PATH,
            aiger_file=combined_aiger_file,
            pi=pi))
        assert rc == 0, 'model checking call failed: \n' + rc_out_err_to_str(rc, out, err)
        is_correct = out.splitlines()[0].strip() == '0'
        if not is_correct:
            return 1

    return 0


def main(model_file_name:str, tlsf_file_name:str, keep_tmp_files:bool):
    """ :return: 0 - model is correct, 1 - model is wrong """

    monitor_aiger_file_name = _create_monitor_file(tlsf_file_name)
    logging.debug('created monitor_aiger_file_name: ' + monitor_aiger_file_name)

    combined_aiger = _create_combined(model_file_name, monitor_aiger_file_name)
    logging.debug('created combined_aiger: ' + combined_aiger)

    res = _model_check(combined_aiger)
    logging.info('model is ' + ['correct', 'wrong'][res])

    if res == 0 and not keep_tmp_files:  # keep files if the model failed model checking
        os.remove(monitor_aiger_file_name)
        os.remove(combined_aiger)
    return res


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='I model check the aiger model found by Elli. '
                                                 'Return: 0 if correct, 1 if model is wrong.',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('model', metavar='model', type=str,
                        help='aiger model file')
    parser.add_argument('spec', metavar='spec', type=str,
                        help='tlsf spec file file')
    parser.add_argument('--tmp', action='store_true', required=False, default=False,
                        help='keep temporary files')
    parser.add_argument('-v', '--verbose', action='count', default=0,
                        help='verbosity level')

    args = parser.parse_args()
    setup_logging(args.verbose)
    exit(main(args.model, args.spec, args.tmp))
