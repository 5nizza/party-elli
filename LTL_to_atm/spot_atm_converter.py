from typing import Dict, Set, Union

import spot

from interfaces.automaton import Automaton, Node
from interfaces.expr import Signal
from LTL_to_atm.parse_buddy import parse_bdd


def spotAtm_to_automaton(atm:Union[spot.twa, spot.twa_graph],
                         states_prefix:str,
                         signal_by_name:Dict[str, Signal],
                         atm_name:str) -> Automaton:
    def node_name(s):
        return states_prefix + str(s)

    myState_by_spotState = dict()  # type: Dict[int, Node]

    queue = {atm.get_init_state_number()}  # type: Set[int]
    processed = set()                      # type: Set[int]
    while len(queue):
        state_num = queue.pop()
        processed.add(state_num)

        src = myState_by_spotState.setdefault(state_num, Node(node_name(state_num)))
        for e in atm.out(state_num):  # type: spot.twa_graph_edge_storage
            if e.dst not in processed:
                queue.add(e.dst)
            dst_node = myState_by_spotState.setdefault(e.dst, Node(node_name(e.dst)))
            labels = parse_bdd(e.cond, atm.get_dict(), signal_by_name)
            for l in labels:
                src.add_transition(l, [(dst_node,e.acc.count() != 0)])

    return Automaton({myState_by_spotState[atm.get_init_state_number()]},
                     myState_by_spotState.values(),
                     atm_name)
