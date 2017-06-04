import logging
import os

from config import YOSYS_PATH
from helpers.files import create_tmp_file
from helpers.python_ext import readfile
from helpers.shell import execute_shell, assert_exec_strict


def verilog_to_aiger(verilog:str) -> str:
    verilog_file_name = create_tmp_file(verilog, suffix='.v')
    aiger_file_name = create_tmp_file(suffix='.aag')

    script = """
    read_verilog {verilog_file}
    synth -flatten -auto-top
    abc -g AND
    write_aiger -ascii -symbols {aiger_file}""".format(aiger_file=aiger_file_name,
                                                       verilog_file=verilog_file_name)
    script_file_name = create_tmp_file(text=script, suffix='.ys')

    files_to_remove = (aiger_file_name,
                       verilog_file_name,
                       script_file_name)  # tmp files stay if smth goes wrong

    rc, out, err = execute_shell('{yosys} -s {script}'.format(yosys=YOSYS_PATH,
                                                              script=script_file_name))
    assert_exec_strict(rc, out, err)
    logging.debug('yosys stdout:\n' + out)

    res = readfile(aiger_file_name)

    [os.remove(f) for f in files_to_remove]
    return res
