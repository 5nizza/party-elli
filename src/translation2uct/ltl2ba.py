from interfaces.automata import UCTNode


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
    """ returns labels [{var_name : True/False}, ..] """
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
    node = name_to_node[node_tok] = name_to_node.get(node_tok, UCTNode(node_tok))

    if 'init' in node_tok:
        initial_nodes.add(node)
    if 'accept' in node_tok:
        rejecting_nodes.add(node)

    return node


def parse_ltl2ba_output(text):
    """ Parse ltl2ba output, return (initial_nodes, rejecting nodes, nodes of UCTNode class) """

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

    initial_nodes = set()
    rejecting_nodes = set()
    name_to_node = {}

    for c in cases:
        lines = c.strip().split('\n')

        src_tok = lines[0].split(':')[0].strip()
        src = _get_create(src_tok, name_to_node, initial_nodes, rejecting_nodes)

        trans_toks = [x.strip(':').strip() for x in lines[1:] if 'if' not in x and 'fi' not in x]

        if trans_toks == ['skip']:
            src.add_edge(src, {})
            continue

        for trans in trans_toks:
            label_tok, dst_tok = [x.strip() for x in trans.split('-> goto')]

            labels = parse_label_tok(label_tok)

            for l in labels:
                dst = _get_create(dst_tok, name_to_node, initial_nodes, rejecting_nodes)
                src.add_edge(dst, l)

    return initial_nodes, rejecting_nodes, list(name_to_node.values())


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
