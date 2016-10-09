from typing import Set

from interfaces.automata import Label, LABEL_TRUE


def _has_common_label(label1:Label, label2:Label) -> bool:
    for k in label1:
        if k in label2 and label2[k] != label1[k]:
            return False
    return True


def common_label(label1:Label, label2:Label) -> Label:
    if not _has_common_label(label1, label2):
        return None

    new_dict = dict(label1)
    new_dict.update(label2)
    return Label(new_dict)


def negate_label(label:Label) -> Set[Label]:
    """ empty set means label `false` here """

    if label == LABEL_TRUE:
        return set()

    negation_labels = set()  # type: Set[Label]
    for sig in label:
        n_l = Label(label)
        n_l[sig] = not label[sig]
        negation_labels.add(n_l)
    return negation_labels
