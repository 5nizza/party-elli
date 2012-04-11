from interfaces.uct import UCTNode


def _get_cases(toks):
    start = None
    blocks_indices = []
    for i, t in enumerate(toks):
        if t.count(':') == 1:
            start = i
        elif t.count(';') == 1:
            end = i
            blocks_indices.append((start, end+1))
    cases = ['\n'.join(toks[x[0]:x[1]]) for x in blocks_indices]
    return cases


def _parse_label(label_tok):
    """ returns {var_name : True/False} """
    # (!a && !g && r) || (g)
    # (1)

    if label_tok == '(1)':
        return {}

    labels = {}
    toks = [x.strip(' ()') for x in label_tok.split('||')]
    for t in toks:
        literals = [x.strip() for x in t.split('&&')]
        for l in literals:
            labels[l.strip('!')] = ('!' not in l)

    assert len(labels) > 0

    return labels


def _get_create(node_tok, name_to_node, initial_nodes):
    node = name_to_node[node_tok] = name_to_node.get(node_tok, UCTNode(node_tok, 'accept' in node_tok))
    if 'init' in node_tok:
        initial_nodes.add(node)
    return node


def parse_ltl2ba_output(text):
    toks = text.split('\n')
    toks = [x.strip() for x in toks][1:-1]
    assert len(toks) > 1

    cases = _get_cases(toks)

    # accept_init: /* .. */
    # if
    # :: (!a && !g && r) || (g) -> goto accept_init
    # :: (1) -> goto T0_S2
    # :: (1) -> goto accept_S3
    # :: (1) -> goto accept_S4
    # fi;
    initial_nodes = set()
    name_to_node = {}
    for c in cases:
        lines = c.strip().split('\n')

        src_tok = lines[0].split(':')[0].strip()
        src = _get_create(src_tok, name_to_node, initial_nodes)

        trans_toks = [x.strip(':').strip() for x in lines[1:] if 'if' not in x and 'fi' not in x]

        for trans in trans_toks:
            label_tok, dst_tok = [x.strip() for x in trans.split('-> goto')]
            label = _parse_label(label_tok)
            dst = _get_create(dst_tok, name_to_node, initial_nodes)

            src.add_edge(dst, label)

    return initial_nodes, list(name_to_node.values())


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
