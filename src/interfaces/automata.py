from functools import lru_cache
from itertools import product
from typing import Iterable

from helpers.hashable import HashableDict


class Automaton:
    def __init__(self, init_nodes, acc_nodes, nodes:Iterable[Node], name=''):
        self._init_nodes = set(init_nodes)
        self._acc_nodes = set(acc_nodes)
        self._nodes = set(nodes)
        self._name = name

    @property
    def name(self):
        return self._name

    @property
    def nodes(self):
        return self._nodes

    @property
    def initial_nodes(self) -> set:
        return self._init_nodes

    @property
    def acc_nodes(self):
        # TODO: attention: will deprecated for rejecting edges automaton
        # TODO: rename to final nodes
        return self._acc_nodes

    def __str__(self):
        return self._name + \
               "\nnodes:\n" + \
               "\n".join([str(x) for x in self._nodes]) + \
               "\n initial nodes:\n" + \
               "\n".join([str(x) for x in self._init_nodes]) + \
               "\n acc nodes:\n" + \
               "\n".join([str(x) for x in self._acc_nodes])

    __repr__ = __str__


class Label(HashableDict):
    """
    hashable dict: signal -> True/False
    Label({}) means 'True'
    And there is no need for 'False'
    """
    pass

LABEL_TRUE = Label(dict())


class Node:
    def __init__(self, name, transitions=None):
        self._name = name
        assert name != '0'  # TODO: why? remove me
        if transitions is None:
            self._transitions = {}  # label -> {node1,...}

    @property
    def name(self):
        return self._name

    @property
    def transitions(self) -> dict:
        """
        :return: dict { label -> {(is_acc,node), ...} }
        """
        return self._transitions

    def add_transition(self, label, dst_node_flag_pairs):
        """ Add transitions.
            Several calls with the same label are allowed -
            this means that transition is non-deterministic.
            Second call with the same
        """
        label = Label(label)
        cur_dst_node_flag_pairs = self._transitions[label] = self._transitions.get(label, set())

        assert not set(dst_node_flag_pairs).issubset(cur_dst_node_flag_pairs), \
            '\n'.join(map(str, [self._name,
                                label,
                                dst_node_flag_pairs,
                                cur_dst_node_flag_pairs]))

        cur_dst_node_flag_pairs.update(dst_node_flag_pairs)

    def __str__(self):
        labels_strings = []
        for l, node_flag_pairs in self.transitions.items():
            labels_strings.append('[{0}: {1}]'.format(str(l), str(node_flag_pairs)))

        return "{0}, transitions: {1}".format(self.name, ' '.join(labels_strings))

    def __lt__(self, other):
        return id(self) < id(other)

    def __repr__(self):
        return "{0}".format(self.name)

# ------------------------------CONSTANTS---------------------------------
DEAD_END = Node('dead')
DEAD_END.add_transition(LABEL_TRUE, {(DEAD_END, True)})

LIVE_END = Node('live')
LIVE_END.add_transition(LABEL_TRUE, {(LIVE_END, False)})


# ------------------------------ HELPER FUNCTIONS -------------------------
def is_satisfied(label, signal_values):
    """
    Do signal values satisfy the label?

    >>> is_satisfied({'r':True}, dict())
    True

    >>> is_satisfied(dict(), {'r':True})
    True

    >>> is_satisfied({'r':True}, {'r':True, 'g':False})
    True

    >>> is_satisfied({'r':True, 'g':False}, {'g':False})
    True

    >>> is_satisfied({'g':False}, {'r':True})
    True
    """

    for var, val in signal_values.items():
        if var not in label:
            continue
        if label[var] != val:
            return False
    return True


@lru_cache()
def all_stimuli_that_satisfy(label:Label, alphabet) -> set:    # TODO: unused?
    bound_signals = set(filter(lambda sig: sig in label, alphabet))
    free_signals = set(alphabet).difference(bound_signals)

    if not free_signals:
        return [label]

    bound_signals_dict = dict((k, label[k]) for k in bound_signals)

    stimuli = set()
    for free_signals_value in product([True, False], repeat=len(free_signals)):
        stimulus = dict(bound_signals_dict)  # copy

        free_sig_val_pairs = zip(free_signals, free_signals_value)
        free_signals_dict = dict(free_sig_val_pairs)
        stimulus.update(free_signals_dict)

        stimuli.add(Label(stimulus))

    return stimuli


@lru_cache()
def get_next_states(n:Node, i_o:Label) -> set:   # TODO: use it or remove it
    dst_nodes = set()
    for lbl, node_flag_pairs in n.transitions.items():
        dst = map(lambda node_flag: node_flag[0], node_flag_pairs)

        if is_satisfied(lbl, i_o):
            dst_nodes.update(dst)

    return dst_nodes
