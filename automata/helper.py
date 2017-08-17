from typing import Tuple, List, Set

from interfaces.AHT_automaton import Node
from interfaces.automaton import Label, Automaton


def incoming_transitions(q:Node, atm:Automaton) -> List[Tuple[Node, Label, bool]]:
    result = list()
    for src in atm.nodes:
        for lbl, dst_isFin_pairs in src.transitions.items():  # type: Tuple[Label, Set[Tuple[Node, bool]]]
            for dst,isFin in dst_isFin_pairs:
                if dst == q:
                    result.append((src, lbl, isFin))
    return result
