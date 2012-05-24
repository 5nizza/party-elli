from helpers.hashable import HashableDict


class Automaton:
    def __init__(self, init_sets_list, rejecting_nodes, nodes):
        self._init_sets_list = init_sets_list
        self._rejecting_nodes = rejecting_nodes
        self._nodes = nodes

    @property
    def nodes(self):
        return self._nodes

    @property
    def initial_sets_list(self):
        """ Return list of sets of initial nodes (non-deterministic) """
        return self._init_sets_list

    @property
    def rejecting_nodes(self):
        return self._rejecting_nodes


    def __str__(self):
        return "\n".join([str(x) for x in self._nodes]) +\
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
        self._transitions = {} # label->[nodes, nodes, nodes]
        self._name = name
        assert ',' not in name, name

    @property
    def name(self):
        return self._name

    @property
    def transitions(self):
        """ Return map { label->[nodes_set, .., nodes_set] ... label->[nodes_set, .., nodes_set] } """
        return self._transitions

    def add_transition(self, label, dst_set):
        """ Add transition:
            dst_set - set of destination nodes, singleton set if non-universal transition.
            Several calls with the same label are allowed - this means that transition is non-deterministic.
        """
        label = Label(label)
        label_transitions = self._transitions[label] = self._transitions.get(label, [])
        label_transitions.append(dst_set)


    def __str__(self):
        labels_strings = []
        for l, dst_list in self.transitions.items():
            dst_strings = []
            for dst_set in dst_list:
                dst_strings.append('({0})'.format(str(', '.join([d.name for d in dst_set]))))

            labels_strings.append('[{0}: {1}]'.format(str(l), ', '.join(dst_strings)))

        return "'{0}', transitions: {1}".format(self.name, ' '.join(labels_strings))


    def __repr__(self):
        return "'{0}'".format(self.name)
