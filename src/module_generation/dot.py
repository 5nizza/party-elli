from _collections_abc import Iterable
import unittest
import logging
from unittest import TestCase
from helpers.console_helpers import print_green

from helpers.python_ext import StrAwareList, add_dicts, lmap
from interfaces.automata import Label
from interfaces.lts import LTS
from interfaces.expr import Signal


# def _colorize_nodes(lts):
#     dot_lines = StrAwareList()
#
#     for state in lts.states:
#         color = ''
#         if state in lts.init_states:
#             color = 'fillcolor="green",style=filled'
#
#         dot_lines += '"{state}" [{color}]'.format(state=str(state), color=color)
#
#     return dot_lines


def _convert_label_to_dot(value_by_variable:dict) -> str:
    values_str_list = []
    for (var,value) in value_by_variable.items():
        if isinstance(value, bool):
            display_str = ['-',''][value] + var.name
        else:
            display_str = str(value.name)
        values_str_list.append(display_str)

    res = '\\n'.join(values_str_list)

    return res


def _mark_states_with_moore_signals(lts:LTS, state_variable, moore_signals):
    dot_lines = StrAwareList()

    for state in lts.states:
        state_label = Label({state_variable: state})
        value_by_signal = dict()
        for signal in moore_signals:
            signal_model = lts.model_by_name[signal]
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

#
# def _to_expr(l:Label) -> boolean.Expression:
#     expr = boolean.TRUE
#     for var, val in l.items():
#         s = boolean.Symbol(str(var))   # boolean.py has the bug when object is not a string
#         # s = boolean.Symbol(var)
#         expr = (expr * s) if val else (expr * ~s)
#     return expr
#
#
# def _to_label(cube:boolean.Expression) -> Label:
#     label = dict()
#     for l in cube.literals:
#         #: :type: boolean.Expression
#         l = l
#         assert len(list(l.symbols)) == 1
#         symbol = list(l.symbols)[0]
#         assert str(symbol.obj) not in label
#         label[str(symbol.obj)] = not isinstance(l, boolean.NOT)
#
#     return label
#
#
def _build_edge_labels(lts:LTS, state_variable, moore_signals) -> dict:
    edge_labels = dict()
    for label, next_state in lts.tau_model.items():
        crt_state = label[state_variable]

        edge_label = Label((v,label[v]) for v in label
                           if v != state_variable and
                              v not in moore_signals)

        edge_labels[(crt_state, next_state)] = edge_labels.get((crt_state, next_state), list())
        edge_labels[(crt_state, next_state)].append(edge_label)

    return edge_labels
#
#
# def _simplify_srcdst_to_io_labels(srcdst_to_io_labels:dict) -> dict:
#     """ Careful -- side effect is that every signal becomes string in the returned result.
#     """
#     assert 0, 'there is a bug somewhere here, do not comment me! -- try to update that third-party package'
#
#     simplified_srcdst_to_io_labels = dict()
#     for (src, dst), io_labels in srcdst_to_io_labels.items():
#         io_labels_as_exprs = [_to_expr(l) for l in io_labels]
#
#         io_labels_as_dnf = boolean.FALSE
#         for le in io_labels_as_exprs:
#             io_labels_as_dnf = io_labels_as_dnf + le
#
#         assert io_labels_as_dnf != boolean.FALSE
#
#         simplified_io_labels_as_exprs = tuple()
#
#         if io_labels_as_dnf != boolean.TRUE:
#             simplified_io_labels_as_exprs = boolean.normalize(boolean.OR, io_labels_as_dnf)
#
#         simplified_io_labels = [_to_label(e) for e in simplified_io_labels_as_exprs]
#         simplified_srcdst_to_io_labels[(src, dst)] = simplified_io_labels
#
#     return simplified_srcdst_to_io_labels


def _lts_to_dot(lts:LTS, state_variable, moore_signals):
    logger = logging.getLogger(__file__)

    dot_lines = StrAwareList()
    dot_lines += 'digraph module {\n rankdir=LR;\n'

    # dot_lines += _colorize_nodes(lts) + '\n'

    dot_lines += _mark_states_with_moore_signals(lts, state_variable, moore_signals)

    edge_labels = _build_edge_labels(lts, state_variable, moore_signals)
    logger.debug('non-simplified model: \n' + str(edge_labels))

    # the bug is somewhere there: TRY MY OWN IMPLEMENTATION
    # simplified_srcdst_to_io_labels = _simplify_srcdst_to_io_labels(srcdst_to_io_labels)
    # simplified_srcdst_to_io_labels = dict()
    # for (src,dst),io_labels in srcdst_to_io_labels.items():
    #     simplified_srcdst_to_io_labels[(src,dst)] = minimize_dnf_set(io_labels)

    # simplified_srcdst_to_io_labels = minimize_dnf_set()    # TODO: remove all side-effects of the simplification

    simplified_edge_labels = edge_labels   # TODO: implement simplification using numpy
    # logger.debug('the model after edge simplifications: \n' + str(simplified_srcdst_to_io_labels))

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


