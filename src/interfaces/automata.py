class UCT:
    def __init__(self, initial_nodes, rejecting_nodes, nodes):
        self._initial_nodes = initial_nodes
        self._rejecting_nodes = rejecting_nodes
        self._nodes = nodes

    @property
    def nodes(self):
        return self._nodes

    @property
    def initial_nodes(self):
        return self._initial_nodes

    @property
    def rejecting_nodes(self):
        return self._rejecting_nodes

    def __str__(self):
        return "\n".join([str(x) for x in self._nodes]) +\
               "\n initial nodes:\n" +\
               "\n".join([str(x) for x in self._initial_nodes]) +\
               "\n rejecting nodes:\n" + \
               "\n".join([str(x) for x in self._rejecting_nodes])


class UCTNode:
    def __init__(self, name):
        self._transitions = []
        self._name = name

    @property
    def name(self):
        return self._name

    @property
    def transitions(self):
        """ Return a list of pairs (destination:UCTNode, label:{letter:True/False}) """
        return self._transitions

    def add_edge(self, dst, label):
        self._transitions.append((dst, label))

    def __str__(self):
        return "name: {0}, transitions: {1}".format(self.name, [str(x[1]) + ' ' + str(x[0].name) for x in self.transitions])


class Label(dict):
    """
    variable_name:True/False
    """
    __slots__ = ('_hash',)
    def __hash__(self):
        rval = getattr(self, '_hash', None)
        if rval is None:
            rval = self._hash = hash(frozenset(self.iteritems()))
        return rval


class Node:
    def __init__(self, name):
        self._transitions = {} # label->[nodes, nodes, nodes]
        self._name = name

    @property
    def name(self):
        return self._name

    @property
    def transitions(self):
        """ Return map label->[nodes:set, nodes, ..] """
        return self._transitions

    def add_transition(self, label, dst_set):
        """ Add universal transition:
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

        return '{0}, transitions: {1}'.format(self.name, ' '.join(labels_strings))


    def __repr__(self):
        return self.name

