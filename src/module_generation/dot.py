import logging

from helpers.python_ext import StrAwareList, add_dicts
from interfaces.automata import Label
from interfaces.lts import LTS
from module_generation.edges_simplifier import simplify_edge_labels


def _convert_label_to_dot(value_by_variable:dict) -> str:
    values_str_list = []
    for (var,value) in value_by_variable.items():
        if isinstance(value, bool):
            display_str = ['-',''][value] + var.name
        else:
            display_str = str(value.name)
        values_str_list.append(display_str)

    res = ' '.join(values_str_list)

    return res


def _mark_states_with_moore_signals(lts:LTS, state_variable, moore_signals):
    dot_lines = StrAwareList()

    for state in lts.states:
        state_label = Label({state_variable: state})
        value_by_signal = dict()
        for signal in moore_signals:
            signal_model = lts.model_by_signal[signal]
            value = signal_model[state_label]
            value_by_signal[signal] = value

        signals_str = _convert_label_to_dot(value_by_signal)

        color = ''
        if state in lts.init_states:
            color = 'fillcolor="green", style=filled, '

        if signals_str != '':
            dot_lines += '"{state}"[{color} label="{out}\\n{state}"]'.format(color=color,
                                                                             state=state,
                                                                             out=signals_str)
        else:
            dot_lines += '"{state}"[{color} label="{state}"]'.format(color=color, state=state)

    return dot_lines


def _get_i_label(label:dict, state_variable) -> dict:
    i_label = dict(label)
    del i_label[state_variable]
    return i_label


def _get_o_label(label:dict, lts:LTS, moore_signals) -> dict:
    o_label = dict([(sig, lts.model_by_signal[sig][label])
                    for sig in lts.model_by_signal.keys()
                    if sig not in moore_signals])

    return o_label


def _build_edge_labels(lts:LTS, state_variable, moore_signals) -> dict:
    edge_labels = dict()
    for label, next_state in lts.tau_model.items():  # TODO: bad: it assumes that label enumerates ALL possible values!
        crt_state = label[state_variable]

        i_label = _get_i_label(label, state_variable)
        o_label = _get_o_label(label, lts, moore_signals)

        io_label = add_dicts(i_label, o_label)

        edge_labels[(crt_state, next_state)] = edge_labels.get((crt_state, next_state), list())
        edge_labels[(crt_state, next_state)].append(io_label)
    return edge_labels


def _lts_to_dot(lts:LTS, state_variable, moore_signals):
    logger = logging.getLogger(__file__)

    dot_lines = StrAwareList()
    dot_lines += 'digraph module {\n rankdir=LR;\n'
    dot_lines += _mark_states_with_moore_signals(lts, state_variable, moore_signals)

    edge_labels = _build_edge_labels(lts, state_variable, moore_signals)
    logger.debug('non-simplified model: \n' + str(edge_labels))

    simplified_edge_labels = simplify_edge_labels(edge_labels)
    # simplified_edge_labels = edge_labels

    for (src, dst), io_labels in simplified_edge_labels.items():
        if not io_labels:  # possible due to the simplification
            dot_lines += '"{src}" -> "{dst}" [label="1"]'.format(src=src, dst=dst)
        for io_label in io_labels:
            i_vals = dict()
            o_vals = dict()
            for signal, value in io_label.items():
                if signal in lts.input_signals:
                    i_vals[signal] = value
                else:
                    o_vals[signal] = value

            i_vals_str = _convert_label_to_dot(i_vals) or '1'
            o_vals_str = _convert_label_to_dot(o_vals)

            dot_lines += '"{src}" -> "{dst}" [label="{in_}{out}"]'.format(
                src=src,
                dst=dst,
                in_=i_vals_str,
                out=('/' + '\\n' + o_vals_str) if o_vals_str != '' else '')

    dot_lines += '}'

    return '\n'.join(dot_lines)


def lts_to_dot(lts:LTS, state_variable, is_mealy) -> str:
    if is_mealy:
        return _lts_to_dot(lts, state_variable, tuple())

    return _lts_to_dot(lts, state_variable, set(lts.model_by_signal.keys()))
