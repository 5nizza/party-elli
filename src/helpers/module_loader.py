import importlib
import md5
import os.path
import imp
import traceback
import sys


def load_module(code_path):
    try:
        try:
            code_dir = os.path.dirname(code_path)
            code_file = os.path.basename(code_path)

            fin = open(code_path, 'rb')

            importlib.import_module()
            return imp.load_source(md5.new(code_path).hexdigest(), code_path, fin)
        finally:
            try: fin.close()
            except: pass
    except ImportError as x:
        traceback.print_exc(file=sys.stderr)
        raise
    except:
        traceback.print_exc(file=sys.stderr)
        raise
