import logging
import os
import resource
import sys
import tempfile

from config import YOSYS_PATH, AIGTOAIG_PATH
from helpers.python_ext import readfile
from helpers.shell import execute_shell, assert_exec_strict, rc_out_err_to_str


def _create_tmp_file(text:str= "", suffix="") -> str:
    (fd, file_name) = tempfile.mkstemp(text=True, suffix=suffix)
    if text:
        os.write(fd, bytes(text, sys.getdefaultencoding()))
    os.close(fd)
    return file_name


def verilog_to_aiger2(verilog:str, module_name:str) -> str:
    verilog_file_name = _create_tmp_file(verilog, suffix='.v')
    aiger_file_name = _create_tmp_file(suffix='.aag')

    script = """
    read_verilog {verilog_file}
    synth -flatten -top {module_name}
    abc -g AND
    write_aiger -ascii -symbols {aiger_file}""".format(aiger_file=aiger_file_name,
                                                       module_name=module_name,
                                                       verilog_file=verilog_file_name)
    script_file_name = _create_tmp_file(text=script, suffix='.ys')

    files_to_remove = (aiger_file_name,
                       verilog_file_name,
                       script_file_name)  # tmp files stay if smth goes wrong

    rc, out, err = execute_shell('{yosys} -s {script}'.format(yosys=YOSYS_PATH,
                                                              script=script_file_name))
    assert_exec_strict(rc, out, err)
    logging.debug('yosys stdout:\n' + out)
    # assert rc == 0, rc_out_err_to_str(rc, out, err)

    # rc, out, err = execute_shell('{aigtoaig} {file_aiger_tmp} {file_output_aiger}'.format(
    #     aigtoaig=AIGTOAIG_PATH,
    #     file_aiger_tmp=file_aiger_tmp,
    #     file_output_aiger=file_output_aiger))
    # assert_exec_strict(rc, out, err)

    res = readfile(aiger_file_name)

    print(res)

    [os.remove(f) for f in files_to_remove]
    return res
