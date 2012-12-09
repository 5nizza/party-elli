from helpers.ply import yacc
from parsing.anzu_parser_desc import anzu_parser
from parsing.par_lexer_desc import par_lexer

pnueli_arbiter_spec = """
[INPUT_VARIABLES] #no support of global variables => all the variables are assumed to be indexed!
r;

[OUTPUT_VARIABLES]
g;

[ENV_TRANSITIONS]
Forall (i) r_i=0;
Forall (i) G(((r_i=1)*(g_i=0)->X(r_i=1)) * ((r_i=0)*(g_i=1)->X(r_i=0)));

[SYS_TRANSITIONS]
Forall (i) g_i=0;
Forall (i,j) G(!((g_i=1) * (g_j=1)));
Forall (i) G((((r_i=0)*(g_i=0))->X(g_i=0)) * (((r_i=1)*(g_i=1))->X(g_i=1)));

[ASSUMPTIONS]
Forall (i) G(F((r_i=0)+(g_i=0)));

[GUARANTEES]
Forall(i) G(F(((r_i=1)*(g_i=1)) + ((r_i=0)*(g_i=0))));
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
Forall (i) G( (active_i=1 * (r_i=0) * g_i=1) -> F((r_i=1 * g_i=1) || (g_i=0)) );

Forall (i) G( (active_i=1 * (r_i=1)) -> F(g_i=1) );

Forall (i,j) G(!(g_i=1 * g_j=1));
"""

def parse_ltl(par_text):
    """ Return {section:data}, see sections in syntax_desc """
    section_name_to_data = dict(anzu_parser.parse(par_text, lexer=par_lexer))
    return section_name_to_data


########################################################################
# tests





from unittest import TestCase
class Test(TestCase):
    def tests_all(self):
        result = yacc.parse(test_string)

        section_name_to_data = dict(result)
        for (k, v) in result:
            print(k, v)

        expected_results = {'INPUT_VARIABLES':9, 'OUTPUT_VARIABLES':18,
                            'SYS_FAIRNESS':5, 'SYS_TRANSITIONS':5, 'SYS_INITIAL':18,
                            'ENV_FAIRNESS':2, 'ENV_TRANSITIONS':3, 'ENV_INITIAL':9}

        for section_name, data in section_name_to_data.items():
            actual = len(data)
            expected = expected_results[section_name]
            assert actual == expected, '{actual} != {expected}: {section}'.format(
                actual = actual, expected =expected, section = section_name)


