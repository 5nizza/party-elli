import importlib
import os
import sys
from interfaces.expr import Signal


def parse_python_spec(spec_file_name:str):
    # TODO: do not allow upper letters in the spec
    code_dir = os.path.dirname(spec_file_name)
    code_file = os.path.basename(spec_file_name.strip('.py'))

    sys.path.append(code_dir)

    saved_path = sys.path   # to ensure we import the right file
    # (imagine you want /tmp/spec.py but there is also ./spec.py,
    # then python prioritizes to ./spec.py)
    # To force the right version we change sys.path temporarily.
    sys.path = [code_dir]
    spec = importlib.import_module(code_file)
    sys.path = saved_path

    input_signals = [Signal(s) for s in spec.inputs]
    output_signals = [Signal(s) for s in spec.outputs]

    S_a_init = parse_ltl3ba_expr(getattr(spec,'S_a_init', None))
    S_a_trans = parse_ltl3ba_expr(getattr(spec,'S_a_trans', None))
    L_a_property = parse_ltl3ba_expr(getattr(spec,'L_a_property', None))
    S_g_init = parse_ltl3ba_expr(getattr(spec,'S_g_init', None))
    S_g_trans = parse_ltl3ba_expr(getattr(spec,'S_g_trans', None))
    L_g_property = parse_ltl3ba_expr(getattr(spec,'L_g_property', None))

    return input_signals, output_signals, \
           convert_into_gr1_formula(S_a_init, S_g_init, S_a_trans, S_g_trans, L_a_property, L_g_property)
