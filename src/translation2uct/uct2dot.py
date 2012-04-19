def colorize_node_dot_str(node, color='green'):
    return '"{0}" [color="{1}"];'.format(node.name, color)


def node_to_dot_str(node):
    res = ''
    src = node
    for dst, label in node.transitions:
        res += ('"{0}" -> "{1}" [label="{2}"];\n').format(
            src.name,
            dst.name,
            ''.join((('' if l[1] else '!') + str(l[0])) for l in label.items()))
    return res


def uct2dot(uct):
    dot = """
digraph finite_state_machine {
  rankdir=LR;
  size="12"
  node [shape = circle];
"""

    for node in uct.initial_states:
        dot += "\n  " + colorize_node_dot_str(node) + '\n'

    for node in uct.states:
        dot += ''.join('\n  ' + x for x in node_to_dot_str(node).split('\n'))

    dot += '\n}'

    return dot
