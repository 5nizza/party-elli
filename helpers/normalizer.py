from itertools import combinations
from typing import Dict, Set, Tuple, Iterable
from typing import List

from helpers.nbw_automata_helper import common_label, negate_label
from helpers.python_ext import lfilter
from interfaces.aht_automaton import Transition as AHTTransition
from interfaces.automata import Automaton as NBWAutomaton
from interfaces.automata import Node as NBWNode
from interfaces.automata import Label


def _assert_no_label_intersections(transitions:Dict[Label, Set[Tuple[bool,NBWNode]]]):
    """
    Checks that there exists no state that has two intersecting labels in some transition.
    """
    for l1,l2 in combinations(transitions.keys(), 2):
        assert common_label(l1, l2) is None, '{l1} intersects with {l2}'.format(l1=l1, l2=l2)


# TODO: merge these two version of normalize -- by removing NBWAutomaton and using only AHT?
def normalize_nbw_transitions(node:NBWNode,
                              transitions:Dict[Label, Set[Tuple[bool, NBWNode]]])\
        -> Dict[Label, Set[Tuple[bool,NBWNode]]]:
    while True:
        # pick two intersecting 'transitions':
        all_intersecting_label_pairs = lfilter(lambda l_l: common_label(l_l[0], l_l[1]) is not None,
                                               combinations(transitions.keys(), 2))
        if not all_intersecting_label_pairs:
            break
        l1, l2 = all_intersecting_label_pairs[0]

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
        # Careful, we may have other transitions with exactly the same label!
        # => we do not replace but rather 'update'
        for (new_lbl, new_transitions) in t_split:
            if new_lbl in transitions:
                transitions[new_lbl].update(new_transitions)
            else:
                transitions[new_lbl] = new_transitions
        # this one is wrong!
        # transitions.update(t_split)

        node._transitions = transitions  # FIXME: fix access to the private member

    return transitions


def pick_two_intersecting_transitions(transitions:Iterable[AHTTransition])\
        -> Tuple[AHTTransition, AHTTransition]:
    """"""
    for t1,t2 in combinations(transitions, 2):
        assert t1.src == t2.src
        if common_label(t1.state_label, t2.state_label) is not None:
            return t1,t2
    return None, None


# TODO: rename, change the use (to iterate over nodes transitions, change this function too, to assume node transitions only)
def normalize_aht_transitions(transitions:Iterable[AHTTransition]) \
        -> Set[AHTTransition]:
    # NB: assumption: the automaton that we normalize is non-det (since we do dst_expr1 _&_ dst_expr2)
    for t in transitions:  # type: AHTTransition
        assert t.src.is_existential, "violates the method assumption"

    transitions = set(transitions)  # type: Set[AHTTransition]

    nodes = set(map(lambda t: t.src, transitions))
    for n in nodes:
        while True:
            node_transitions = lfilter(lambda t: t.src == n, transitions)
            t1,t2 = pick_two_intersecting_transitions(node_transitions)
            if t1 is None:
                break

            l1, l2 = t1.state_label, t2.state_label
            t_split = []  # type: List[AHTTransition]

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
            # In contrast to the NBW normalization,
            # we simply call `update` since `transitions` is a _set_ of objects like (src, label, dst_expr),
            # and thus we won't lose transitions with the same `src, label` but different `dst_expr`
            transitions.update(t_split)
        # end of while True
    # end of for n in nodes

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
        new_transitions = normalize_nbw_transitions(n, n.transitions)
        _assert_no_label_intersections(new_transitions)
        n._transitions = new_transitions  # FIXME: fix access to the private member


