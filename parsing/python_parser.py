import importlib
import os
import sys

from interfaces.spec import Spec


def parse_python_spec(spec_file_name:str) -> Spec:
    assert os.path.exists(spec_file_name), "file not found: " + spec_file_name
    assert spec_file_name.endswith('.py')

    code_file = os.path.basename(spec_file_name[:-3])
    code_dir = os.path.dirname(spec_file_name)

    sys.path.append(code_dir)

    saved_path = sys.path   # to ensure we import the right file
    try:
        # (imagine you want /tmp/spec.py but there is also ./spec.py,
        # then python prioritizes to ./spec.py)
        # To force the right version we change sys.path temporarily.
        sys.path = [code_dir]

        spec_module = importlib.import_module(code_file)
        return spec_module.spec
    finally:
        sys.path = saved_path
