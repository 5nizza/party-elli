from interfaces.automata import Node
from ltl2ba import parse_label_tok

import re


def _extract_aa_desc(text):
    return re.search('Alternating automaton after simplification(?:\n|\r\n?)(.+)(?:\n|\r\n?){2}',
        text,
        re.DOTALL).group(1)


def _get_blocks(aa_text): #TODO: learn regular expressions: http://stackoverflow.com/questions/587345/python-regular-expression-matching-a-multiline-block-of-text
    crt = ''
    states_desc = []
    for l in aa_text.split('\n'):
        if ':' in l:
            states_desc.append(crt)
            crt = ''
        crt += l + '\n'

    states_desc.append(crt)

    return filter(lambda s: s != '' and s is not None, states_desc)


def _get_create(name, name_to_node):
    node = name_to_node[name] = name_to_node.get(name, Node(name))
    return node

#init :
#    {1}
#    {2}
def _create_initial_nodes(init_states_block, name_to_node):
    assert 'init' in init_states_block

    initial_nodes = set()
    for l in _stripped(init_states_block.split('\n'))[1:]:

        name = l.strip('{}').strip()
        node = _get_create(name, name_to_node)
        initial_nodes.add(node)

    return initial_nodes


def _get_src_name(state_lines):
    name_tok = state_lines[0].split(':')[0].strip()
    name = name_tok.strip('*').strip().strip('state').strip()
    return name, '*' in name_tok


def _stripped(toks):
    return [_.strip() for _ in toks if _.strip() != '']


def _split_trans(trans):
    label_tok, dst_tok = _stripped(trans.split('->')) #(1) -> {4,7}            {}

    dst_names = dst_tok.strip().split('}')[0].strip('{').split(',')
    dst_names = _stripped(dst_names)
    for n in dst_names:
        assert '{' not in n, n
        assert '}' not in n, n
    labels = parse_label_tok(label_tok)

    return labels, dst_names


def parse_ltl3ba_aa(text):
    """ Parse ltl3ba output, return sets (initial_nodes, rejecting nodes, nodes) """

    aa_desc = _extract_aa_desc(text)

    blocks = _get_blocks(aa_desc)
    init_states_block = blocks[0]
    state_blocks = blocks[1:]

    name_to_node = {}
    rejecting_nodes = set()
    initial_nodes = _create_initial_nodes(init_states_block, name_to_node)

    for b in state_blocks:
        block_lines = b.split('\n')

        src_name, is_rejecting = _get_src_name(block_lines)
        src = _get_create(src_name, name_to_node)
        if is_rejecting:
            rejecting_nodes.add(src)

        for trans in _stripped(block_lines[1:]):
            labels, dst_names = _split_trans(trans)
            dst_set = {_get_create(n, name_to_node) for n in dst_names}
            for l in labels:
                src.add_transition(l, dst_set)

    return initial_nodes, rejecting_nodes, list(name_to_node.values())

# Alternating automaton after simplification
# init :
# {7}
# state 7 : (false V (! ((r)) || (true U (g))))
# (!r) || (r && g) -> {7}         {}
# (1) -> {4,7}            {}
# * state 4 : (true U (g))
# (g) -> {}               {}
# (1) -> {4}              {4}
