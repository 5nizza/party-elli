from typing import Set, Dict
from typing import Tuple as Pair

from automata.automata_classifier import is_final_sink
from helpers.logging_helper import log_entrance
from interfaces.automaton import Automaton, Node, Label, LABEL_TRUE


@log_entrance()
def k_reduce(atm:Automaton, k:int) -> Automaton:
    assert k >= 0, k
    dead_node = Node('dead')
    dead_node.add_transition(LABEL_TRUE, {(dead_node, True)})
    new_by_old_k = dict()       # type: Dict[Pair[Node, int], Node]

    def _get_add_node(old_n:Node, k:int) -> Node:
        if k < 0:
            return dead_node
        new_node = new_by_old_k[(old_n, k)] = new_by_old_k.get((old_n, k), Node(old_n.name + 'k' + str(k)))
        new_node.k = k
        return new_node

    old_by_new = dict()      # type: Dict[Node, Node]

    nodes_to_process = set() # type: Set[Node]
    for n in atm.init_nodes:
        new_n = _get_add_node(n, k)
        old_by_new[new_n] = n
        nodes_to_process.add(new_n)

    processed_nodes = set()  # type: Set[Node]
    processed_nodes.add(dead_node)
    while nodes_to_process:
        new_src = nodes_to_process.pop()
        processed_nodes.add(new_src)
        for lbl, node_flag_pairs in old_by_new[new_src].transitions.items():  # type: Pair[Label, Set[Pair[Node, bool]]]
            for old_dst, is_fin in node_flag_pairs:
                if is_final_sink(old_dst):
                    new_dst = dead_node
                else:
                    new_dst = _get_add_node(old_dst, new_src.k-is_fin)
                new_src.add_transition(lbl, {(new_dst, False)})
                old_by_new[new_dst] = old_dst
                if new_dst not in processed_nodes:
                    nodes_to_process.add(new_dst)

    return Automaton({_get_add_node(next(iter(atm.init_nodes)), k)},
                     processed_nodes)
