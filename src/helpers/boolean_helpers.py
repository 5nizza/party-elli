from collections import defaultdict
from itertools import combinations
import unittest
from helpers.console_helpers import print_green

from interfaces.automata import Label
from third_party import boolean
from third_party.boolean import Expression


def parse_label(lbl:Label, variables:dict) -> Expression:
    assert lbl
    for signal, value in lbl.items():
        cube = boolean.TRUE
        var = variables[signal] = variables.get(signal, boolean.parse(signal))
        if not value:
            var = ~var
        cube = cube * var
    return cube


str_to_signal = None
signal_to_str = None


def _get_set_from_label(lbl:Label) -> set:
    assert isinstance(lbl, Label)
    # print('lbl=', lbl)
    # for l in lbl:
        # print('l=', l)
        # print('lbl[l]=', lbl[l])
    global signal_to_str

    print_green(signal_to_str)
    print_green([lbl[l] for l in lbl])

    return set(('~', '')[lbl[l]]+signal_to_str[l]
               for l in lbl)


def _get_label_from_set(s:set) -> Label:
    global str_to_signal
    return Label((str_to_signal[e.strip('~')], not e.startswith('~')) for e in s)


def _resolve_consensus(lbl1:Label, lbl2:Label)->Label:
    """
    A & s, A &-s
    ------------ 'my consensus'
        A
    """
    lits1 = _get_set_from_label(lbl1)
    lits2 = _get_set_from_label(lbl2)

    diff_lits = lits1.symmetric_difference(lits2)
    diff_vars = set(l.strip('~') for l in diff_lits)
    if len(diff_lits) == 2 and len(diff_vars) == 1:
        resolvent = set(lits1)
        resolvent.discard(diff_lits.pop())
        resolvent.discard(diff_lits.pop())
        return _get_label_from_set(resolvent)

    return None


def _remove_subsumed_except_me(cur_set:set, subsumer:Label)->set:
    subsumer = _get_set_from_label(subsumer)
    result = set(cur_set)
    for l in cur_set:
        l_set = _get_set_from_label(l)
        if subsumer.issubset(l_set) and not subsumer.issuperset(l_set):
            result.remove(l)
    return result


def _populate_the_dicts(set_of_labels):
    global str_to_signal
    global signal_to_str
    str_to_signal = dict()
    signal_to_str = dict()
    for lbl in set_of_labels:
        for sig in lbl:
            str_to_signal[str(sig)] = sig
            signal_to_str[sig] = str(sig)


def _check_subsumption(cur_set):
    to_check = set(cur_set)
    while to_check:
        lbl = to_check.pop()
        updated_set = _remove_subsumed_except_me(cur_set, lbl)
        removed = cur_set.difference(updated_set)
        to_check.difference_update(removed)
        cur_set.difference_update(removed)
    return cur_set


def minimize_dnf_set(set_of_labels) -> set:  # TODO: highly inefficient -- numerous requests to get_set_from_label
    if not set_of_labels:
        return set_of_labels

    _populate_the_dicts(set_of_labels)

    # consensus and subsumption rules till fix-point
    cur_set = set(set_of_labels)
    while True:
        cur_set = _check_subsumption(cur_set)

        new_set = set()
        for (lbl1, lbl2) in combinations(cur_set, 2):
            resolvent = _resolve_consensus(lbl1, lbl2)
            if resolvent == dict():  # True
                cur_set = set()
            elif resolvent is not None:
                new_set.update({resolvent})
        if not cur_set:  # transition labeled with True
            break
        if new_set.issubset(cur_set):  # nothing new can be derived
            break
        cur_set.update(new_set)

    return cur_set


class Test(unittest.TestCase):
    def setUp(self):
        global str_to_signal
        global signal_to_str
        str_to_signal = dict()
        signal_to_str = dict()
        for letter in ['a', 'b', 'c', 'd', 'e', 'f']:
            str_to_signal[letter] = signal_to_str[letter] = letter


    def test__resolve_consensus(self):
        lbl1 = Label({'a':True, 'c':True, 'b':True})
        lbl2 = Label({'a':True, 'c':True, 'b':False})

        res = _resolve_consensus(lbl1, lbl2)
        self.assertDictEqual(res, Label({'a':True, 'c':True}))

    def test__resolve_consensus2(self):
        lbl1 = Label({'a':True, 'b':True, 'c':False})
        lbl2 = Label({'a':True, 'b':False, 'c':True})

        res = _resolve_consensus(lbl1, lbl2)
        assert res is None

    def test__resolve_consensus3(self):
        lbl1 = Label({'a':True})
        lbl2 = Label({'a':False})

        res = _resolve_consensus(lbl1, lbl2)
        self.assertDictEqual(res, dict())

    def test__resolve_consensus4(self):
        lbl1 = Label({'a':True})
        lbl2 = Label({'a':True})

        res = _resolve_consensus(lbl1, lbl2)
        assert res is None

    def test__resolve_consensus5(self):
        lbl1 = Label({'a':True})
        lbl2 = Label({'a':True, 'b':True})

        res = _resolve_consensus(lbl1, lbl2)
        assert res is None

    def test__remove_subsumed(self):
        set_of_labels = {Label({'a':True, 'b':True, 'c':False}), Label({'b':True})}
        result = _remove_subsumed_except_me(set_of_labels, Label({'b':True}))

        self.assertSetEqual(result, {Label({'b':True})})

    def test__remove_subsumed2(self):
        set_of_labels = {Label({'a':True, 'b':False}), Label({'b':True})}
        result = _remove_subsumed_except_me(set_of_labels, Label({'b':True}))

        self.assertSetEqual(result, set_of_labels)

    def test__remove_subsumed3(self):
        set_of_labels = {Label({'a':True, 'b':True, 'c':False}), Label({'d':False}), Label({'b':True, 'c':False})}
        result = _remove_subsumed_except_me(set_of_labels, Label({'b':True, 'c':False}))

        self.assertSetEqual(result, {Label({'b':True, 'c':False}), Label({'d':False})})

    def test_minimize_dnf_set(self):
        labels = {_get_label_from_set({'~a', '~b', '~c'}),
                  _get_label_from_set({'a', '~b', '~c'}),
                  _get_label_from_set({'~a', 'b', '~c'}),
                  _get_label_from_set({'a', 'b', '~c'}),
                  _get_label_from_set({'~a', '~b', 'c'}),
                  _get_label_from_set({'a', '~b', 'c'}),
                  _get_label_from_set({'~a', 'b', 'c'}),
                  _get_label_from_set({'a', 'b', 'c'})}
        result = minimize_dnf_set(labels)

        self.assertSetEqual(result, set())

    def test_minimize_dnf_set2(self):
        labels = {_get_label_from_set({'a', 'b'}),
                  _get_label_from_set({'~a', 'b'}),
                  _get_label_from_set({'e'})}
        result = minimize_dnf_set(labels)

        self.assertSetEqual(result, {_get_label_from_set({'b'}), _get_label_from_set({'e'})})

if __name__ == "__main__":
    unittest.main()
