from itertools import product
from helpers.console_helpers import print_green
from helpers.hashable import HashableDict

# TODO: XXX: remove Alternating automata functionality -- make it UCW/NBW
# TODO: XXX: remove flagged nodes functionality -- use acceptance on nodes
class Automaton:
    def __init__(self, init_nodes, rejecting_nodes, nodes, name=''):
        self._init_nodes = set(init_nodes)
        self._rejecting_nodes = set(rejecting_nodes)
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
        return self._rejecting_nodes

    def __str__(self):
        return self._name + \
               "\nnodes:\n" + \
               "\n".join([str(x) for x in self._nodes]) + \
               "\n initial nodes:\n" + \
               "\n".join([str(x) for x in self._init_nodes]) + \
               "\n acc nodes:\n" + \
               "\n".join([str(x) for x in self._rejecting_nodes])

    __repr__ = __str__


class Label(HashableDict):
    """
    hashable dict: signal -> True/False
    Label({}) means 'any value'
    """
    pass

LABEL_TRUE = Label(dict())


class Node:
    def __init__(self, name):
        self._transitions = {}  # label->[(set, is_rejecting), (set, is_rejecting), ..]
        self._name = name
        assert name != "0"

    @property
    def name(self):
        return self._name

    @property
    def transitions(self):   # TODO: change to dict: {(label:flagged_nodes)}
        """ Return dict { label->[ Set_of_flagged_nodes, Set_of_flagged_nodes..] } """
        return self._transitions

    def add_transition(self, label, flagged_nodes):
        """ Add transition:
            flagged_nodes - set of pairs (node, is_rejecting)
            Several calls with the same label are allowed - this means that transition is non-deterministic.
        """
        label = Label(label)
        label_transitions = self._transitions[label] = self._transitions.get(label, [])

        flagged_nodes_set = set(flagged_nodes)
        assert flagged_nodes_set not in label_transitions, \
            str(label_transitions) + ', ' + str(flagged_nodes_set) + ', ' + str(label) + ', ' + str(self._name)

        label_transitions.append(flagged_nodes_set)

    def __str__(self):
        labels_strings = []
        for l, dst_list in self.transitions.items():
            dst_strings = []
            for flagged_dst_set in dst_list:
                dst_strings.append('({0})'.format(str(', '.join(['{0}{1}'.format(n.name, ['', ':rej'][is_rejecting])
                                                                 for n, is_rejecting in flagged_dst_set]))))

            labels_strings.append('[{0}: {1}]'.format(str(l), ', '.join(dst_strings)))

        return "'{0}', transitions: {1}".format(self.name, ' '.join(labels_strings))

    def __lt__(self, other):
        return id(self) < id(other)

    def __repr__(self):
        return "'{0}'".format(self.name)

# ------------------------------CONSTANTS---------------------------------
DEAD_END = Node('dead')
DEAD_END.add_transition(Label({}), {(DEAD_END, True)})

LIVE_END = Node('live')
LIVE_END.add_transition(Label({}), {(LIVE_END, False)})


# ------------------------------ HELPER FUNCTIONS -------------------------
def is_satisfied(label, signal_values):
    """ Do signal values satisfy the label? """

    for var, val in signal_values.items():
        if var not in label:
            continue
        if label[var] != val:
            return False
    return True


def all_stimuli_that_satisfy(label:Label, alphabet) -> set:
    bound_signals = set(filter(lambda sig: sig in label, alphabet))
    free_signals = set(alphabet).difference(bound_signals)

    if not free_signals:
        return [label]

    bound_signals_dict = dict((k, label[k]) for k in bound_signals)

    stimulus = set()
    for free_signals_value in product([True, False], repeat=len(free_signals)):
        stimuli = dict(bound_signals_dict)  # copy

        free_sig_val_pairs = zip(free_signals, free_signals_value)
        free_signals_dict = dict(free_sig_val_pairs)
        stimuli.update(free_signals_dict)

        stimulus.add(Label(stimuli))

    return stimulus


def get_next_states(n:Node, i_o:Label) -> set:
    dst_nodes = set()
    for lbl, dst_set_list in n.transitions.items():
        assert len(dst_set_list) == 1, str(dst_set_list)

        dst = map(lambda node_flag: node_flag[0], dst_set_list[0])

        if is_satisfied(lbl, i_o):
            dst_nodes.update(dst)

    return dst_nodes
