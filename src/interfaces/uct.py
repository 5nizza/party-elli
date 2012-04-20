class UCT:
    def __init__(self, initial_nodes, nodes):
        self._initial_states = initial_nodes
        self._states = nodes

    @property
    def states(self):
        return self._states

    @property
    def initial_states(self):
        return self._initial_states


    def __str__(self):
        return "\n".join([str(x) for x in self.states]) + \
               "\ninitial states:\n" + \
               "\n".join([str(x) for x in self.initial_states])


class UCTNode:
    def __init__(self, name, is_rejecting):
        self._is_rejecting = is_rejecting
        self._transitions = []
        self._name = name

    @property
    def name(self):
        return self._name

    @property
    def transitions(self):
        """ Return a list of pairs (destination:UCTNode, label:{letter:True/False}) """
        return self._transitions

    @property
    def is_rejecting(self): #TODO: move to UCT
        return self._is_rejecting


    def add_edge(self, dst, label):
        self._transitions.append((dst, label))


    def __str__(self):
        return "name: {0}, transitions: {1}".format(self.name, [str(x[1]) + ' ' + str(x[0].name) for x in self.transitions])
