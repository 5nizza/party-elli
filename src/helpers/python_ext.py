from collections import Iterable
import math

def get_add(dict, name, default):
    res = dict[name] = dict.get(name, default)
    return res


def is_empty_str(s):
    return s is None or s==''


def bin_fixed_list(int, width):
    """ Return list of boolean values """
    assert int >= 0, str(int)
    assert int <= math.pow(2, width)-1, str(int)

    bits = [bool(b!='0') for b in bin(int)[2:]]

    extension_size = width - len(bits)

    assert extension_size >= 0, str(extension_size)

    extended_bits = [False]*extension_size + bits
    return extended_bits


def index(lambda_func, iterable):
    for i, e in enumerate(iterable):
        if lambda_func(e):
            return i
    return None


class SmarterList(list):
    def __iadd__(self, other):
        self.__add__(other)
        return self
    def __add__(self, other):
        if isinstance(other, Iterable) and not isinstance(other, str):
            super().extend(other)
            return self
        else:
            super().append(other)
            return self
