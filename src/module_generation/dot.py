from _collections_abc import Iterable
import unittest
import logging
from unittest import TestCase

from helpers.console_helpers import print_green, print_red
from helpers.python_ext import StrAwareList, add_dicts, lmap
from interfaces.automata import Label
from interfaces.lts import LTS
from interfaces.expr import QuantifiedSignal, Signal
from third_party import boolean


def _colorize_nodes(lts):
    dot_lines = StrAwareList()

    for state in lts.states:
        color = ''
        if state in lts.init_states:
            color = 'fillcolor="green",style=filled'

        dot_lines += '"{state}" [{color}]'.format(state=str(state), color=color)

    return dot_lines


def _convert_to_dot(value_by_signal:dict) -> str:
    #TODO: create FuncDescription with name as QuantifiedSignal_i in Impl?

    values_str_list = []
    for (var,value) in value_by_signal.items():
        if isinstance(var, Signal):
            display_str = ['-',''][value] + var.name
        else:
            display_str = str(value.name)
        values_str_list.append(display_str)

    res = '\\n'.join(values_str_list)

    return res

    # values_str = '\\n'.join(['{value}{var}'.format(value=['-', ''][value],
    #                                                var=signal.name if isinstance(signal, Signal) else signal)
    #                          for (signal, value) in value_by_signal.items()])


def _get_inputvals(label:dict, state_args) -> dict:
    inputvals = dict(label)
    for k in state_args:
        del inputvals[k]
    return inputvals


def _get_outputvals(label:dict, lts:LTS, outvars_treated_as_moore) -> dict:
    outvar_vals = [(var, vals) for (var, vals) in lts.model_by_name.items()
                   if var not in outvars_treated_as_moore]

    outvals = dict([(var, values[label]) for (var, values) in outvar_vals])
    return outvals


def _label_states_with_outvalues(lts:LTS, state_args, filter='all'):
    # state_args = [ARG_S_a_STATE, ARG_S_g_STATE, ARG_L_a_STATE, ARG_L_g_STATE, ARG_MODEL_STATE]
    print_green(state_args)

    dot_lines = StrAwareList()
    print_red(filter)

    for state in lts.states:
        signal_model_pairs = [(signal, model)
                              for (signal, model) in lts.model_by_name.items()
                              if signal in filter or filter == 'all']

        value_by_signal = dict()
        for signal,model in signal_model_pairs:
            print_red(state)
            # TODO: fragile
            state_label = Label(zip(state_args, state if isinstance(state, Iterable)
                                                else [state]))
            value = model[state_label]
            value_by_signal[signal] = value

        outvals_str = _convert_to_dot(value_by_signal)

        color = ''
        if state in lts.init_states:
            color = 'fillcolor="green", style=filled, '

        if outvals_str != '':
            dot_lines += '"{state}"[{color} label="{out}\\n{state}"]'.format(color=color, state=state, out=outvals_str)
        else:
            dot_lines += '"{state}"[{color} label="{state}"]'.format(color=color, state=state)

    return dot_lines


def _to_expr(l:Label) -> boolean.Expression:
    expr = boolean.TRUE
    for var, val in l.items():
        s = boolean.Symbol(str(var))   # boolean.py has the bug when object is not a string
        # s = boolean.Symbol(var)
        expr = (expr * s) if val else (expr * ~s)
    return expr


def _to_label(cube:boolean.Expression) -> Label:
    label = dict()
    for l in cube.literals:
        #: :type: boolean.Expression
        l = l
        assert len(list(l.symbols)) == 1
        symbol = list(l.symbols)[0]
        assert str(symbol.obj) not in label
        label[str(symbol.obj)] = not isinstance(l, boolean.NOT)

    return label


def _build_srcdst_to_io_labels(lts:LTS, state_args, outvars_treated_as_moore) -> dict:
    srcdst_to_io_labels = dict()
    for label, next_state in lts.tau_model.items():
        if len(state_args) > 1:
            crt_state = tuple(map(lambda k: label[k], state_args))
        else:
            crt_state = label[state_args[0]]

        i_label = _get_inputvals(label, state_args)
        o_label = _get_outputvals(label, lts, outvars_treated_as_moore)

        io_label = Label(add_dicts(i_label, o_label))

        srcdst_to_io_labels[(crt_state, next_state)] = srcdst_to_io_labels.get((crt_state, next_state), list())
        srcdst_to_io_labels[(crt_state, next_state)].append(io_label)

    return srcdst_to_io_labels


