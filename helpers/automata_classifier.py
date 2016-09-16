from helpers.python_ext import index_of
from helpers.rejecting_states_finder import build_state_to_rejecting_scc  # TODO: bad smell: inter-dependence?
from interfaces.automata import LABEL_TRUE


def _flatten_flagged_nodes_in_transitions(node_transitions):
    states = set()
    for lbl, flagged_nodes in node_transitions.items():
        for state, is_acc in flagged_nodes:
            states.add((state, is_acc))
    return states


def _is_self_looped(node):
    next_nodes = map(lambda node_flag: node_flag[0], _flatten_flagged_nodes_in_transitions(node.transitions))
    return node in next_nodes


def is_absorbing(node):
    flagged_nodes = node.transitions.get(LABEL_TRUE)
    if flagged_nodes is None:
        return False

    return index_of(lambda node_flag: node_flag[0] == node, flagged_nodes) is not None


def is_safety_automaton(automaton):
    """
    This function is sound (yes answer is correct),
    but incomplete (may so while the automaton is safety).
    In safety automata, the only accepting nodes allowed are absorbing nodes (dead ends).
    """
    #TODO: are there better ways to identify automata than checking automata?

    #ltl3ba creates transitional rejecting nodes, so filter them
    node_to_rej_scc = build_state_to_rejecting_scc(automaton)

    for node in automaton.acc_nodes:  # TODO: does not work with rejecting edges automaton
        if node not in node_to_rej_scc:
            continue

        assert _is_self_looped(node) or len(node_to_rej_scc[node]) > 1  # TODO: debug purposes

        if not is_absorbing(node):
            return False

    return True
