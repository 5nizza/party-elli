def to_dot(smt_module):
    dot_lines = ["digraph module { "]

    state_trans, output_transition = smt_module.get_model()

    output = {}
    for state, out_var, out_val in zip(output_transition.state, output_transition.type, output_transition.result):
        output[state] = output.get(state, {})
        output[state][out_var] = out_val

    for state, values_dict in output.items():
        var_value_pairs = sorted(map(lambda it: (it[0], it[1]), values_dict.items()))
        values = ' '.join(map(lambda var_val: ['-', ''][var_val[1]=='true'] + var_val[0].replace('fo_', ''),
                              var_value_pairs))
        dot_lines.append('"{0}" [label="{1}"{2}]'.format(state, values, ['', ', color="green"'][state=='0']))

    for i in range(len(state_trans.state)):
        dot_lines.append('"{0}" -> "{1}" [label="{2}"]'.format(state_trans.state[i],
            state_trans.new_state[i],
            state_trans.input[i].replace('i_', '').replace('not_', '-').replace('.', ' ')))

    dot_lines.append('}')

    return '\n'.join(dot_lines)