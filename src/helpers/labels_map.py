from interfaces.automata import Label


class LabelsMap:
    def __init__(self, value_by_label:dict=None):
        if value_by_label is None:
            value_by_label = []
        self._value_by_label = list(value_by_label.items())

    def __getitem__(self, key:Label):
        if not isinstance(key, Label):
            raise TypeError(key)

        indices = [v for (l, v) in self._value_by_label
                   if set(l.items()).issubset(set(key.items()))]

        assert len(indices) == 0 or len(indices) == 1, str(indices) + ', for ' + str(key)

        if len(indices) == 1:
            return indices[0]
        elif len(indices) == 0:
            raise KeyError(key)
        else:
            assert 0, str(key) + ' leads to ambiguity: ' + str(indices)

    def __setitem__(self, key:Label, value):
        if not isinstance(key, Label):
            raise TypeError(key)

        assert key not in self
        self._value_by_label.append((key, value))

    def items(self):
        return list(self._value_by_label)

    def __iter__(self):
        print()
        return iter([l for (l,v) in self._value_by_label])

    def __contains__(self, item):
        try:
            self[item]
            return True
        except (KeyError, TypeError):
            return False

    def __str__(self):
        return str(self._value_by_label)

    __repr__ = __str__

################################################################################

import unittest
class Test(unittest.TestCase):
    def test_map_getitem(self):
        label_map = LabelsMap()

        label_map[Label({'a':False, 'b':False})] = True

        assert Label({'a':False, 'b':False}) in label_map
        assert label_map[Label({'a':False, 'b':False})] == True

        assert Label({'a':False, 'b':False, 'c':False}) in label_map
        assert label_map[Label({'a':False, 'b':False, 'c':False})] == True

        assert Label({'a':True, 'b':False}) not in label_map
        assert Label({'a':True}) not in label_map


    def test_map_setitem(self):
        map = LabelsMap()

        map[Label({'a':True})] = True
        assert map[Label({'a':True})] == True

#        map[Label({'a':True})] = False
#        assert map[Label({'a':True})] == False

        assert Label({'a':True, 'c':True}) in map

        assert Label({}) not in map

#        map[Label({})] = True
#        assert Label({}) in map
#        assert map[Label({'c':True, 'd':False})] == True

#
#    def test_map_delitem(self):
#        map = SetKeyMap()
#        map[Label({'a':True})] = True
#        assert Label({'a':True}) in map
#
#        del map[Label({'a':True})]
#        assert Label({'a':True}) not in map
#
#        map[Label({'a':True})] = True
#        assert Label({}) in map
#        del map[Label({})]
#        assert Label({}) not in map
#
