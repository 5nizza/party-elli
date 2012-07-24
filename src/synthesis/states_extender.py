import copy
from interfaces.automata import Automaton, Node


def _replace_link_in_transitions(transitions, old_dst, new_dst):
    new_transitions = {}

    for label, list_of_sets in transitions.items():
        new_list_of_sets = []

        for states in list_of_sets:
            states = set(states)

            if old_dst in states:
                states.remove(old_dst)
                if new_dst is not None:
                    states.add(new_dst)

            if len(states) > 0:
                new_list_of_sets.append(states)

        if len(new_list_of_sets) > 0:
            new_transitions[label] = new_list_of_sets

    return new_transitions


def _replace_link_inplace(node, old_dst, new_dst):
    new_transitions = _replace_link_in_transitions(node.transitions, old_dst, new_dst)
    node._transitions = new_transitions


def _copy_transitions(transitions):
    return _replace_link_in_transitions(transitions, None, None)


def _make_naive_copy(rej):
    new_node = Node(rej.name)
    new_node._transitions = _copy_transitions(rej.transitions)
    return new_node


def _extend_node_inplace(rej, extension_length):
    others = [_make_naive_copy(rej) for _ in range(1, extension_length + 1)]

    i = 1
    crt = rej
    for second in others:
        crt._name += '_' + str(i)
        crt._transitions = _replace_link_in_transitions(crt.transitions, rej, second)

        crt = second
        i += 1

    crt._name += '_' + str(i)
    crt._transitions = _replace_link_in_transitions(crt.transitions, rej, None)

    return others


def extend_self_looped_rejecting_states(automaton, extension_length):
    """ Extend all rejecting states with 'extension_length' number of states wo self-loops.
        The last state has the same transitions as original except self-loop.
        Works with self-looped automata only! """

    new_automaton = copy.deepcopy(automaton)

    new_nodes = set()
    for rej in new_automaton.rejecting_nodes:
        new_nodes.update(_extend_node_inplace(rej, extension_length))

    return Automaton(new_automaton.initial_sets_list, {}, set(new_automaton.nodes).union(new_nodes))