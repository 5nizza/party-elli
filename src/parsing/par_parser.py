from logging import Logger
from helpers.ply import yacc
from parsing.helpers import Visitor
from interfaces.parser_expr import Signal, QuantifiedSignal, Expr
from parsing.par_lexer_desc import par_lexer, PAR_INPUT_VARIABLES, PAR_OUTPUT_VARIABLES, PAR_ASSUMPTIONS, PAR_GUARANTEES
from parsing.par_parser_desc import par_parser


pnueli_arbiter_spec = """
[INPUT_VARIABLES] #no support of global variables => all the variables are assumed to be indexed!
r;

[OUTPUT_VARIABLES]
g;

[ASSUMPTIONS]
Forall (i) r_i=0;
Forall (i) G(((r_i=1)*(g_i=0)->X(r_i=1)) * ((r_i=0)*(g_i=1)->X(r_i=0)));

Forall (i) G(F((r_i=0)+(g_i=0)));

[GUARANTEES]
Forall (i) g_i=0;
Forall (i,j) G(!((g_i=1) * (g_j=1)));
Forall (i) G((((r_i=0)*(g_i=0))->X(g_i=0)) * (((r_i=1)*(g_i=1))->X(g_i=1)));

Forall (i) G(F(((r_i=1)*(g_i=1)) + ((r_i=0)*(g_i=0))));
"""


full_arbiter_spec = """
[INPUT_VARIABLES] #no support of global variables => all the variables are assumed to be indexed!
r;
#active is an internal variable

[OUTPUT_VARIABLES]
g;

[ASSUMPTIONS]
Forall (i) r_i=0;

[GUARANTEES]
Forall (i) (g_i=0);

#no spurious grant on start
Forall (i) (!(((r_i=0) * (g_i=0)) U ((r_i=0) * g_i=1)));

#no spurious grants
Forall (i) (!F(g_i=1 * X((r_i=0) * g_i=0) * X(((r_i=0) * g_i=0) U (g_i=1 * r_i=0) )) );

#every grant is lowered unless request keeps staying high
Forall (i) G( (active_i=1 * (r_i=0) * g_i=1) -> F((r_i=1 * g_i=1) + (g_i=0)) );

Forall (i) G( (active_i=1 * (r_i=1)) -> F(g_i=1) );

Forall (i,j) G(!(g_i=1 * g_j=1));
"""

def parse_ltl(par_text:str, logger:Logger) -> dict:
    #TODO: current version of parser is very restrictive: it allows only the specs of the form:
    # Forall (i,j..) ass_i_j -> (Forall(k) gua_k * Forall(l,m) gua_l_m)
    # it is impossible to have:
    # (Forall(i) a_i  ->  Forall(k) g_k) * (Forall(i,j) a_i_j  ->  Forall(i) g_i)
    # what we can have is:
    # (Forall(i,j,k) ((a_i -> g_i)) * (Forall(i,j) a_i_j -> g_i)

    """ Return {section:data}, see sections in syntax_desc """

    logger.info('parsing input spec..')
    section_name_to_data = dict(par_parser.parse(par_text, lexer=par_lexer))

    #TODO: check unknown signals
    return section_name_to_data


########################################################################
# tests

from unittest import TestCase

class QuantifiedSignalsFinderVisitor(Visitor):
    def __init__(self):
        self.quantified_signals = set()

    def visit_signal(self, signal:Signal):
        if isinstance(signal, QuantifiedSignal):
            self.quantified_signals.add(signal)

    def find_quantified_signals(self, expr:Expr) -> set:
        self.dispatch(expr)
        return self.quantified_signals


class Test(TestCase):
    def _do_test(self, test_name:str, spec:str, quantified_signal_names_expected:set, expected_result):
        print(test_name)
        result = yacc.parse(spec)

        section_name_to_data = dict(result)
        for (k, v) in result:
            print(k, v)

        for section_name, data in section_name_to_data.items():
            actual = len(data)
            expected = expected_result[section_name]
            assert actual == expected, '{actual} != {expected}: {section}: {section_data}'.format(
                actual = actual,
                expected =expected,
                section = section_name,
                section_data=str(section_name_to_data[section_name]))

        quantified_signals_finder = QuantifiedSignalsFinderVisitor()
        all_properties = self._get_all_properties(section_name_to_data)

        [quantified_signals_finder.dispatch(p) for p in all_properties]

        quantified_signal_names = set(map(lambda qs: qs.name, quantified_signals_finder.quantified_signals))
        assert quantified_signal_names_expected == quantified_signal_names, \
               'expected {0}, got {1}'.format(quantified_signal_names_expected, quantified_signal_names)


    def test_pnueli(self):
        self._do_test('pnueli', pnueli_arbiter_spec, {'r', 'g'},
            {PAR_INPUT_VARIABLES:1, PAR_OUTPUT_VARIABLES:1, PAR_ASSUMPTIONS:3, PAR_GUARANTEES:4})


    def test_full(self):
        self._do_test('full', full_arbiter_spec, {'active', 'r', 'g'},
            {PAR_INPUT_VARIABLES:1, PAR_OUTPUT_VARIABLES:1, PAR_ASSUMPTIONS:1, PAR_GUARANTEES:6})


    def test_priorities(self):
        whole_text = '''
        [INPUT_VARIABLES]
        [OUTPUT_VARIABLES]
        [ASSUMPTIONS]
        [GUARANTEES]
        {0};
        '''
        text = whole_text.format('b_0=1 -> c_0=1 * c_1=1 * c_2=1 * c_3=1')

        section_data = dict(par_parser.parse(text))

        expressions = section_data[PAR_GUARANTEES]

        assert len(expressions) == 1, str(expressions)
        assert expressions[0].name == '->'


    def _get_all_properties(self, section_name_to_data:dict):
        return list(section_name_to_data[PAR_ASSUMPTIONS]) + list(section_name_to_data[PAR_GUARANTEES])