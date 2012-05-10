from interfaces.automata import Node
from ltl2ba import parse_label_tok
import itertools


def _extract_aa_desc(text):
    splitted = text.split('\n')
    for i, l in enumerate(splitted):
        if 'Alternating automaton after simplification' in l:
            start = i+1
        if 'Generalized' in l:
            return '\n'.join(splitted[start:i])


def _get_blocks(aa_text):
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

def _extract_state_names_set(curly_token_set):
    return curly_token_set.strip().split('}')[0].strip('{').split(',')


def _create_rejecting_initial_nodes(states_block, name_to_node):
    sets_list = []
    for l in _stripped(states_block.split('\n'))[1:]:
        states_set = set()
        names = _extract_state_names_set(l)
        for name in names:
            node = _get_create(name, name_to_node)
            states_set.add(node)

        sets_list.append(states_set)

    return sets_list


def _create_initial_nodes(init_states_block, name_to_node):
    """ Return list of sets of initial nodes """

    return _create_rejecting_initial_nodes(init_states_block, name_to_node)


def _create_rejecting_nodes(rejecting_states_block, name_to_node):
    assert 'rejecting' in rejecting_states_block, rejecting_states_block

    rejecting_sets_list = _create_rejecting_initial_nodes(rejecting_states_block, name_to_node)
    return set(itertools.chain(*rejecting_sets_list))


def _get_src_name(state_lines):
    name_tok = state_lines[0].split(':')[0].strip()
    name = name_tok.replace('state', '').strip()
    return name


def _stripped(toks):
    return [_.strip() for _ in toks if _.strip() != '']


def _split_trans(trans):
    label_tok, dst_tok = _stripped(trans.split('->')) #(1) -> {4,7}            {}

    dst_names = _extract_state_names_set(dst_tok)
    dst_names = _stripped(dst_names)
    for n in dst_names:
        assert '{' not in n, n
        assert '}' not in n, n
    labels = parse_label_tok(label_tok)

    return labels, dst_names


def parse_ltl3ba_aa(text): #TODO: what is an empty {}?!
    """ Parse ltl3ba output, return (init_sets_list, set of rejecting nodes, set of all nodes) """

    aa_desc = _extract_aa_desc(text)

    blocks = _get_blocks(aa_desc)
    init_states_block = blocks[0]
    rejecting_states_block = blocks[1]
    state_blocks = blocks[2:]

    name_to_node = {}
    init_sets_list = _create_initial_nodes(init_states_block, name_to_node)
    rejecting_nodes = _create_rejecting_nodes(rejecting_states_block, name_to_node)

    for b in state_blocks:
        block_lines = b.split('\n')

        src_name = _get_src_name(block_lines)
        src = _get_create(src_name, name_to_node)

        for trans in _stripped(block_lines[1:]):
            labels, dst_names = _split_trans(trans)

            dst_set = {_get_create(n, name_to_node) for n in dst_names}
            for l in labels:
                src.add_transition(l, dst_set)

    return init_sets_list, rejecting_nodes, name_to_node.values()

# Alternating automaton after simplification
# init :
# {7}
# state 7 : (false V (! ((r)) || (true U (g))))
# (!r) || (r && g) -> {7}         {}
# (1) -> {4,7}            {}
# * state 4 : (true U (g))
# (g) -> {}               {}
# (1) -> {4}              {4}
