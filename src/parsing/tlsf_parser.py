from typing import Iterable

from config import SYFCO_PATH
from helpers.shell import execute_shell, assert_exec_strict
from interfaces.expr import Expr, Signal
from parsing.acacia_parser_helper import parse_acacia_and_build_expr


def _parse_tuple_str(tuple_str) -> Iterable[str]:
    return [s.strip() for s in tuple_str.split(',') if s.strip()]


def parse_tlsf_build_expr(spec_file_name, ltl3ba)\
        -> (Iterable[Signal], Iterable[Signal], Expr, bool):
    """
    NOTE: it strengthens the formula (don't assume liveness for safety guarantees)
    :return: (input_signals, output_signals, ltl, is_moore)
    """

    rc, out, err = execute_shell('{syfco} -ins {spec_file_name}'.format(syfco=SYFCO_PATH,
                                                                        spec_file_name=spec_file_name))
    assert_exec_strict(rc, out, err)
    part_text = '.inputs ' + ' '.join(_parse_tuple_str(out))

    rc, out, err = execute_shell('{syfco} -outs {spec_file_name}'.format(syfco=SYFCO_PATH,
                                                                         spec_file_name=spec_file_name))
    assert_exec_strict(rc, out, err)
    part_text += '\n.outputs ' + ' '.join(_parse_tuple_str(out))

    rc, out, err = execute_shell('{syfco} -f acacia {spec_file_name}'.format(syfco=SYFCO_PATH,
                                                                             spec_file_name=spec_file_name))
    assert_exec_strict(rc, out, err)
    ltl_text = out

    input_signals, output_signals, expr = parse_acacia_and_build_expr(ltl_text,
                                                                      part_text,
                                                                      ltl3ba)

    rc, out, err = execute_shell('{syfco} -g {spec_file_name}'.format(syfco=SYFCO_PATH,
                                                                      spec_file_name=spec_file_name))
    assert_exec_strict(rc, out, err)
    out_stripped = out.strip().lower()
    assert out_stripped in ['moore', 'mealy'], out_stripped
    is_moore = out_stripped == 'moore'

    return input_signals, output_signals, expr, is_moore
