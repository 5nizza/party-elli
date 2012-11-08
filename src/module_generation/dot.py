from helpers.python_ext import StrAwareList
from synthesis.smt_helper import get_output_name


def to_dot(lts):
    dot_lines = StrAwareList([])
    dot_lines += 'digraph module {'

    for state in lts.states:
        name_value_pairs = sorted(lts.outputs(state).items())
        values_str = ' '.join(map(lambda name_value: '{0}{1}'.format(['-', ''][name_value[1]=='true'],
                                                                     name_value[0].replace(get_output_name(''), '')),
                              name_value_pairs))
        dot_lines += '"{state}" [label="{values}"{color}]'.format_map({'state':state, 'values':values_str,
                                                                       'color':['', ', color="green"'][state == lts.init_state]})

    for state in lts.states:
        for input_args, new_state in lts.next_states(state).items():
            print(new_state)
            print(input_args)
            inputs = map(lambda arg: '{0}{1}'.format(['-', ''][arg[1]], arg[0]), input_args.items())
            dot_lines += '"{state}" -> "{new_state}" [label="{label}"]'.format_map({'state': state,
                                                                                    'new_state': new_state,
                                                                                    'label':' '.join(inputs)})

    dot_lines += '}'

    return '\n'.join(dot_lines)
