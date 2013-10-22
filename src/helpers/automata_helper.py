from itertools import chain, product
import unittest

from third_party.boolean import *
from helpers.python_ext import index_of
from interfaces.automata import Label, LIVE_END, Node, DEAD_END


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
    if sets_of_flagged_nodes is None:
        return False

    all_next_flagged_nodes = chain(*sets_of_flagged_nodes)
    return index_of(lambda node_flag: node_flag[0] == node, all_next_flagged_nodes) is not None


def is_safety_automaton(ucw_automaton):
    #TODO: are there better ways to identify safety props than checking corresponding UCW?
    from synthesis.rejecting_states_finder import build_state_to_rejecting_scc #TODO: bad circular dependence

    #ltl3ba creates transitional rejecting nodes, so filter them
    node_to_rej_scc = build_state_to_rejecting_scc(ucw_automaton)

    for node in ucw_automaton.rejecting_nodes: #TODO: does not work with rejecting edges automaton
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


def to_dot(automaton) -> str:
    if automaton is None:
        return ''

    rej_header = []
    for rej in automaton.rejecting_nodes:
        rej_header.append('"{0}" [shape=doublecircle]'.format(rej.name))
    assert len(list(filter(lambda states: len(states) > 1, automaton.initial_sets_list))) == 0, \
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

    short_string = '.'.join(map(lambda var_val: ['!',''][var_val[1]] + str(var_val[0]), label.items()))
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

##############################################################################

def is_dead_end(state):
    if state is DEAD_END:
        return True

    if Label({}) in state.transitions:
        next_states_set_list = state.transitions[Label({})]
        assert len(next_states_set_list) == 1
        next_states_set = next_states_set_list[0]

        if index_of(lambda node_flag: node_flag[0] == state and node_flag[1], next_states_set) is not None:
            return True

    return False


class DeadEndTest(unittest.TestCase):
    def test_dead_end(self):
        node = Node('node')
        node.add_transition(Label({}), {(node, True)})

        assert is_dead_end(node)


##############################################################################
def convert_to_formula(label, symbol_from_var):
    formula = TRUE
    for v in label:
        s = symbol_from_var[v]
        if label[v]:
            formula = AND(formula, s)
        else:
            formula = AND(formula, NOT(s))

    return formula


def _label_from_clause(clause):
    """input is AND clause"""
    label_dict = dict()

    for l in clause.literals:
        assert len(l.symbols) == 1, str(l.symbols)
        symbol = next(iter(l.symbols))
        variable = symbol.obj
        label_dict[variable] = not isinstance(l, NOT)

    return Label(label_dict)


def convert_to_labels(formula):
    if formula == FALSE:
        return None

    if formula == TRUE:
        return {Label({})}

    labels = set()
    for c in normalize(OR, formula):
        labels.add(_label_from_clause(c))

    return labels


def get_intersection(label1, label2):
    for v in label1:
        if v in label2 and label1[v] != label2[v]:
            return None

    result = dict(label1)
    result.update(label2)
    return Label(result)

#overkill?
#    formula1 = convert_to_formula(label1)
#    formula2 = convert_to_formula(label2)
#
#    intersection = AND(formula1, formula2)
#    if intersection == FALSE:
#        return None
#
#    labels = convert_to_labels(intersection)
#
#    assert len(labels) == 1, str(labels)
#
#    return next(iter(labels))

def complement_node(node, variables):
    symbol_from_var = dict(zip(variables, symbols(*variables)))
    labels_as_formulas = [convert_to_formula(label, symbol_from_var) for label in node.transitions]

    if len(labels_as_formulas) == 0:
        not_any_of_labels = TRUE
    elif len(labels_as_formulas) == 1:
        not_any_of_labels = NOT(labels_as_formulas[0])
    else:
        not_any_of_labels = NOT(OR(*labels_as_formulas))

    complemented_labels = convert_to_labels(not_any_of_labels)
    if complemented_labels:
        for complemented_label in complemented_labels:
            node.add_transition(complemented_label, {(LIVE_END, False)})

#
def complement_with_live_ends(automaton, variables):
    """ Complement nodes with transitions to live_end_nodes """

    automaton.nodes.update({LIVE_END})

    for n in automaton.nodes:
        complement_node(n, variables)


