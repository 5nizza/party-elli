from itertools import chain
from typing import Tuple

from automata.final_sccs_finder import build_state_to_final_scc
from helpers.python_ext import index_of
from interfaces.automaton import LABEL_TRUE, Automaton, Node


def is_final_sink(node:Node):
    flagged_nodes = node.transitions.get(LABEL_TRUE)
    if flagged_nodes is None:
        return False

    return index_of(lambda node_flag: node_flag[0] == node and node_flag[1], flagged_nodes)\
           is not None


def is_safety_automaton(automaton:Automaton):
    """
    Naive check:
    sound (return True => safety),
    but incomplete (safety !=> return True).
    More precisely:
    in safety automata,
    the only final edges leading to the same SCC
    allowed
    are the 'absorbing' ones.
    """

    #LTL_to_atm creates transitional rejecting nodes, so filter them
    node_to_final_scc = build_state_to_final_scc(automaton)

    for node in node_to_final_scc.keys():
        for dst, is_fin in chain(*node.transitions.values()):  # type: Tuple[Node, bool]
            if is_fin and\
                    dst in node_to_final_scc and\
                    node_to_final_scc[node] == node_to_final_scc[dst] and\
                    not is_final_sink(node):
                return False
    return True
