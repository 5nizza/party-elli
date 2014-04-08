#!/usr/bin/env python3

from itertools import chain
import logging
import sys
from architecture.scheduler import ACTIVE_NAME
from architecture.tok_ring import HAS_TOK_NAME
from interfaces.parser_expr import Signal, Bool, BinOp, UnaryOp, ForallExpr, Number, QuantifiedSignal
from spec_optimizer.optimizations import _instantiate_expr2
from parsing.helpers import Visitor
from parsing.par_lexer_desc import PAR_GUARANTEES, PAR_ASSUMPTIONS
from parsing.par_parser import parse_ltl


class ConverterToWringVisitor(Visitor):
    def visit_number(self, number:Number):
        return str(number)

    def visit_forall(self, node:ForallExpr):
        # assert 0
        return self.dispatch(node.arg2)

    def visit_unary_op(self, unary_op:UnaryOp):
        arg = self.dispatch(unary_op.arg)

        return '({op}({arg}))'.format(op=unary_op.name, arg=arg)

    def visit_binary_op(self, binary_op:BinOp):
        arg1, arg2 = self.dispatch(binary_op.arg1), self.dispatch(binary_op.arg2)

        if binary_op.name == '=':
            #don't add spaces around '=' -- Acacia cannot recognize this
            return '({arg1}{op}{arg2})'.format(arg1=arg1, arg2=arg2, op=binary_op.name)
        else:
            return '({arg1} {op} {arg2})'.format(arg1=arg1, arg2=arg2, op=binary_op.name)

    def visit_tuple(self, node:tuple):
        assert 0

    def visit_bool(self, bool_const:Bool):
        return str(bool_const).upper()

    def visit_signal(self, signal:Signal):
        # assert signal.name != ACTIVE_NAME, 'not supported:' + str(signal.name)
        # assert signal.name != HAS_TOK_NAME, 'not supported:' + str(signal.name)

        return str(signal)


def _instantiate(spec_text):
    section_by_name = parse_ltl(spec_text, logging.getLogger())
    input_signals = [QuantifiedSignal('r', i) for i in range(nof_processes)]
    output_signals = [QuantifiedSignal('g', i) for i in range(nof_processes)]

    assumptions = section_by_name[PAR_ASSUMPTIONS]
    guarantees = section_by_name[PAR_GUARANTEES]

    inst_assumptions = list(chain(*[_instantiate_expr2(a, nof_processes, False)
                                    for a in assumptions]))

    inst_guarantees = list(chain(*[_instantiate_expr2(g, nof_processes, False)
                                   for g in guarantees]))

    assumptions_as_strings = [ConverterToWringVisitor().dispatch(a) + ';\n'
                              for a in inst_assumptions]
    guarantees_as_strings = [ConverterToWringVisitor().dispatch(g) + ';\n'
                             for g in inst_guarantees]

    return input_signals, output_signals, assumptions_as_strings, guarantees_as_strings


if __name__ == '__main__':
    if len(sys.argv) != 4:
        print('Provide <parameterized spec> <the number of processes> and <output file prefix>')
        exit(0)

    spec = open(sys.argv[1]).read()
    nof_processes = int(sys.argv[2])
    out_file_prefix = sys.argv[3]

    assert nof_processes > 1, 'should be at least two processes: ' + str(nof_processes)

    input_signals, output_signals, assumptions, guarantees = _instantiate(spec)

    with open(out_file_prefix + str(nof_processes) + '.ltl', 'w') as ltl_file:
        ltl_file.writelines(['assume ' + a for a in assumptions])
        ltl_file.writelines(guarantees)

    with open(out_file_prefix + str(nof_processes) + '.part', 'w') as part_file:
        part_file.writelines(['.inputs ' + ' '.join(map(str, input_signals)) + '\n',
                              '.outputs ' + ' '.join(map(str, output_signals)) + '\n'])
