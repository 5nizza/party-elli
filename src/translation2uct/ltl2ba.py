import itertools
from helpers.python_ext import get_add
from interfaces.automata import Node, Label

def _get_cases(toks):
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


def parse_label_tok(label_tok):
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
            label[l.strip('!')] = ('!' not in l)
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


def _get_create_new_nodes(new_name_to_node, old_dst_nodes):
    new_nodes = map(lambda n: get_add(new_name_to_node, n.name, Node(n.name)), old_dst_nodes)
    return new_nodes


def _conform2acw(initial_nodes, rejecting_nodes, nodes, vars):
    new_name_to_node = {}

    for n in nodes:
        new_node = get_add(new_name_to_node, n.name, Node(n.name))

        lbl_to_nodes = {}
        for pattern_lbl, old_dst_nodes in [(lbl, _flatten(d)) for lbl, d in n.transitions.items()]:
            new_dst_nodes = _get_create_new_nodes(new_name_to_node, old_dst_nodes)

            for lbl in _unwind_label(pattern_lbl, vars):
                lbl_nodes = get_add(lbl_to_nodes, Label(lbl), set())
                lbl_nodes.update(new_dst_nodes) #collect universal transitions

        for lbl, dst_nodes in lbl_to_nodes.items():
            new_node.add_transition(lbl, dst_nodes)

    new_initial_nodes = map(lambda n: new_name_to_node[n.name], initial_nodes)
    new_rejecting_nodes = map(lambda n: new_name_to_node[n.name], rejecting_nodes)

    return new_initial_nodes, new_rejecting_nodes, new_name_to_node.values()


def _get_hacked_ucw(text): #TODO: bad smell - it is left for testing purposes only
    """ It is hacked since it doesn't conform to description of Node transitions:
        in this version node's transitions contain: {label:[{}, {}, {}]} where labels can intersect
        For example: {1:[{0}, {1}], '!g':[{2}] which means that with '1' you go in _both_ directions,
        and with '!g' actually also in both directions since labels intersect (and no non-determinism!)
    """

    toks = text.split('\n')
    toks = [x.strip() for x in toks][1:-1]
    assert len(toks) > 1

    cases = _get_cases(toks)

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

    for c in cases:
        lines = c.strip().split('\n')

        src_tok = lines[0].split(':')[0].strip()
        src = _get_create(src_tok, name_to_node, initial_nodes, rejecting_nodes)

        trans_toks = [x.strip(':').strip() for x in lines[1:] if 'if' not in x and 'fi' not in x]

        if trans_toks == ['skip']:
            src.add_transition({}, {src})
            continue

        for trans in trans_toks:
            label_tok, dst_tok = [x.strip() for x in trans.split('-> goto')]

            labels = parse_label_tok(label_tok)
            vars.update(*[l.keys() for l in labels])

            for l in labels:
                dst = _get_create(dst_tok, name_to_node, initial_nodes, rejecting_nodes)
                src.add_transition(l, {dst}) #hack: that is not correct usage - there are no ORs in UCT => _conform2acw

    return initial_nodes, rejecting_nodes, name_to_node.values(), vars


def parse_ltl2ba_ba(text):
    """ Parse ltl2ba output, return (initial_nodes, rejecting nodes, nodes of Node class) """

    initial_nodes, rejecting_nodes, nodes, vars = _get_hacked_ucw(text)

    return _conform2acw(initial_nodes, rejecting_nodes, nodes, vars)


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
