from typing import Iterable

from config import syfco_path
from helpers.shell import execute_shell, assert_exec_strict
from interfaces.expr import Expr, Signal
from parsing.acacia_parser_helper import parse_acacia_and_build_expr


def _parse_tuple_str(tuple_str) -> Iterable[str]:
    return [s.strip() for s in tuple_str.split(',') if s.strip()]


def parse_tlsf(spec_file_name, ltl3ba)\
        -> (Iterable[Signal], Iterable[Signal], Expr):
    """
    NOTE: it strengthens the formula (don't assume liveness for safety guarantees)
    :return: (input_signals, output_signals, ltl)
    """

    rc, out, err = execute_shell('{syfco} -ins {spec_file_name}'.format(syfco=syfco_path,
                                                                        spec_file_name=spec_file_name))
    assert_exec_strict(rc, out, err)
    part_text = '.inputs ' + ' '.join(_parse_tuple_str(out))

    rc, out, err = execute_shell('{syfco} -outs {spec_file_name}'.format(syfco=syfco_path,
                                                                         spec_file_name=spec_file_name))
    assert_exec_strict(rc, out, err)
    part_text += '\n.outputs ' + ' '.join(_parse_tuple_str(out))

    rc, out, err = execute_shell('{syfco} -f acacia {spec_file_name}'.format(syfco=syfco_path,
                                                                             spec_file_name=spec_file_name))
    assert_exec_strict(rc, out, err)
    ltl_text = out

    input_signals, output_signals, expr = parse_acacia_and_build_expr(ltl_text,
                                                                      part_text,
                                                                      ltl3ba)
    return input_signals, output_signals, expr
