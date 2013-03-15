from itertools import chain
import logging
import sys
from architecture.scheduler import ACTIVE_NAME
from interfaces.parser_expr import  and_expressions, Signal, Bool, BinOp, UnaryOp, ForallExpr, Number, QuantifiedSignal
from optimizations import _instantiate_expr, _instantiate_expr2
from parsing.helpers import Visitor
from parsing.par_lexer_desc import PAR_GUARANTEES
from parsing.par_parser import parse_ltl

spec = """
[INPUT_VARIABLES]
r;

[OUTPUT_VARIABLES]
g;

[ASSUMPTIONS]

[GUARANTEES]
Forall (i) (g_i=0);

#no spurious grant on start
Forall (i) (!(((r_i=0) * (g_i=0)) U ((r_i=0) * g_i=1)));

#no spurious grants
Forall (i) (!F(g_i=1 * X((r_i=0) * g_i=0) * X(((r_i=0) * g_i=0) U (g_i=1 * r_i=0) )) );

#every grant is lowered unless request keeps staying high
#Forall (i) G( (active_i=1 * (r_i=0) * g_i=1) -> F((r_i=1 * g_i=1) + (g_i=0)) );
Forall (i) G( ((r_i=0) * g_i=1) -> F((r_i=1 * g_i=1) + (g_i=0)) );

#Forall (i) G( (active_i=1 * (r_i=1)) -> F(g_i=1) );
Forall (i) G( ((r_i=1)) -> F(g_i=1) );

#mutual exclusion
Forall (i,j) G(!(g_i=1 * g_j=1));
"""


class ConverterToWringVisitor(Visitor):
    def visit_number(self, number:Number):
        return str(number)


    def visit_forall(self, node:ForallExpr):
        assert 0


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
#        if signal.name == ACTIVE_NAME:
#            return 'TRUE'
#
        return str(signal)



if len(sys.argv) != 3:
    print('Provide <the number of clients> and <output file prefix>')
    exit(0)

nof_processes = int(sys.argv[1])
out_file_prefix = sys.argv[2]

assert nof_processes > 1, 'should be at least two clients: ' + str(nof_processes)

section_by_name = parse_ltl(spec, logging.getLogger())
input_signals = [QuantifiedSignal('r', i) for i in range(nof_processes)]
output_signals = [QuantifiedSignal('g', i) for i in range(nof_processes)]

guarantees = section_by_name[PAR_GUARANTEES]

inst_guarantees = list(chain(*[_instantiate_expr2(g, nof_processes, False)
                               for g in guarantees]))

gua_lines = [ConverterToWringVisitor().dispatch(g) + ';\n'
             for g in inst_guarantees]

with open(out_file_prefix + str(nof_processes) + '.ltl', 'w') as ltl_file:
    ltl_file.writelines(gua_lines)

with open(out_file_prefix + str(nof_processes) + '.part', 'w') as part_file:
    part_file.writelines(['.inputs ' + ' '.join(map(str, input_signals)) + '\n',
                          '.outputs ' + ' '.join(map(str, output_signals)) + '\n'])
