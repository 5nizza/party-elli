from itertools import chain, product
from helpers.python_ext import index_of
from interfaces.automata import Label


def flatten_nodes_in_transition(node_transitions):
    states = set()
    for lbl, nodes_sets_list in node_transitions.items():
        for flagged_nodes_set in nodes_sets_list:
            for state, is_rejecting in flagged_nodes_set:
                states.add((state, is_rejecting))
    return states


def self_looped(node):
    next_nodes = map(lambda node_flag: node_flag[0], flatten_nodes_in_transition(node.transitions))
    return node in next_nodes


def is_absorbing(node):
    true_label = Label({})

    sets_of_flagged_nodes = node.transitions.get(true_label)
    if sets_of_flagged_nodes == None:
        return False

    all_next_flagged_nodes = chain(*sets_of_flagged_nodes)
    return index_of(lambda node_flag: node_flag[0] == node, all_next_flagged_nodes) != None


def is_safety_automaton(automaton):
    #TODO: better ways to identify safety props than checking corresponding UCW?
    from synthesis.rejecting_states_finder import build_state_to_rejecting_scc #TODO: bad circular dependence

    #ltl3ba creates transitional rejecting nodes, so filter them
    node_to_rej_scc = build_state_to_rejecting_scc(automaton)

    for node in automaton.rejecting_nodes: #TODO: does not work with rejecting edges automaton
        if node not in node_to_rej_scc: #shitty transitional rejecting node
            continue

        assert self_looped(node) or len(node_to_rej_scc[node]) > 1 #TODO: debug purposes

        if not is_absorbing(node):
            return False

    return True


def satisfied(label, signal_values):
    """ Do signal values satisfy the label? """

    for var, val in signal_values.items():
        if var not in label:
            continue
        if label[var] != val:
            return False
    return True


def to_dot(automaton):
    if automaton == None:
        return ''

    rej_header = []
    for rej in automaton.rejecting_nodes:
        rej_header.append('"{0}" [shape=doublecircle]'.format(rej.name))

    assert len(list(filter(lambda states: len(states) > 1, automaton.initial_sets_list))) == 0,\
    'no support of universal init states!'

    init_header = []
    init_nodes = chain(*automaton.initial_sets_list)
    for init in init_nodes:
        init_header.append('"{0}" [shape=box]'.format(init.name))

    trans_dot = []
    for n in automaton.nodes:
        colors = 'black purple green yellow blue orange red brown pink gray'.split()

        for label, list_of_sets in n.transitions.items():
            for flagged_states in list_of_sets:
                if len(colors):
                    color = colors.pop(0)
                else:
                    color = 'gray'

                edge_is_labelled = False

                for dst, is_rejecting in flagged_states:

                    edge_label_add = ''
                    if not edge_is_labelled:
                        edge_label_add = ', label="{0}"'.format(label_to_short_string(label))
                        edge_is_labelled = True

                    trans_dot.append('"{0}" -> "{1}" [color={2}{3}, arrowhead="{4}"];'.format(
                        n.name, dst.name, color, edge_label_add, ['normal', 'normalnormal'][is_rejecting]))

                trans_dot.append('\n')

    dot_lines = ['digraph "automaton" {'] + \
                init_header + ['\n'] + \
                rej_header + ['\n'] + \
                trans_dot + ['}']

    return '\n'.join(dot_lines)


def label_to_short_string(label):
    if len(label) == 0:
        return '1'

    short_string = ''
    for var, val in label.items():
        if val is False:
            short_string += '!'
        short_string += var

    return short_string


def get_next_states(state, signal_values):
    """ Return list of state sets """

    total_list_of_state_sets = []
    for label, list_of_state_sets in state.transitions.items():
        if satisfied(label, signal_values):
            for flagged_states_set in list_of_state_sets:
                states_set = set([n for (n, is_rejecting) in flagged_states_set])
                total_list_of_state_sets.append(states_set)

    return total_list_of_state_sets


def get_relevant_edges(var_values, spec_state):
    """ Return dst_sets_list """
    relevant_edges = []

    for label, dst_set_list in spec_state.transitions.items():
        if not satisfied(label, var_values):
            continue #consider only edges with labels that are satisfied by current signal values

        relevant_edges.extend(dst_set_list)

    return relevant_edges


def is_forbidden_label_values(var_values, labels):
    return sum(map(lambda l: satisfied(l, var_values), labels)) == 0


def enumerate_values(variables):
    """ Return list of maps: [ {var:val, var:val}, ..., {var:val, var:val} ]
        where vars are from variables
    """

    values_tuples = list(product([False, True], repeat=len(variables)))

    result = []
    for values_tuple in values_tuples:
        values = {}
        for i, (var, value) in enumerate(zip(variables, values_tuple)):
            values[var] = value
        result.append(values)
    return result

