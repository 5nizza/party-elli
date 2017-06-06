import logging
import os

import resource

from config import YOSYS_PATH
from helpers.files import create_unique_file
from helpers.logging_helper import log_entrance
from helpers.python_ext import readfile
from helpers.shell import execute_shell, assert_exec_strict


@log_entrance()
def verilog_to_aiger(verilog:str) -> str:
    verilog_file_name = create_unique_file(verilog, suffix='.v')
    aiger_file_name = create_unique_file(suffix='.aag')

    script = """
    read_verilog {verilog_file}
    synth -flatten -auto-top
    abc -g AND
    write_aiger -ascii -symbols -zinit {aiger_file}""".format(aiger_file=aiger_file_name,
                                                       verilog_file=verilog_file_name)
    script_file_name = create_unique_file(text=script, suffix='.ys')

    files_to_remove = (aiger_file_name,
                       verilog_file_name,
                       script_file_name)  # tmp files stay if smth goes wrong

    # on some examples yosys fails with a standard stack limit, so we raise it
    hard_limit = resource.getrlimit(resource.RLIMIT_STACK)[1]
    resource.setrlimit(resource.RLIMIT_STACK, (hard_limit, hard_limit))
    rc, out, err = execute_shell('{yosys} -s {script}'.format(
        yosys=YOSYS_PATH, script=script_file_name))
    assert_exec_strict(rc, out, err)
    logging.debug('yosys stdout:\n' + out)

    res = readfile(aiger_file_name)

    [os.remove(f) for f in files_to_remove]
    return res
