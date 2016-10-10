from itertools import combinations
from typing import Dict, Set, Tuple, Iterable
from typing import List

from helpers.nbw_automata_helper import common_label, negate_label
from helpers.python_ext import lfilter
from interfaces.aht_automaton import Transition as AHTTransition
from interfaces.automata import Automaton as NBWAutomaton
from interfaces.automata import Node as NBWNode
from interfaces.automata import Label
from third_party.goto import goto


def _assert_no_label_intersections(transitions:Dict[Label, Set[Tuple[bool,NBWNode]]]):
    """
    Checks that there exists no state that has two intersecting labels in some transition.
    """
    for l1,l2 in combinations(transitions.keys(), 2):
        assert common_label(l1, l2) is None, '{l1} intersects with {l2}'.format(l1=l1, l2=l2)


# TODO: merge these two version of normalize -- by removing NBWAutomaton and using only AHT?
@goto
def normalize_nbw_transitions(transitions:Dict[Label, Set[Tuple[bool, NBWNode]]])\
        -> Dict[Label, Set[Tuple[bool,NBWNode]]]:

    while True:
        # pick two intersecting 'transitions':
        l1, l2 = (lfilter(lambda l_l: common_label(l_l[0], l_l[1]) is not None,
                          combinations(transitions.keys(), 2))
                  + [(None, None)])[0]
        if l1 is None:
            break

        t_split = []  # type: List[Tuple[Label, Set[Tuple[bool, NBWNode]]]]

        t_split.append((common_label(l1,l2), transitions[l1] | transitions[l2]))

        nl2_labels = negate_label(l2)
        for nl2 in nl2_labels:
            l1_nl2 = common_label(l1, nl2)
            if l1_nl2 is not None:
                t_split.append((l1_nl2, transitions[l1]))

        nl1_labels = negate_label(l1)
        for nl1 in nl1_labels:
            nl1_l2 = common_label(nl1, l2)
            if nl1_l2 is not None:
                t_split.append((nl1_l2, transitions[l2]))

        # NB: we can remove t1 and t2, since the newly generated transitions cover them
        del transitions[l1]
        del transitions[l2]
        transitions.update(t_split)

    return transitions

















    label .restart  # see decorator goto on how to use labels and GOTOs
    new_transitions = dict(transitions.items())  # type: Dict[Label, Set[Tuple[bool,'Node']]]:
    for l1,l2 in combinations(transitions.keys(), 2):  # type: Tuple[Label,Label]
        l1_l2  = common_label(l1, l2)
        if l1_l2 is None:
            continue

        new_transitions[l1_l2] = transitions[l1] | transitions[l2]

        assert 0, "bug here -- it assumes that negate_label returns a single label," \
                  "while it returns a set"
        l1_nl2 = common_label(l1, negate_label(l2))
        if l1_nl2 is not None:
            new_transitions[l1_nl2] = transitions.get(l1_nl2, set()) | transitions[l1]

        nl1_l2 = common_label(negate_label(l1), l2)
        if nl1_l2 is not None:
            new_transitions[nl1_l2] = transitions.get(nl1_l2, set()) | transitions[l2]

        if new_transitions != transitions:
            transitions = new_transitions
            goto .restart
    # end of `for l1,l2 in ...`

    return new_transitions


def pick_two_intersecting_transitions(transitions:Iterable[AHTTransition])\
        -> Tuple[AHTTransition, AHTTransition]:
    """"""
    for t1,t2 in combinations(transitions, 2):
        if common_label(t1.state_label, t2.state_label) is not None:
            return t1,t2
    return None, None


def normalize_aht_transitions(transitions:Iterable[AHTTransition]) \
        -> Set[AHTTransition]:
    # NB: assumption: the automaton that we normalize is non-det (since we do dst_expr1 _&_ dst_expr2)
    # NB: @goto: no vars called `label`, `goto`!

    transitions = set(transitions)  # type: Set[AHTTransition]

    while True:
        t1,t2 = pick_two_intersecting_transitions(transitions)
        if t1 is None:
            break

        l1, l2 = t1.state_label, t2.state_label
        t_split = []

        l1_l2 = common_label(l1, l2)
        t_l1_l2 = AHTTransition(t1.src, l1_l2, t1.dst_expr | t2.dst_expr)  # todo: non-repeating OR
        t_split.append(t_l1_l2)

        nl2_labels = negate_label(l2)
        for nl2 in nl2_labels:
            l1_nl2 = common_label(l1, nl2)
            if l1_nl2 is not None:
                t_split.append(AHTTransition(t1.src, l1_nl2, t1.dst_expr))

        nl1_labels = negate_label(l1)
        for nl1 in nl1_labels:
            nl1_l2 = common_label(nl1, l2)
            if nl1_l2 is not None:
                t_split.append(AHTTransition(t2.src, nl1_l2, t2.dst_expr))

        # NB: we can remove t1 and t2, since the newly generated transitions cover them
        transitions.remove(t1)
        transitions.remove(t2)
        transitions.update(t_split)

    return transitions


def normalize_nbw_inplace(nbw:NBWAutomaton):
    """
    Modifies nbw!  Ensures:

      for every state: no two transitions with the same label

    Thus, the transitions, that are of the form

        dict { label1 : {(is_acc,n1),(is_acc,n2),...},
               label2 : ... }

    , have no intersecting labels.
    """
    for n in nbw.nodes:  # type: NBWNode
        new_transitions = normalize_nbw_transitions(n.transitions)
        _assert_no_label_intersections(new_transitions)
        n._transitions = new_transitions  # FIXME: fix access to the private member


