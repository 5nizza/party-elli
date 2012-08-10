from helpers.python_ext import SmarterList
from synthesis.smt_helper import get_output_name


def to_dot(lts):
    dot_lines = SmarterList()
    dot_lines += 'digraph module {'

    for state in lts.states:
        name_value_pairs = sorted(lts.outputs(state).items())
        values_str = ' '.join(map(lambda name_value: '{0}{1}'.format(['-', ''][name_value[1]=='true'],
                                                                     name_value[0].replace(get_output_name(''), '')),
                              name_value_pairs))
        dot_lines += '"{state}" [label="{values}"{color}]'.format_map({'state':state, 'values':values_str,
                                                                       'color':['', ', color="green"'][state=='0']})

    for state in lts.states:
        for input, new_state in lts.next_states(state).items():
            dot_lines += '"{state}" -> "{new_state}" [label="{label}"]'.format_map({'state': state,
                                                                                    'new_state': new_state,
                                                                                    'label':' '.join(input)})

    dot_lines += '}'

    return '\n'.join(dot_lines)
