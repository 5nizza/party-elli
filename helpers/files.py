import os
import sys
import tempfile


def create_tmp_file(text:str= "", suffix="") -> str:
    (fd, file_name) = tempfile.mkstemp(text=True, suffix=suffix)
    if text:
        os.write(fd, bytes(text, sys.getdefaultencoding()))
    os.close(fd)
    return file_name