def lts_to_dot(lts:LTS, state_variable, is_mealy):
    if is_mealy:
        return _lts_to_dot(lts, state_variable, tuple())

    return _lts_to_dot(lts, state_variable, set(lts.model_by_name.keys()))


##############################################################################
##############################################################################
class Test(TestCase):
    def test_simplify_srcdst_to_io_labels___basic1(self):
        srcdst_io_labels = dict()
        srcdst_io_labels[('t0', 't1')] = [{'r': True, 'g': False},
                                          {'r': False, 'g': False}]

        simplified_srcdst_io_labels = _simplify_srcdst_to_io_labels(srcdst_io_labels)

        self.assertDictEqual(simplified_srcdst_io_labels,
                             {('t0', 't1'): [{'g': False}]})

    def test_simplify_srcdst_to_io_labels___basic2(self):
        srcdst_io_labels = dict()

        srcdst_io_labels[('t0', 't1')] = [{'r': True, 'g': False}]

        srcdst_io_labels[('t0', 't2')] = [{'r': False, 'g': False}]

        simplified_srcdst_io_labels = _simplify_srcdst_to_io_labels(srcdst_io_labels)

        self.assertDictEqual(simplified_srcdst_io_labels,
                             srcdst_io_labels)

    def test_simplify_srcdst_to_io_labels___complex(self):
        srcdst_io_labels = dict()

        srcdst_io_labels[('t0', 't1')] = [{'r': True, 'g': False},
                                          {'r': True, 'g': True}]

        srcdst_io_labels[('t0', 't2')] = [{'r': True, 'g': False}]

        srcdst_io_labels[('t2', 't0')] = [{'r': True, 'g': True}]

        srcdst_io_labels[('t0', 't0')] = [{'r': True, 'g': True},
                                          {'r': True, 'g': False, 'x': False}]

        simplified_srcdst_io_labels = _simplify_srcdst_to_io_labels(srcdst_io_labels)

        self.assertDictEqual(simplified_srcdst_io_labels,
                             {('t0', 't1'): [{'r': True}],
                              ('t0', 't1'): [{'r': True}],
                              ('t0', 't2'): [{'r': True, 'g': False}],
                              ('t2', 't0'): [{'r': True, 'g': True}],
                              ('t0', 't0'): [{'r': True, 'g': True},
                                             {'r': True, 'x': False}],
                             })

    def test_simplify_srcdst_to_io_labels___bug(self):
        # ('t2', 't5') :
        #[{prev_0: True, mlocked_0: True, sready_0: True, mbusreq_0: True},
        # {prev_0: True, mlocked_0: True, sready_0: False, mbusreq_0: True},
        # {prev_0: True, mlocked_0: False, sready_0: True, mbusreq_0: False},
        # {prev_0: True, mlocked_0: True, sready_0: True, mbusreq_0: False},
        # {prev_0: True, mlocked_0: True, sready_0: False, mbusreq_0: False},
        # {prev_0: True, mlocked_0: False, sready_0: False, mbusreq_0: False},
        # {prev_0: True, mlocked_0: False, sready_0: False, mbusreq_0: True},
        # {prev_0: True, mlocked_0: False, sready_0: True, mbusreq_0: True}]
        # was simplified into:
        #[{prev_0: True, sready_0: True},
        # {prev_0: True, mbusreq_0: True},
        # {prev_0: True, mlocked_0: False}]
        # but the right solution is:
        # [{prev_0: True}]
        # ------------------------------------------------
        srcdst_io_labels = dict()
        srcdst_io_labels[('t2', 't5')] = [{Signal('prev'): True, 'mlocked_0': True, Signal('sready'): True, Signal('mbusreq'): True},
                                          {Signal('prev'): True, 'mlocked_0': True, Signal('sready'): False,Signal('mbusreq'): True},
                                          {Signal('prev'): True, 'mlocked_0': False,Signal('sready'): True, Signal('mbusreq'): False},
                                          {Signal('prev'): True, 'mlocked_0': True, Signal('sready'): True, Signal('mbusreq'): False},
                                          {Signal('prev'): True, 'mlocked_0': True, Signal('sready'): False,Signal('mbusreq'): False},
                                          {Signal('prev'): True, 'mlocked_0': False,Signal('sready'): False,Signal('mbusreq'): False},
                                          {Signal('prev'): True, 'mlocked_0': False,Signal('sready'): False,Signal('mbusreq'): True},
                                          {Signal('prev'): True, 'mlocked_0': False,Signal('sready'): True, Signal('mbusreq'): True}]

        simplified_srcdst_io_labels = _simplify_srcdst_to_io_labels(srcdst_io_labels)

        self.assertDictEqual(simplified_srcdst_io_labels, {('t2', 't5'): [{'prev_0': True}]})  # kinda hack - returns strings instead of Signals..


if __name__ == "__main__":
    unittest.main()