def _simplify_srcdst_to_io_labels(srcdst_to_io_labels:dict) -> dict:
    """ Careful -- side effect is that every signal becomes string in the returned result.
    """
    assert 0, 'there is a bug somewhere here, do not comment me! -- try to update that third-party package'

    simplified_srcdst_to_io_labels = dict()
    for (src, dst), io_labels in srcdst_to_io_labels.items():
        io_labels_as_exprs = [_to_expr(l) for l in io_labels]

        io_labels_as_dnf = boolean.FALSE
        for le in io_labels_as_exprs:
            io_labels_as_dnf = io_labels_as_dnf + le

        assert io_labels_as_dnf != boolean.FALSE

        simplified_io_labels_as_exprs = tuple()

        if io_labels_as_dnf != boolean.TRUE:
            simplified_io_labels_as_exprs = boolean.normalize(boolean.OR, io_labels_as_dnf)

        simplified_io_labels = [_to_label(e) for e in simplified_io_labels_as_exprs]
        simplified_srcdst_to_io_labels[(src, dst)] = simplified_io_labels

    return simplified_srcdst_to_io_labels


def _lts_to_dot(lts:LTS, state_args, outvars_treated_as_moore):
    logger = logging.getLogger(__file__)

    dot_lines = StrAwareList()
    dot_lines += 'digraph module {\n rankdir=LR;\n'

    # dot_lines += _colorize_nodes(lts) + '\n'

    dot_lines += _label_states_with_outvalues(lts, state_args, outvars_treated_as_moore)

    srcdst_to_io_labels = _build_srcdst_to_io_labels(lts, state_args, outvars_treated_as_moore)
    logger.debug('non-simplified model: \n' + str(srcdst_to_io_labels))

    # the bug is somewhere there: TRY MY OWN IMPLEMENTATION
    # simplified_srcdst_to_io_labels = _simplify_srcdst_to_io_labels(srcdst_to_io_labels)
    # simplified_srcdst_to_io_labels = dict()
    # for (src,dst),io_labels in srcdst_to_io_labels.items():
    #     simplified_srcdst_to_io_labels[(src,dst)] = minimize_dnf_set(io_labels)

    # simplified_srcdst_to_io_labels = minimize_dnf_set()

    simplified_srcdst_to_io_labels = srcdst_to_io_labels
    # logger.debug('the model after edge simplifications: \n' + str(simplified_srcdst_to_io_labels))

    for (src, dst), io_labels in simplified_srcdst_to_io_labels.items():
        if not io_labels:
            dot_lines += '"{state}" -> "{x_state}" [label="1"]'.format(state=src, x_state=dst)
        for io_label in io_labels:
            i_vals = dict()
            o_vals = dict()
            for signal, value in io_label.items():
                if str(signal) in lmap(str, lts.input_signals):  # TODO: hack -- simplification has side-effects -- it turns every signal into string..
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

    dot_lines += '}'

    return '\n'.join(dot_lines)


def lts_to_dot(lts:LTS, state_args, is_mealy):
    if is_mealy:
        return _lts_to_dot(lts, state_args, tuple())

    outvars = [var for (var, vals) in lts.model_by_name.items()]
    return _lts_to_dot(lts, state_args, outvars)


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
        srcdst_io_labels[('t2', 't5')] = [{QuantifiedSignal('prev', 0): True, 'mlocked_0': True, QuantifiedSignal('sready', 0): True, QuantifiedSignal('mbusreq', 0): True},
                                          {QuantifiedSignal('prev', 0): True, 'mlocked_0': True, QuantifiedSignal('sready', 0): False, QuantifiedSignal('mbusreq', 0): True},
                                          {QuantifiedSignal('prev', 0): True, 'mlocked_0': False, QuantifiedSignal('sready', 0): True, QuantifiedSignal('mbusreq', 0): False},
                                          {QuantifiedSignal('prev', 0): True, 'mlocked_0': True, QuantifiedSignal('sready', 0): True, QuantifiedSignal('mbusreq', 0): False},
                                          {QuantifiedSignal('prev', 0): True, 'mlocked_0': True, QuantifiedSignal('sready', 0): False, QuantifiedSignal('mbusreq', 0): False},
                                          {QuantifiedSignal('prev', 0): True, 'mlocked_0': False, QuantifiedSignal('sready', 0): False, QuantifiedSignal('mbusreq', 0): False},
                                          {QuantifiedSignal('prev', 0): True, 'mlocked_0': False, QuantifiedSignal('sready', 0): False, QuantifiedSignal('mbusreq', 0): True},
                                          {QuantifiedSignal('prev', 0): True, 'mlocked_0': False, QuantifiedSignal('sready', 0): True, QuantifiedSignal('mbusreq', 0): True}]

        simplified_srcdst_io_labels = _simplify_srcdst_to_io_labels(srcdst_io_labels)

        self.assertDictEqual(simplified_srcdst_io_labels, {('t2', 't5'): [{'prev_0': True}]})  # kinda hack - returns strings instead of Signals..


if __name__ == "__main__":
    unittest.main()

