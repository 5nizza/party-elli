from interfaces.automaton import Automaton


def to_dot(automaton:Automaton) -> str:
    if automaton is None:
        return ''

    init_header = []
    for init in automaton.init_nodes:
        init_header.append('"{0}" [shape=box]'.format(init.name))

    trans_dot = []
    for n in automaton.nodes:
        colors = 'black purple green yellow blue orange red brown pink gray'.split()

        for label, node_flag_pairs in n.transitions.items():
            if len(colors):
                color = colors.pop(0)
            else:
                color = 'gray'

            edge_is_labelled = False
            for node, is_rej in node_flag_pairs:
                edge_label_add = ''
                if not edge_is_labelled:
                    edge_label_add = ', label="{0}"'.format(_label_to_short_string(label))
                    edge_is_labelled = True

                trans_dot.append('"{0}" -> "{1}" [color={2}{3}, arrowhead="{4}"];'.format(
                    n.name, node.name, color, edge_label_add, ['normal', 'normalnormal'][is_rej]))

    dot_lines = ['digraph "%s" {' % automaton.name] + \
                ['rankdir=LR;'] + \
                init_header + ['\n'] + \
                trans_dot + ['}']

    return '\n'.join(dot_lines)


def _label_to_short_string(label):
    if len(label) == 0:
        return '1'

    short_string = '.'.join(map(lambda var_val: ['!',''][var_val[1]] + str(var_val[0]), label.items()))
    return short_string
