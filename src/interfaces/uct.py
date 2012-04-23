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
