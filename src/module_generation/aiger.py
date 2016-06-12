import logging
import tempfile
import os
import sys

import resource

from config import VL2MV_PATH, ABC_PATH, AIGTOAIG_PATH
from helpers.python_ext import readfile
from helpers.shell import execute_shell, assert_exec_strict, rc_out_err_to_str
from interfaces.lts import LTS
from module_generation.verilog import lts_to_verilog


def create_tmp_file(text:str="", suffix="") -> str:
    (fd, file_name) = tempfile.mkstemp(text=True, suffix=suffix)
    if text:
        os.write(fd, bytes(text, sys.getdefaultencoding()))
    os.close(fd)
    return file_name


def verilog_to_aiger(verilog:str) -> str:
    input_verilog_file = create_tmp_file(verilog, suffix='v')
    file_blif_mv = create_tmp_file(suffix='.mv')
    file_aiger_tmp = create_tmp_file(suffix='.aag')
    file_output_aiger = create_tmp_file(suffix='.aag')

    files_to_remove = (input_verilog_file,
                       file_blif_mv,
                       file_aiger_tmp,
                       file_output_aiger)  # tmp files stay if smth goes wrong

    # vl2mv
    # on some examples vl2mv fails with a standard stack limit, so we raise it
    hard_limit = resource.getrlimit(resource.RLIMIT_STACK)[1]
    resource.setrlimit(resource.RLIMIT_STACK, (hard_limit, hard_limit))
    rc, out, err = execute_shell('{vl2mv} {file_input_verilog} -o {file_blif_mv}'.format(
        vl2mv=VL2MV_PATH,
        file_input_verilog=input_verilog_file,
        file_blif_mv=file_blif_mv))
    if rc == -11:
        logging.warning('vl2mv caught SIGSEGV: ha-ha! Re-run me on this example, or manually convert into aiger')
        logging.debug('verilog was: ' + readfile(input_verilog_file))
    assert rc == 0, rc_out_err_to_str(rc, out, err)   # no check that stderr='' because vl2mv outputs the input file name

    # abc
    rc, out, err = execute_shell('{abc} -c '
                                 '"read_blif_mv {file_blif_mv}; '
                                  'strash; refactor; rewrite; dfraig; rewrite; dfraig; '
                                  'write_aiger -s {file_aiger_tmp}"'.format(
        file_blif_mv=file_blif_mv,
        abc=ABC_PATH,
        file_aiger_tmp=file_aiger_tmp))
    assert_exec_strict(rc, out, err)

    # aigtoaig
    rc, out, err = execute_shell('{aigtoaig} {file_aiger_tmp} {file_output_aiger}'.format(
        aigtoaig=AIGTOAIG_PATH,
        file_aiger_tmp=file_aiger_tmp,
        file_output_aiger=file_output_aiger))
    assert_exec_strict(rc, out, err)

    res = readfile(file_output_aiger)

    [os.remove(f) for f in files_to_remove]
    return res


def lts_to_aiger(lts:LTS) -> str:
    v = lts_to_verilog(lts)
    return verilog_to_aiger(v)
