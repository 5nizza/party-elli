from synthesis.aiger_to_tlsf_model import convert_aiger_model_to_tlsf

from config import SDF_PATH
from helpers.shell import execute_shell
from syntcomp.syntcomp_constants import REALIZABLE_STR


def _parse_sdf_output(sdf_output:str) -> str:
    # need to remove 'bad' output and introduce 'full'
    return '\n'.join(sdf_output.splitlines()[1:])


def synthesize(aiger_spec:str) -> str or None:
    aiger_file = ''
    rc, out, err = execute_shell(
        '{sdf} {aiger_file} -f'.format(sdf=SDF_PATH, aiger_file=aiger_file))

    out_split = out.splitlines()

    status = out_split[0]
    if status == REALIZABLE_STR:
        full_model = convert_aiger_model_to_tlsf('\n'.join(out_split[1:]))
        return full_model
    return None
