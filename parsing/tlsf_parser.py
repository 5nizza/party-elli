from typing import Iterable, Tuple

from config import SYFCO_PATH
from helpers.python_ext import readfile
from helpers.shell import execute_shell, assert_exec_strict


def _parse_tuple_str(tuple_str) -> Iterable[str]:
    return [s.strip() for s in tuple_str.split(',') if s.strip()]


def get_spec_type(spec_file_name) -> bool:
    rc, out, err = execute_shell('{syfco} -g {spec_file_name}'.format(syfco=SYFCO_PATH,
                                                                      spec_file_name=spec_file_name))
    assert_exec_strict(rc, out, err)
    out_stripped = out.strip().lower()
    assert out_stripped in ['moore', 'mealy'], out_stripped
    return out_stripped == 'moore'


def convert_tlsf_or_acacia_to_acacia(spec_file_name:str, is_moore_=None) -> Tuple[str, str, bool]:
    if spec_file_name.endswith('.ltl'):
        ltl_text, part_text = readfile(spec_file_name), readfile(spec_file_name.replace('.ltl', '.part'))
        return ltl_text, part_text, is_moore_

    rc, out, err = execute_shell('{syfco} -ins {spec_file_name}'.format(syfco=SYFCO_PATH,
                                                                        spec_file_name=spec_file_name))
    assert_exec_strict(rc, out, err)
    part_text = '.inputs ' + ' '.join(_parse_tuple_str(out.lower()))  # syfco lowers all signal names in props
    rc, out, err = execute_shell('{syfco} -outs {spec_file_name}'.format(syfco=SYFCO_PATH,
                                                                         spec_file_name=spec_file_name))
    assert_exec_strict(rc, out, err)
    part_text += '\n.outputs ' + ' '.join(_parse_tuple_str(out.lower()))  # syfco lowers all signal names in props
    # rc, out, err = execute_shell('{syfco} -f acacia -m fully -os Moore {spec_file_name}'
    #                              .format(syfco=SYFCO_PATH, spec_file_name=spec_file_name))
    # rc, out, err = execute_shell('{syfco} -f acacia -m fully {spec_file_name}'
    #                              .format(syfco=SYFCO_PATH, spec_file_name=spec_file_name))
    rc, out, err = execute_shell('{syfco} -f lily -m fully -nr {spec_file_name}'
                                 .format(syfco=SYFCO_PATH, spec_file_name=spec_file_name))
    assert_exec_strict(rc, out, err)
    ltl_text = out

    return ltl_text, part_text, get_spec_type(spec_file_name)
