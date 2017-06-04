import os
import logging

from config import SDF_PATH
from helpers.files import create_tmp_file
from helpers.logging_helper import log_entrance
from helpers.shell import execute_shell
from syntcomp.aiger_to_tlsf_model import convert_aiger_model_to_tlsf
from syntcomp.syntcomp_constants import REALIZABLE_STR


@log_entrance()
def synthesize(aiger_spec:str, bad_out_name:str) -> str or None:
    aiger_file = create_tmp_file(aiger_spec)
    logging.debug("synthesize: using %s to store aiger_spec" % aiger_file)

    rc, out, err = execute_shell(
        '{sdf} {aiger_file} -f'.format(sdf=SDF_PATH, aiger_file=aiger_file))

    out_split = out.splitlines()
    status = out_split[0]
    if status == REALIZABLE_STR:
        full_model = convert_aiger_model_to_tlsf('\n'.join(out_split[1:]), bad_out_name)
        os.remove(aiger_file)
        return full_model

    os.remove(aiger_file)
    return None
