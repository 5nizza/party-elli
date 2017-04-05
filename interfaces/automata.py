from functools import lru_cache
from typing import Iterable, Dict, Set, Tuple

from helpers.hashable_dict import HashableDict
from interfaces.expr import Signal


class Label(HashableDict):  # TODO: use Expr instead (cube)
    """
    _hashable_ dict: signal -> True/False
    Label({}) means 'True'
    And there is no need for 'False'
    """
    pass


LABEL_TRUE = Label(dict())


class Node:
    def __init__(self, name:str):
        self.name = name       # type: str
        self.transitions = {}  # type: Dict[Label, Set[Tuple['Node', bool]]]
        # transitions is Dict: label -> {(dst_node, is_final), (dst_node, is_final), ...}

    def add_transition(self,
                       label:Dict[Signal, bool],
                       dst_isFin_pairs:Iterable[Tuple['Node', bool]]):
        """ Several calls with the same `label` is allowed -
            this means that transition is 'non-deterministic' or 'universal'.
            But the same destination should never appear twice in both calls (that is just strange).
            :param: dst_isFin_pairs is of the form {(node, is_final), (node, is_final), ...}
        """
        label = Label(label)
        cur_dst_isFin_pairs = self.transitions[label] = self.transitions.get(label, set())

        assert not set(dst_isFin_pairs).intersection(cur_dst_isFin_pairs), \
            '\n'.join(map(str, [self.name,
                                label,
                                dst_isFin_pairs,
                                cur_dst_isFin_pairs]))

        cur_dst_isFin_pairs.update(dst_isFin_pairs)

    def __str__(self):
        labels_strings = []
        for l, dst_isFin_pairs in self.transitions.items():
            labels_strings.append('[{0}: {1}]'.format(str(l), str(dst_isFin_pairs)))

        return "{0}, transitions: {1}".format(self.name, ' '.join(labels_strings))

    def __lt__(self, other):
        return id(self) < id(other)

    def __repr__(self):
        return "{0}".format(self.name)


class Automaton:
    def __init__(self,
                 init_nodes:Iterable[Node],
                 nodes:Iterable[Node],
                 name=''):
        self.init_nodes = set(init_nodes)     # type: Set[Node]
        self.nodes = set(nodes)               # type: Set[Node]
        self.name = name                      # type: str

    def __str__(self):
        return self.name or 'Unnamed' + \
               "\nnodes:\n" + \
               "\n".join([str(x) for x in self.nodes]) + \
               "\n init nodes:\n" + \
               "\n".join([str(x) for x in self.init_nodes])

    __repr__ = __str__


# ------------------------------------------------------------------------
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
def get_next_states(n:Node, i_o:Label) -> Set[Node]:
    dst_nodes = set()
    for lbl, node_flag_pairs in n.transitions.items():
        dst = map(lambda node_flag: node_flag[0], node_flag_pairs)

        if is_satisfied(lbl, i_o):
            dst_nodes.update(dst)

    return dst_nodes

