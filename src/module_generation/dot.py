def to_dot(smt_module):
    dot_lines = ["digraph module { "]

    state_trans = smt_module.get_model()[0]
    for i in range(len(state_trans.state)):
        dot_lines.append('"{0}" -> "{1}" [label="{2}"]'.format(state_trans.state[i],
            state_trans.new_state[i],
            state_trans.input[i].replace('i_', '').replace('not_', '-').replace('.', ' ')))

    dot_lines.append('}')

    return '\n'.join(dot_lines)