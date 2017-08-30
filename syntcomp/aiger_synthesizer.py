import os
import logging

from config import SDF_PATH
from helpers.files import create_unique_file
from helpers.logging_helper import log_entrance
from helpers.python_ext import is_empty_str
from helpers.shell import execute_shell, rc_out_err_to_str
from syntcomp.aiger_to_tlsf_model import convert_aiger_model_to_tlsf
from syntcomp.syntcomp_constants import REALIZABLE_STR, REALIZABLE_RC, UNREALIZABLE_RC


@log_entrance()
def synthesize(aiger_spec:str, is_moore:bool, bad_out_name:str) -> str or None:
    aiger_file = create_unique_file(aiger_spec)
    logging.debug("synthesize: using %s to store aiger_spec" % aiger_file)

    logging.info('executing sdf...')

    rc, out, err = execute_shell(
        '{sdf} {aiger_file} -f {is_moore}'.format(
            sdf=SDF_PATH,
            aiger_file=aiger_file,
            is_moore='-moore' if is_moore else ''))
    assert is_empty_str(err), rc_out_err_to_str(rc, out, err)
    assert rc in (REALIZABLE_RC, UNREALIZABLE_RC), rc_out_err_to_str(rc, out, err)

    logging.info('sdf completed')
    logging.debug('sdf returned:\n' + out)

    out_split = out.splitlines()
    status = out_split[0]
    if status == REALIZABLE_STR:
        full_model = convert_aiger_model_to_tlsf('\n'.join(out_split[1:]), bad_out_name)
        os.remove(aiger_file)
        return full_model

    os.remove(aiger_file)
    return None
