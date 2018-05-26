from typing import Set, Dict, List

import spot
import buddy

from interfaces.automaton import Automaton, Node, Label
from interfaces.expr import Signal


def _collect_all_signals(k_automaton:Automaton) -> Set[Signal]:
    all_signals = set()
    for n in k_automaton.nodes:
        for label in n.transitions:
            for sig in label:
                all_signals.add(sig)
    return all_signals


def _convert_label_to_spot(label:Label, spot_p_by_sig:Dict[Signal,buddy.bdd]) -> buddy.bdd:
    result = buddy.bddtrue
    for sig in label:
        if label[sig]:
            result &= spot_p_by_sig[sig]
        else:
            result &= -spot_p_by_sig[sig]
    return result


def convert_to_spot_automaton(automaton:Automaton) -> spot.twa:
    bdict = spot.make_bdd_dict()
    aut = spot.make_twa_graph(bdict)  # type: spot.twa
    aut.prop_terminal()

    signals = _collect_all_signals(automaton)
    spot_p_by_sig = dict()  # type: Dict[Signal, buddy.bdd]
    for s in signals:
        spot_p_by_sig[s] = buddy.bdd_ithvar(aut.register_ap(s.name))

    aut.set_generalized_buchi(1)

    spot_state_by_node = dict()  # type: Dict[Node, int]
    state_names = []
    for i,n in enumerate(automaton.nodes):
        spot_state_by_node[n] = i
        state_names.append(n.name)

    aut.new_states(len(automaton.nodes))
    aut.set_init_state(spot_state_by_node[list(automaton.init_nodes)[0]])  # may be non-zero!
    # noinspection PyTypeChecker
    aut.set_state_names(state_names)

    for n in automaton.nodes:
        for l,t in n.transitions.items():  # type: Label, Set[(Node, bool)]
            spot_label = _convert_label_to_spot(l, spot_p_by_sig)
            for dst, is_acc in t:
                if is_acc:
                    aut.new_edge(spot_state_by_node[n], spot_state_by_node[dst], spot_label, [0])
                else:
                    aut.new_edge(spot_state_by_node[n], spot_state_by_node[dst], spot_label)

    return aut
