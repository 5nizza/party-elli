from helpers.python_ext import StrAwareList
from interfaces.automata import Label
from interfaces.lts import LTS
from interfaces.parser_expr import QuantifiedSignal


def _colorize_nodes(lts):
    dot_lines = StrAwareList()

    for state in lts.states:
        dot_lines += '"{state}" [{color}]'.format_map({'state':state,
                                                       'color':['', 'color="green"'][state in lts.init_states]})

    return dot_lines


def _convert_to_dot(value_by_signal:dict) -> str:
    #TODO: create FuncDescription with name as QuantifiedSignal_i in Impl?

    values_str = ''.join(['{value}{var}'.format(
                            value=['-', ''][value],
                            var=signal.name if isinstance(signal, QuantifiedSignal) else signal)
                          for (signal,value) in value_by_signal.items()])
    return values_str


def _get_inputvals(label:dict) -> dict:
    inputvals = dict(label)
    del inputvals['state'] #TODO: hack -- hardcoded 'state'
    return inputvals


def _label_states_with_outvalues(lts:LTS, filter='all'):
    dot_lines = StrAwareList()

    for state in lts.states:
        signal_vals_pairs = [(var, vals) for (var,vals) in lts.model_by_name.items()
                             if var in filter or filter == 'all']
        outvals = dict([(var, vals[Label({'state':state})])
                        for (var, vals) in signal_vals_pairs]) #TODO: hack

        outvals_str = _convert_to_dot(outvals)
        if outvals_str != '':
            dot_lines += '"{state}"[label="{out}"]'.format(state=state, out = outvals_str)

    return dot_lines


def to_dot(lts:LTS, outvars_treated_as_moore=()):
    dot_lines = StrAwareList()
    dot_lines += 'digraph module {\n'

    dot_lines += _colorize_nodes(lts) + '\n'

    dot_lines += _label_states_with_outvalues(lts, outvars_treated_as_moore)

    for label, next_state in lts.tau_model.items():
        outvar_vals = [(var, vals) for (var, vals) in lts.model_by_name.items()
                       if var not in outvars_treated_as_moore]

        outvals = dict([(var, values[label]) for (var, values) in outvar_vals])
        outvals_str = _convert_to_dot(outvals)
        outvals_str = '/' + outvals_str if outvals_str != '' else ''

        inputvals = _get_inputvals(label)
        inputvals_str = _convert_to_dot(inputvals)

        dot_lines += '"{state}" -> "{x_state}" [label="{in}{mark_out}"]'.format_map({'state': label['state'], #TODO: hack
                                                                                'x_state': next_state,
                                                                                'in':inputvals_str,
                                                                                'mark_out':outvals_str})

    dot_lines += '}'

    return '\n'.join(dot_lines)


def moore_to_dot(moore:LTS):
    outvars = [var for (var, vals) in moore.model_by_name.items()]
    return to_dot(moore, outvars)
#    dot_lines = StrAwareList()
#    dot_lines += 'digraph module {\n'
#
#    dot_lines += _colorize_nodes(moore) + ''
#
#    dot_lines += _label_states_with_outvalues(moore)
#
#    for args, x_state in moore.tau_model.items():
#        inputvals = _get_inputvals(args)
#        inputvals_str = _convert_to_dot(inputvals)
#
#        dot_lines += '"{state}" -> "{x_state}" [label="{in}"]'.format_map({'state': args['state'],
#                                                                           'x_state': x_state,
#                                                                           'in':inputvals_str})
#    dot_lines += '}'
#
#    return '\n'.join(dot_lines)
