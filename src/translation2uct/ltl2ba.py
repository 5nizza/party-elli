import itertools
import logging
from helpers.logging_helper import log_entrance
from helpers.python_ext import get_add
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
            label[signal] = bool('!' not in l) # we don't use numbers as they used in the original spec

        labels.append(label)

    return labels


def _get_create(node_tok, name_to_node, initial_nodes, rejecting_nodes):
    node = name_to_node[node_tok] = name_to_node.get(node_tok, Node(node_tok))

    if 'init' in node_tok:
        initial_nodes.add(node)
    if 'accept' in node_tok:
        rejecting_nodes.add(node)

    return node


def _unwind_label(pattern_lbl, vars):
    lbl_vars = pattern_lbl.keys()
    free_vars = vars.difference(lbl_vars)
    free_vars_values = list(itertools.product([True, False], repeat=len(free_vars)))

    if len(free_vars_values) is 0:
        return pattern_lbl

    concrete_labels = []
    for free_vars_value in free_vars_values:
        free_vars_lbl = {}
        for i, free_var in enumerate(free_vars):
            free_vars_lbl[free_var] = free_vars_value[i]

        concrete_lbl = dict(pattern_lbl)
        concrete_lbl.update(free_vars_lbl)
        concrete_labels.append(concrete_lbl)

    return concrete_labels


def _flatten(dst_set_list):
    return set(itertools.chain(*dst_set_list))


def _get_create_new_nodes(new_name_to_node, flagged_nodes_set):
    new_nodes = [(get_add(new_name_to_node, fn[0].name, Node(fn[0].name)), fn[1])
                 for fn in flagged_nodes_set]
    return new_nodes


def _conform2acw(initial_nodes, rejecting_nodes, nodes, vars):
    """ Modify 'incorrect' transitions:
        label->[set1,set2] modified to label->[set3], where set3=set1+set2
    """
    new_name_to_node = {}
    for n in nodes:
        new_node = get_add(new_name_to_node, n.name, Node(n.name))

        lbl_to_flagged_nodes = {}

        lbl_dst_set_pairs = [(lbl, _flatten(list_of_sets)) for lbl, list_of_sets in n.transitions.items()]
        for pattern_lbl, old_dst_nodes in lbl_dst_set_pairs:
            new_dst_nodes = _get_create_new_nodes(new_name_to_node, old_dst_nodes)

            lbl_nodes = get_add(lbl_to_flagged_nodes, pattern_lbl, set())
            lbl_nodes.update(new_dst_nodes)  # TODO: determenize, make labels do not intersect

        for lbl, flagged_dst_nodes in lbl_to_flagged_nodes.items():
            new_node.add_transition(lbl, flagged_dst_nodes)

    new_init_nodes = [new_name_to_node[n.name] for n in initial_nodes]
    new_rejecting_nodes = [new_name_to_node[n.name] for n in rejecting_nodes]

    return new_init_nodes, new_rejecting_nodes, list(new_name_to_node.values())


def _parse_trans_tok(trans:str,
                     src:Node,
                     name_to_node,
                     initial_nodes,
                     rejecting_nodes,
                     signal_by_name:dict) -> (Node, list):

    if trans == 'false;':
        #dead end -- rejecting state with self-loop
        dst = src
        labels = [{}]  # empty label means 'true'
        rejecting_nodes.add(src)
    else:
        label_tok, dst_tok = [x.strip() for x in trans.split('-> goto')]
        dst = _get_create(dst_tok, name_to_node, initial_nodes, rejecting_nodes)
        labels = parse_label_tok(label_tok, signal_by_name)

    return dst, labels


def _get_hacked_ucw(text:str, signal_by_name:dict): #TODO: bad smell - it is left for testing purposes only
    """
        Return: initial_nodes:set, rejecting_nodes:set, nodes:set, label variables:set
        It is hacked since it doesn't conform to description of Node transitions:
        label->[set1, set2] here means: with label go to _both set1 and set2

        @see _conform2acw which corrects this

    """

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

    vars = set()
    initial_nodes = set()
    rejecting_nodes = set()
    name_to_node = {}

    for b in blocks:
        lines = b.strip().split('\n')

        src_tok = lines[0].split(':')[0].strip()
        src = _get_create(src_tok, name_to_node, initial_nodes, rejecting_nodes)

        trans_toks = [x.strip(':').strip() for x in lines[1:] if x.strip() != 'if' and x.strip().strip(';') != 'fi']

        if trans_toks == ['skip']:
            src.add_transition({}, {(src, src in rejecting_nodes)})
            continue

        for trans in trans_toks:
            dst, labels = _parse_trans_tok(trans, src, name_to_node, initial_nodes, rejecting_nodes, signal_by_name)
            vars.update(itertools.chain(*[l.keys() for l in labels]))

            for l in labels:
                #that is not correct - there are no ORs in UCT => this is corrected in _conform2acw
                src.add_transition(l, {(dst, dst in rejecting_nodes)})

    return initial_nodes, rejecting_nodes, name_to_node.values(), vars


@log_entrance(logging.getLogger(), logging.DEBUG)
def parse_ltl2ba_ba(text:str, signal_by_name:dict):
    """
    Parse ltl2ba output
    Return (initial_nodes, rejecting nodes, nodes of Node class)
    """
    initial_nodes, rejecting_nodes, nodes, vars = _get_hacked_ucw(text, signal_by_name)

    ucw_init_nodes, ucw_rej_nodes, ucw_nodes = _conform2acw(initial_nodes, rejecting_nodes, nodes, vars)

    return [set(ucw_init_nodes)], ucw_rej_nodes, ucw_nodes


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
