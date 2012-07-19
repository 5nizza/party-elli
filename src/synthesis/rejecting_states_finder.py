from collections import defaultdict
from pygraph.algorithms.accessibility import mutual_accessibility
from pygraph.classes.digraph import digraph


def _flatten_states_in_transition(node_transitions):
    states = set()
    for lbl, nodes_sets_list in node_transitions.items():
        for flagged_nodes_set in nodes_sets_list:
            for state, is_rejecting in flagged_nodes_set:
                states.add((state, is_rejecting))
    return states


def _convert_to_digraph(nodes):
    g = digraph()
    g.add_nodes(nodes)
    for n in nodes:
        for next_node, is_rejecting in _flatten_states_in_transition(n.transitions):
            e = (n, next_node)
            g.add_edge(e)
            g.set_edge_properties(e, is_rejecting=is_rejecting)

    return g


def _build_edges_map(g):
    edges = defaultdict(set)
    for e in g.edges():
        edges[e[0]].add(e[1])

    return edges


def find_rejecting_sccs(automaton):
    """ Return set of SCC(set of nodes) containing a rejecting transition.
    """

    g = _convert_to_digraph(automaton.nodes)
    sccs = mutual_accessibility(g)
    rejecting_sccs = set()
    edges = _build_edges_map(g)

    for _, nodes in sccs.items():
        for n in nodes:
            edges_within_scc = set(edges[n]).intersection(set(nodes))

            is_rejecting = sum(map(lambda next: g.get_edge_properties((n, next))['is_rejecting'],
                edges_within_scc))
            if is_rejecting > 0:
                rejecting_sccs.add(frozenset(nodes))

    return rejecting_sccs

def build_state_to_rejecting_scc(automaton):
    """ Helper function: builds dict node->SCC """
    rejecting_sccs = find_rejecting_sccs(automaton)

    state_to_rejecting_scc = dict()
    for scc in rejecting_sccs:
        for n in scc:
            state_to_rejecting_scc[n] = scc

    return state_to_rejecting_scc