class ComplementTests(unittest.TestCase):
    def test_complement_node_with_live_ends(self):
        node = Node('node')
        node.add_transition(Label({'a': True}), {(node, False)})

        complement_node(node, ['a'])

        assert node.transitions[Label({'a': True})] == [{(node, False)}]
        assert node.transitions[Label({'a': False})] == [{(LIVE_END, False)}]

    def test_complement_node_with_live_ends2(self):
        node = Node('node')
        complement_node(node, ['a'])

        assert node.transitions[Label({})] == [{(LIVE_END, False)}]

    def test_complement_node_with_live_ends3(self):
        node = Node('node')
        node.add_transition(Label({}), {(node, False)})
        complement_node(node, ['a'])

        assert node.transitions[Label({})] == [{(node, False)}]

    def test_complement_node_with_live_ends4(self):
        node = Node('node')
        node.add_transition(Label({'a': True, 'b': False}), {(node, False)})

        node.add_transition(Label({'a': False, 'b': True}), {(node, False)})

        complement_node(node, ['a', 'b'])

        assert node.transitions[Label({'a': False, 'b': False})] == [{(LIVE_END, False)}]
        assert node.transitions[Label({'a': True, 'b': True})] == [{(LIVE_END, False)}]
        assert node.transitions[Label({'a': True, 'b': False})] == [{(node, False)}]
        assert node.transitions[Label({'a': False, 'b': True})] == [{(node, False)}]


##############################################################################
#def get_partitioned_dst_nodes(node, label, variables):
#    varval_set = convert_to_varval_set(label, variables)
#
#    label_dst_set_pairs = set() #set of pairs (label, dst_set)
#    for l, dst_set_list in node.transitions.items():
#        assert len(dst_set_list) == 1
#        dst_set_flagged = frozenset(dst_set_list[0])
#
#        l_varval_set = convert_to_varval_set(l, variables)
#
#        common = l_varval_set.intersection(varval_set)
#        print('intersection of l and label is ', l, label, common)
#        print(l, ' ', common, ' ', str(dst_set_flagged))
#        if len(common):
#            label_dst_set_pairs.add((convert_to_label(common), dst_set_flagged))
#
#    return label_dst_set_pairs


class PartitioningTests(unittest.TestCase):
#    def test_partitioning(self):
#        node = Node('node')
#        node2 = Node('node2')
#
#        node.add_transition(Label({'a':True}), {(node, False)})
#        node.add_transition(Label({'a':False}), {(node2, False)})
#
#        label_dst_set_pairs = get_partitioned_dst_nodes(node, Label({}), ['a'])
#        assert label_dst_set_pairs == {(Label({'a':True}), frozenset({(node, False)})),
#                                       (Label({'a':False}), frozenset({(node2, False)}))}, str(label_dst_set_pairs)
#
#        assert get_partitioned_dst_nodes(node, Label({'a':True}), ['a']) == \
#               {(Label({'a':True}), frozenset({(node, False)}))}
#
##        print(str(get_partitioned_dst_nodes(node, Label({'a':True}), ['a', 'b'])))
##        print()
#        print()
#        print()
#
#        assert get_partitioned_dst_nodes(node, Label({'a':True}), ['a', 'b']) ==\
#               {(Label({'a':True}), frozenset({(node, False)}))}


    def test_convert_to_formula(self):
        boolean_symbols = dict(zip(['a', 'b'], symbols(*['a', 'b'])))
        assert convert_to_labels(convert_to_formula(Label({'a': True}), boolean_symbols)) == {Label({'a': True})}
        assert convert_to_labels(convert_to_formula(Label({'a': True, 'b': False}), boolean_symbols)) == {
            Label({'a': True, 'b': False})}

    def test_get_intersection(self):
        assert get_intersection(Label({}), Label({})) == Label({})
        assert get_intersection(Label({'a': True}), Label({})) == Label({'a': True})
        assert get_intersection(Label({'a': True}), Label({'b': False})) == Label({'a': True, 'b': False})
        assert get_intersection(Label({'a': True}), Label({'a': False})) is None
        assert get_intersection(Label({'a': False}), Label({'a': False, 'b': True})) == Label({'a': False, 'b': True})
