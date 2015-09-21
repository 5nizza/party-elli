from itertools import chain
from helpers.python_ext import index_of
from interfaces.automata import Label
from synthesis.rejecting_states_finder import build_state_to_rejecting_scc  # TODO: bad smell: inter-dependence?


def _flatten_nodes_in_transition(node_transitions):
    states = set()
    for lbl, nodes_sets_list in node_transitions.items():
        for flagged_nodes_set in nodes_sets_list:
            for state, is_rejecting in flagged_nodes_set:
                states.add((state, is_rejecting))
    return states


def _is_self_looped(node):
    next_nodes = map(lambda node_flag: node_flag[0], _flatten_nodes_in_transition(node.transitions))
    return node in next_nodes


def is_absorbing(node):
    true_label = Label({})

    sets_of_flagged_nodes = node.transitions.get(true_label)
    if sets_of_flagged_nodes is None:
        return False

    all_next_flagged_nodes = chain(*sets_of_flagged_nodes)
    return index_of(lambda node_flag: node_flag[0] == node, all_next_flagged_nodes) is not None


def is_safety_automaton(automaton):
    """ In safety automata, the only accepting nodes allowed are absorbing nodes (dead ends). """
    #TODO: are there better ways to identify safety props than checking corresponding UCW?

    #ltl3ba creates transitional rejecting nodes, so filter them
    node_to_rej_scc = build_state_to_rejecting_scc(automaton)

    for node in automaton.rejecting_nodes:  # TODO: does not work with rejecting edges automaton
        if node not in node_to_rej_scc:
            continue

        assert _is_self_looped(node) or len(node_to_rej_scc[node]) > 1  # TODO: debug purposes

        if not is_absorbing(node):
            return False

    return True
