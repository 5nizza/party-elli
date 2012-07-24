# coding=utf-8
class Clause:
    OR, AND, TERM = 'or', 'and', 'term'

    def __init__(self, type, data):
        self._data = data
        self._type = type
        assert self._type in (self.OR, self.AND, self.TERM)

    @property
    def data(self):
        return self._data

    @property
    def type(self):
        return self._type

    def __str__(self): #used in tests
        if self.type == self.TERM:
            return str(self.data)

        children = []
        for child in self.data:
            children.append(str(child))

        res = (' + ' if self.type == self.OR else '·').join(children)
        if self.type == self.OR:
            res = '(' + res + ')'
        return res


def make_dnf(clause):
    crt_clause = clause
    while True:
        simplified_clause = apply_distributivity_rule()
        if simplified_clause is crt_clause:
            return crt_clause



def _simplify_dnf(dnf_root_node):
    """ Apply simplifications: remove true/false/implied.
        Input is assumed in DNF form.
    """

    root_node = _remove_falses_from_dnf(dnf_root_node)
    root_node = _remove_trues_from_cnf(root_node)
    root_node = _remove_duplicates_in_cnf(root_node)
    root_node = _remove_duplicates_in_dnf(root_node)
    root_node = _remove_implied_dnf(root_node)

    return root_node










