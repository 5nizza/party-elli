def get_add(dict, name, default):
    res = dict[name] = dict.get(name, default)
    return res