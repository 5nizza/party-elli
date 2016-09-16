import itertools
import logging

from helpers.logging_helper import log_entrance
from interfaces.automata import Node


def _get_blocks(toks):
    start = None
    blocks_indices = []
    for i, t in enumerate(toks):
        if t.count(':') == 1:
            start = i
        elif t.count(';') == 1 or 'skip' in t:
            end = i
            blocks_indices.append((start, end+1))
    cases = ['\n'.join(toks[x[0]:x[1]]) for x in blocks_indices]
    return cases


def parse_label_tok(label_tok, signal_by_name:dict):
    """ Return maps of labels [{var_name : True/False}, ..] """
    # (!a && !g && r) || (g)
    # (1)
    if label_tok == '(1)':
        return [{}]

    labels = []
    toks = [x.strip(' ()') for x in label_tok.split('||')]
    for t in toks:
        label = {}

        literals = [x.strip() for x in t.split('&&')]
        for l in literals:
            signal_name = l.strip('!')
            signal = signal_by_name[signal_name]
            label[signal] = bool('!' not in l)  # we don't use numbers as they used in the original spec

        labels.append(label)

    return labels


def _get_create(node_tok, name_to_node, initial_nodes, rejecting_nodes, states_prefix):
    node = name_to_node[node_tok] = name_to_node.get(node_tok, Node(states_prefix + node_tok))

    if 'init' in node_tok:
        initial_nodes.add(node)
    if 'accept' in node_tok:
        rejecting_nodes.add(node)

    return node


def _parse_trans_tok(trans:str,
                     src:Node,
                     name_to_node,
                     initial_nodes,
                     rejecting_nodes,
                     signal_by_name:dict,
                     states_prefix) -> (Node, list):

    if trans == 'false;':
        # falling out of the automaton?
        dst = src
        labels = [{}]  # empty label means 'true'
    else:
        label_tok, dst_tok = [x.strip() for x in trans.split('-> goto')]
        dst = _get_create(dst_tok, name_to_node, initial_nodes, rejecting_nodes, states_prefix)
        labels = parse_label_tok(label_tok, signal_by_name)

    return dst, labels


@log_entrance(log_level=logging.DEBUG)
def parse_ltl2ba_ba(text:str, signal_by_name:dict, states_prefix):
    """
    Parse ltl2ba output
    Return (initial_nodes, acc_nodes, nodes of Node class)

    """
    # TODO: account for the following special case (accept_init and s0_init)
    #       (GOAL returns this, that is alright):
    #    never {
    #    accept_init:
    #    s0_init:
    #        if
    #        :: !(g) -> goto s0_init
    #        fi;
    #    }

    toks = text.split('\n')
    toks = [x.strip() for x in toks][1:-1]
    assert len(toks) > 1

    blocks = _get_blocks(toks)

    # accept_init: /* .. */
    # if
    # :: (!a && !g && r) || (g) -> goto accept_init
    # :: (1) -> goto T0_S2
    # fi;

    #    accept_all :    /* 1 */
    #    skip

    variables = set()
    init_nodes = set()
    acc_nodes = set()
    name_to_node = {}

    for b in blocks:
        lines = b.strip().split('\n')

        src_tok = lines[0].split(':')[0].strip()
        src = _get_create(src_tok, name_to_node, init_nodes, acc_nodes, states_prefix)

        trans_block = lines[1:]
        # if
        # :: (!a && !g && r) || (g) -> goto accept_init
        # :: (1) -> goto T0_S2
        # fi;

        #    accept_all :    /* 1 */
        #    skip
        if len(trans_block) > 1:
            trans_toks = [x.strip(':').strip() for x in trans_block[1:-1]]
        else:
            trans_toks = [trans_block[0].strip()]

        if trans_toks == ['skip']:
            src.add_transition({}, {(src, src in acc_nodes)})
            continue

        for trans in trans_toks:
            dst, labels = _parse_trans_tok(trans,
                                           src,
                                           name_to_node,
                                           init_nodes, acc_nodes,
                                           signal_by_name,
                                           states_prefix)
            variables.update(itertools.chain(*[l.keys() for l in labels]))

            for l in labels:
                # that is not correct - there are no ORs in UCT
                # => this is corrected in _conform2acw
                src.add_transition(l, {(dst, dst in acc_nodes)})

    return init_nodes, acc_nodes, name_to_node.values()


#_tmp = """
#never { /* []((!(r) || g || a) -> <>(g || X(r) || X(a))) */
#accept_init:
#        if
#        :: (!a && !g && r) || (g) -> goto accept_init
#        :: (1) -> goto T0_S2
#        :: (1) -> goto accept_S3
#        :: (1) -> goto accept_S4
#        fi;
#T0_S2:
#        if
#        :: (1) -> goto T0_S2
#        :: (1) -> goto accept_S3
#        :: (g) -> goto accept_init
#        :: (1) -> goto accept_S4
#        fi;
#accept_S3:
#        if
#        :: (a) -> goto T0_S2
#        :: (a) -> goto accept_S3
#        :: (a && g) -> goto accept_init
#        :: (a) -> goto accept_S4
#        fi;
#accept_S4:
#        if
#        :: (!a && !g && r) || (g && r) -> goto accept_init
#        :: (r) -> goto T0_S2
#        :: (r) -> goto accept_S3
#        :: (r) -> goto accept_S4
#        fi;
#}"""
