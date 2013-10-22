from helpers.boolean_helper import dnf
from helpers.labels_map import LabelsMap
from helpers.python_ext import StrAwareList, lmap, add_dicts
from interfaces.automata import Label
from interfaces.lts import LTS
from interfaces.parser_expr import QuantifiedSignal
import third_party
import third_party.boolean as boolean


def _colorize_nodes(lts):
    dot_lines = StrAwareList()

    for state in lts.states:
        dot_lines += '"{state}" [{color}]'.format_map({'state': state,
                                                       'color': ['', 'fillcolor="green",style=filled'][
                                                           state in lts.init_states]})

    return dot_lines


def _convert_to_dot(value_by_signal:dict) -> str:
    #TODO: create FuncDescription with name as QuantifiedSignal_i in Impl?

    values_str = '\\n'.join(
        ['{value}{var}'.format(
            value=['-', ''][value],
            var=signal.name if isinstance(signal, QuantifiedSignal) else signal)
         for (signal, value) in value_by_signal.items()])

    return values_str


def _get_inputvals(label:dict) -> dict:
    inputvals = dict(label)
    del inputvals['state']  # TODO: hack -- hardcoded 'state'
    return inputvals


def _get_outputvals(label:dict, lts:LTS, outvars_treated_as_moore) -> dict:
    outvar_vals = [(var, vals) for (var, vals) in lts.model_by_name.items()
                   if var not in outvars_treated_as_moore]

    print('should be sig,dict type: ', outvar_vals)
    outvals = dict([(var, values[label]) for (var, values) in outvar_vals])
    return outvals


def _label_states_with_outvalues(lts:LTS, filter='all'):
    dot_lines = StrAwareList()

    for state in lts.states:
        signal_vals_pairs = [(var, vals) for (var, vals) in lts.model_by_name.items()
                             if var in filter or filter == 'all']
        outvals = dict([(var, vals[Label({'state': state})])
                        for (var, vals) in signal_vals_pairs])  # TODO: hack

        outvals_str = _convert_to_dot(outvals)
        if outvals_str != '':
            dot_lines += '"{state}"[label="{out}"]'.format(state=state, out=outvals_str)

    return dot_lines


#def old_to_dot(lts:LTS, outvars_treated_as_moore=()):
#    dot_lines = StrAwareList()
#    dot_lines += 'digraph module {\n'
#
#    dot_lines += _colorize_nodes(lts) + '\n'
#
#    dot_lines += _label_states_with_outvalues(lts, outvars_treated_as_moore)
#
#    for label, next_state in lts.tau_model.items():
#        outvar_vals = [(var, vals) for (var, vals) in lts.model_by_name.items()
#                       if var not in outvars_treated_as_moore]
#
#        outvals = dict([(var, values[label]) for (var, values) in outvar_vals])
#        outvals_str = _convert_to_dot(outvals)
#        outvals_str = '/' + outvals_str if outvals_str != '' else ''
#
#        inputvals = _get_inputvals(label)
#        inputvals_str = _convert_to_dot(inputvals)
#
#        dot_lines += '"{state}" -> "{x_state}" [label="{in}{mark_out}"]'.format_map(
#            {'state': label['state'], # TODO: hack
#             'x_state': next_state,
#             'in': inputvals_str,
#             'mark_out': outvals_str})
#
#    dot_lines += '}'
#
#    return '\n'.join(dot_lines)


def _to_expr(l:LabelsMap) -> boolean.Expression:
    expr = boolean.TRUE
    for var, val in l.items():
        s = boolean.Symbol(var)
        expr = (expr * s) if val else (expr * ~s)
    return expr


def _to_label(clause:boolean.Expression) -> LabelsMap:
    labels_map = dict()
    for l in clause.literals:
        #: :type: boolean.Expression
        l = l
        assert len(list(l.symbols)) == 1
        symbol = list(l.symbols)[0]
        labels_map[symbol.obj] = not isinstance(l, boolean.NOT)
    print('labels_map for clause is ', clause, labels_map)
    return labels_map


def _build_srcdst_to_io_labels(lts:LTS, outvars_treated_as_moore) -> dict:
    srcdst_to_io_labels = dict()
    for label, next_state in lts.tau_model.items():
        crt_state = label['state']

        i_label = _get_inputvals(label)
        o_label = _get_outputvals(label, lts, outvars_treated_as_moore)

        io_label = add_dicts(i_label, o_label)

        srcdst_to_io_labels[(crt_state, next_state)] = srcdst_to_io_labels.get((crt_state, next_state), list())
        srcdst_to_io_labels[(crt_state, next_state)].append(io_label)
    return srcdst_to_io_labels


def _simplify_srcdst_to_io_labels(srcdst_to_io_labels:dict) -> dict:
    simplified_srcdst_to_io_labels = dict()
    for (src, dst), io_labels in srcdst_to_io_labels.items():
        io_labels_as_exprs = [_to_expr(l) for l in io_labels]

        io_labels_as_dnf = boolean.FALSE
        for le in io_labels_as_exprs:
            io_labels_as_dnf = io_labels_as_dnf + le

        simplified_io_labels_as_exprs = tuple()  # FALSE is impossible
        if io_labels_as_dnf != boolean.TRUE:
            simplified_io_labels_as_exprs = boolean.normalize(boolean.OR, io_labels_as_dnf)

        simplified_io_labels = [_to_label(e) for e in simplified_io_labels_as_exprs]
        simplified_srcdst_to_io_labels[(src, dst)] = simplified_io_labels

        print('orig: ', (src,dst), ':', io_labels)
        print('simplified: ', (src,dst), ':', simplified_io_labels)
        print()

    return simplified_srcdst_to_io_labels


def to_dot(lts:LTS, outvars_treated_as_moore=()):
    dot_lines = StrAwareList()
    dot_lines += 'digraph module {\n'

    dot_lines += _colorize_nodes(lts) + '\n'

    dot_lines += _label_states_with_outvalues(lts, outvars_treated_as_moore)

    srcdst_to_io_labels = _build_srcdst_to_io_labels(lts, outvars_treated_as_moore)

    simplified_srcdst_to_io_labels = _simplify_srcdst_to_io_labels(srcdst_to_io_labels)

    for (src, dst), io_labels in simplified_srcdst_to_io_labels.items():
        i_vals = dict()
        o_vals = dict()
        for io_label in io_labels:
            for signal,value in io_label.items():
                if signal in lts.input_signals:
                    i_vals[signal] = value
                else:
                    o_vals[signal] = value

        i_vals_str = _convert_to_dot(i_vals) or '*'
        o_vals_str = _convert_to_dot(o_vals)
        o_vals_str = '/' + '\\n' + o_vals_str if o_vals_str != '' else ''

        dot_lines += '"{state}" -> "{x_state}" [label="{in}{mark_out}"]'.format_map(
            {'state': src,
             'x_state': dst,
             'in': i_vals_str,
             'mark_out': o_vals_str})

    #outvar_vals = [(var, vals) for (var, vals) in lts.model_by_name.items()
    #               if var not in outvars_treated_as_moore]
    #
    #outvals = dict([(var, values[label]) for (var, values) in outvar_vals])
    #outvals_str = _convert_to_dot(outvals)
    #outvals_str = '/' + outvals_str if outvals_str != '' else ''
    #
    #inputvals = _get_inputvals(label)
    #inputvals_str = _convert_to_dot(inputvals)

    dot_lines += '}'

    return '\n'.join(dot_lines)


def moore_to_dot(moore:LTS):
    outvars = [var for (var, vals) in moore.model_by_name.items()]
    return to_dot(moore, tuple(outvars))
