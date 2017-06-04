import logging

from interfaces.LTS import LTS
from module_generation.lts_to_verilog import lts_to_verilog
from module_generation.verilog_to_aiger_via_yosys import verilog_to_aiger


def lts_to_aiger(lts:LTS) -> str:
    module_name = 'model'
    v = lts_to_verilog(lts, module_name)
    logging.debug('verilog output is \n' + v)
    return verilog_to_aiger(v, module_name)