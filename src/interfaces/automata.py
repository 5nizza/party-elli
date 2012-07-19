from itertools import chain
import itertools
from helpers.hashable import HashableDict


class Automaton:
    def __init__(self, init_sets_list, rejecting_nodes, nodes):
        self._init_sets_list = list(init_sets_list)
        self._rejecting_nodes = set(rejecting_nodes)
        self._nodes = set(nodes)

    @property
    def nodes(self):
        return self._nodes

    @property
    def initial_sets_list(self):
        """ Return list of sets of initial nodes (non-deterministic) """
        return self._init_sets_list

    @property
    def rejecting_nodes(self): #seems to become deprecated
        return self._rejecting_nodes


    def __str__(self):
        return "nodes:\n" + \
               "\n".join([str(x) for x in self._nodes]) +\
               "\n initial nodes:\n" +\
               "\n".join([str(x) for x in self._init_sets_list]) +\
               "\n rejecting nodes:\n" + \
               "\n".join([str(x) for x in self._rejecting_nodes])


class Label(HashableDict):
    """
    hashable dict: variable_name -> True/False
    """
    pass


class Node:
    def __init__(self, name):
        self._transitions = {} # label->[(set, is_rejecting), (set, is_rejecting), ..]
        self._name = name
        assert name != "0"

    @property
    def name(self):
        return self._name

    @property
    def transitions(self):
        """ Return map { label->[flagged_nodes_set, ..] ... label->[flagged_nodes_set, ..] } """
        return self._transitions

    def add_transition(self, label, flagged_nodes):
        """ Add transition:
            flagged_nodes - set of destination nodes, singleton set if non-universal transition.
            Several calls with the same label are allowed - this means that transition is non-deterministic.
        """
        label = Label(label)
        label_transitions = self._transitions[label] = self._transitions.get(label, [])

        flagged_nodes_set = set(flagged_nodes)
        assert flagged_nodes_set not in label_transitions

        label_transitions.append(flagged_nodes_set)


    def __str__(self):
        labels_strings = []
        for l, dst_list in self.transitions.items():
            dst_strings = []
            for flagged_dst_set in dst_list:
                dst_strings.append('({0})'.format(str(', '.join(['{0}{1}'.format(n.name, ['',':rej'][is_rejecting])
                                                                 for n, is_rejecting in flagged_dst_set]))))

            labels_strings.append('[{0}: {1}]'.format(str(l), ', '.join(dst_strings)))

        return "'{0}', transitions: {1}".format(self.name, ' '.join(labels_strings))


    def __lt__(self, other):
        return id(self) < id(other)


    def __repr__(self):
        return "'{0}'".format(self.name)


#------------------------------CONSTANTS---------------------------------
DEAD_END = Node('dead')
LIVE_END = Node('live')

#------------------------------helper functions--------------------------
#TODO: extract to a different file
def satisfied(label, signal_values):
    """ Do signal values satisfy the label? """

    for var, val in signal_values.items():
        if var not in label:
            continue
        if label[var] != val:
            return False
    return True


def enumerate_values(variables):
    """ Return list of maps: [ {var:val, var:val}, ..., {var:val, var:val} ]
        where vars are from variables
    """

    values_tuples = list(itertools.product([False, True], repeat=len(variables)))

    result = []
    for values_tuple in values_tuples:
        values = {}
        for i, (var, value) in enumerate(zip(variables, values_tuple)):
            values[var] = value
        result.append(values)
    return result


def is_forbidden_label_values(var_values, labels):
    return sum(map(lambda l: satisfied(l, var_values), labels)) == 0

def get_relevant_edges(var_values, spec_state):
    """ Return dst_sets_list """
    relevant_edges = []

    for label, dst_set_list in spec_state.transitions.items():
        if not satisfied(label, var_values):
            continue #consider only edges with labels that are satisfied by current signal values

        relevant_edges.extend(dst_set_list)

    return relevant_edges

def get_next_states(state, signal_values):
    """ Return list of state sets """

    total_list_of_state_sets = []
    for label, list_of_state_sets in state.transitions.items():
        if satisfied(label, signal_values):
            for flagged_states_set in list_of_state_sets:
                states_set = set([n for (n, is_rejecting) in flagged_states_set])
                total_list_of_state_sets.append(states_set)

    return total_list_of_state_sets


def label_to_short_string(label):
    if len(label) == 0:
        return '1'

    short_string = ''
    for var, val in label.items():
        if val is False:
            short_string += '!'
        short_string += var

    return short_string


def to_dot(automaton):
    rej_header = []
    for rej in automaton.rejecting_nodes:
        rej_header.append('"{0}" [shape=doublecircle]'.format(rej.name))

    assert len(list(filter(lambda states: len(states) > 1, automaton.initial_sets_list))) == 0,\
    'no support of universal init states!'

    init_header = []
    init_nodes = chain(*automaton.initial_sets_list)
    for init in init_nodes:
        init_header.append('"{0}" [shape=box]'.format(init.name))

    trans_dot = []
    for n in automaton.nodes:
        colors = 'black purple green yellow blue orange red brown pink gray'.split()

        for label, list_of_sets in n.transitions.items():
            for flagged_states in list_of_sets:
                if len(colors):
                    color = colors.pop(0)
                else:
                    color = 'gray'

                edge_is_labelled = False

                for dst, is_rejecting in flagged_states:

                    edge_label_add = ''
                    if not edge_is_labelled:
                        edge_label_add = ', label="{0}"'.format(label_to_short_string(label))
                        edge_is_labelled = True

                    trans_dot.append('"{0}" -> "{1}" [color={2}{3}, arrowhead="{4}"];'.format(
                        n.name, dst.name, color, edge_label_add, ['normal', 'normalnormal'][is_rejecting]))

                trans_dot.append('\n')

    dot_lines = ['digraph "automaton" {'] + \
                init_header + ['\n'] + \
                rej_header + ['\n'] + \
                trans_dot + ['}']

    return '\n'.join(dot_lines)


