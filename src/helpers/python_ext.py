def get_add(dict, name, default):
    res = dict[name] = dict.get(name, default)
    return res

def is_empty_str(s):
    return s is None or s==''