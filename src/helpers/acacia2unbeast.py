#!/usr/bin/env python3
from io import StringIO, BytesIO

import sys
import os

sys.path.append(os.path.dirname(os.path.realpath(__file__)) + '/../')


import logging

from interfaces.parser_expr import BinOp, Number, UnaryOp, QuantifiedSignal, ForallExpr
from parsing.helpers import Visitor
from parsing import acacia_parser

import xml.etree.ElementTree as ET
from xml.etree.ElementTree import Element


class ConverterToUnbeast(Visitor):
    def __init__(self):
        pass

    def visit_binary_op(self, binary_op:BinOp):
        arg1 = self.dispatch(binary_op.arg1)
        arg2 = self.dispatch(binary_op.arg2)

        elem = None

        if binary_op.name == '*':
            elem = ET.Element('And')

        if binary_op.name == '=':
            if isinstance(arg1, Number):
                number_arg, signal_arg = arg1, arg2
            else:
                number_arg, signal_arg = arg2, arg1

            if number_arg == Number(1):
                elem = signal_arg
            else:
                elem = ET.Element('Not')
                elem.append(signal_arg)
            return elem

        if binary_op.name == '+':
            elem = ET.Element('Or')

        if binary_op.name == 'U':
            elem = ET.Element('U')

        if binary_op.name == '->':
            elem = ET.Element('Or')
            orig_arg1 = arg1
            arg1 = ET.Element('Not')
            arg1.append(orig_arg1)
            arg2 = arg2

        if binary_op.name == '<->':
            elem = ET.Element('Iff')

        assert elem is not None, 'unknown binary operator: ' + "'" + str(binary_op.name) + "'"

        elem.extend([arg1, arg2])

        return elem

    def visit_unary_op(self, unary_op:UnaryOp):
        assert unary_op.name in ('G', 'F', 'X', '!'), 'unknown unary operator: ' + str(unary_op.name)

        if unary_op.name == '!':
            elem = ET.Element('Not')
        else:
            elem = ET.Element(unary_op.name)

        arg = self.dispatch(unary_op.arg)
        elem.append(arg)

        return elem

    def visit_bool(self, bool_const):
        return ET.Element(bool_const.name.upper())

    def visit_signal(self, signal):
        suffix = ''
        if isinstance(signal, QuantifiedSignal) and len(signal.binding_indices) > 0:
            suffix = '_' + '_'.join(map(str, signal.binding_indices))

        name = (signal.name + suffix)
        elem = ET.Element('Var')
        elem.text = name
        return elem

    def visit_number(self, number:Number):
        return number

    def visit_forall(self, node:ForallExpr):
        assert 0


def _define_signals(signals, root:Element):
    for i in signals:
        #: :type: QuantifiedSignal
        i = i
        input_element = ET.SubElement(root, 'Bit')
        input_element.text = str(i)


def _define_properties(properties, root:Element):
    for p in properties:
        root.append(ConverterToUnbeast().dispatch(p))


def _get_doctype():
    return '<!DOCTYPE SynthesisProblem SYSTEM "./SynSpec.dtd">\n'


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print('Missing arguments. \n{me} <acacia_ltl> <output_prefix>'.format(me=__file__))
        exit(0)

    ltl_text = open(sys.argv[1]).read()
    part_text = open(sys.argv[1].replace('.ltl', '.part')).read()

    input_signals, output_signals, data_by_name = acacia_parser.parse(ltl_text, part_text, logging.getLogger())

    root = ET.Element('SynthesisProblem')
    ET.SubElement(root, 'Title')
    ET.SubElement(root, 'Description')
    path_to_ltl = ET.SubElement(root, 'PathToLTLCompiler')
    path_to_ltl.text = 'hoho!'  # unbeast cannot handle an empty path

    #: :type: Element
    inputs_element = ET.SubElement(root, 'GlobalInputs')
    _define_signals(input_signals, inputs_element)

    outputs_element = ET.SubElement(root, 'GlobalOutputs')
    _define_signals(output_signals, outputs_element)

    all_assumptions = set()
    all_guarantees = set()
    for unit, (assumptions, guarantees) in data_by_name.items():
        all_assumptions.update(assumptions)
        all_guarantees.update(guarantees)

    assumptions_element = ET.SubElement(root, 'Assumptions')
    _define_properties(all_assumptions, assumptions_element)

    guarantees_element = ET.SubElement(root, 'Specification')
    _define_properties(all_guarantees, guarantees_element)

    tmp_out = BytesIO()
    ET.ElementTree(root).write(tmp_out)

    # hack: i don't know how to add doctype
    unbeast_content = _get_doctype() + str(tmp_out.getvalue(), encoding='utf8')

    out_file_name = sys.argv[2].strip() + '.xml'
    with open(out_file_name, 'w') as output:
        output.write(unbeast_content)
