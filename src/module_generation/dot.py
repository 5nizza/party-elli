from helpers.python_ext import StrAwareList
from interfaces.automata import Label
from interfaces.lts import LTS


def _colorize_nodes(lts):
    dot_lines = StrAwareList()

    for state in lts.states:
        dot_lines += '"{state}" [{color}]'.format_map({'state':state,
                                                       'color':['', 'color="green"'][state in lts.init_states]})

    return dot_lines


def _convert_to_dot(vals_dict):
    return ''.join(map(lambda arg: '{0}{1}'.format(['-', ''][arg[1]], arg[0]), vals_dict.items()))


def _get_inputvals(inputargs):
    inputvals = dict(inputargs)
    del inputvals['state'] #TODO: hack
    return inputvals


def mealy_to_dot(mealy:LTS):
    dot_lines = StrAwareList()
    dot_lines += 'digraph module {\n'

    dot_lines += _colorize_nodes(mealy) + '\n'

    for label, next_state in mealy.tau_model.items():
        outvals = mealy.get_outputs(label)
        outvals_str = _convert_to_dot(outvals)

        inputvals = _get_inputvals(label)
        inputvals_str = _convert_to_dot(inputvals)

        dot_lines += '"{state}" -> "{x_state}" [label="{in}/{out}"]'.format_map({'state': label['state'], #TODO: hack
                                                                                'x_state': next_state,
                                                                                'in':inputvals_str,
                                                                                'out':outvals_str})

    dot_lines += '}'

    return '\n'.join(dot_lines)


def moore_to_dot(moore:LTS):
    dot_lines = StrAwareList()
    dot_lines += 'digraph module {\n'

    dot_lines += _colorize_nodes(moore) + ''

    for state in moore.states:
        outvals = moore.get_outputs(Label({'state':state})) #TODO: hack
        outvals_str = _convert_to_dot(outvals)
        dot_lines += '"{state}"[label="{out}"]'.format(state=state, out = outvals_str)

    dot_lines += ''

    for args, x_state in moore.tau_model.items():
        inputvals = _get_inputvals(args)
        inputvals_str = _convert_to_dot(inputvals)

        dot_lines += '"{state}" -> "{x_state}" [label="{in}"]'.format_map({'state': args['state'],
                                                                           'x_state': x_state,
                                                                           'in':inputvals_str})
    dot_lines += '}'

    return '\n'.join(dot_lines)
