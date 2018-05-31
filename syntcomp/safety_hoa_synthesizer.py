import logging

from config import SDF_HOA_PATH
from helpers.python_ext import is_empty_str
from helpers.shell import execute_shell, rc_out_err_to_str
from syntcomp.syntcomp_constants import REALIZABLE_RC, UNREALIZABLE_RC


def run_safety_hoa_synthesizer(hoa_file:str,
                               part_file:str,
                               k:int,
                               is_moore:bool) -> bool:

    logging.info('executing sdf-hoa...')

    rc, out, err = execute_shell(
        '{sdf} {hoa_file} {part_file} -k {k} {is_moore}'.format(
            sdf=SDF_HOA_PATH,
            hoa_file=hoa_file,
            part_file=part_file,
            k=k,
            is_moore='--moore' if is_moore else ''))
    assert is_empty_str(err), rc_out_err_to_str(rc, out, err)
    assert rc in (REALIZABLE_RC, UNREALIZABLE_RC), rc_out_err_to_str(rc, out, err)

    logging.info('sdf-hoa finished')
    logging.debug('sdf-hoa returned:\n' + rc_out_err_to_str(rc, out, err))

    return rc==REALIZABLE_RC
