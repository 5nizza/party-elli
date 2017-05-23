from typing import Tuple, Set

from interfaces.automaton import Automaton, Node, Label


def dualize_nbw(nbw:Automaton, dual_atm_name:str, dual_node_name_pref:str) -> Automaton:
    """ It clones the automaton and renames newly created nodes. """
    dnode_by_node = dict(map(lambda n: (n, Node(dual_node_name_pref + n.name)),
                            nbw.nodes))
    for n in nbw.nodes:
        for lbl, node_flag_pairs in n.transitions.items():   # type: Tuple[Label, Set[Tuple[Node, bool]]]
            dnode_flag_pairs = set(map(lambda node_flag: (dnode_by_node[node_flag[0]], node_flag[1]),
                                       node_flag_pairs))
            dnode_by_node[n].add_transition(lbl, dnode_flag_pairs)

    return Automaton(map(dnode_by_node.get, nbw.init_nodes),
                     dnode_by_node.values(),
                     dual_atm_name)
