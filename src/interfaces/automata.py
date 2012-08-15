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
    def rejecting_nodes(self): #TODO: attention: will deprecated for rejecting edges automaton
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
        """ Return dict { label->[ Set_of_flagged_nodes, Set_of_flagged_nodes..] } """
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
















