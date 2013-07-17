from logging import Logger
from third_party.ply import yacc
from parsing.anzu_lexer_desc import anzu_lexer, ANZU_ENV_FAIRNESS, ANZU_ENV_INITIAL, ANZU_ENV_TRANSITIONS, ANZU_SYS_FAIRNESS, ANZU_SYS_INITIAL, ANZU_SYS_TRANSITIONS, ANZU_INPUT_VARIABLES, ANZU_OUTPUT_VARIABLES
from parsing.anzu_parser_desc import anzu_parser
from parsing.sanity_checker import check_unknown_signals_in_properties


def parse_ltl(anzu_text, logger:Logger) -> dict:
    """ Return {section:data} or None in case of error """
    section_name_to_data = dict(anzu_parser.parse(anzu_text, lexer=anzu_lexer))

    input_signals = section_name_to_data[ANZU_INPUT_VARIABLES]
    output_signals = section_name_to_data[ANZU_OUTPUT_VARIABLES]
    known_signals = input_signals + output_signals

    for asts in (section_name_to_data[ANZU_ENV_FAIRNESS],
                 section_name_to_data[ANZU_ENV_INITIAL],
                 section_name_to_data[ANZU_ENV_TRANSITIONS],
                 section_name_to_data[ANZU_SYS_FAIRNESS],
                 section_name_to_data[ANZU_SYS_INITIAL],
                 section_name_to_data[ANZU_SYS_TRANSITIONS]):
        error = check_unknown_signals_in_properties(asts, known_signals)
        if error:
            logger.error(error)
            return None

    return section_name_to_data


########################################################################
# tests

test_string = """
###############################################
# Input variable definition
###############################################
[INPUT_VARIABLES] #9
hready;
hbusreq0;
hlock0;
hbusreq1;
hlock1;
hbusreq2;
hlock2;
hburst0;
hburst1;

###############################################
# Output variable definition
###############################################
[OUTPUT_VARIABLES] #18
hmaster0;
hmaster1;
hmastlock;
start;
decide;
locked;
hgrant0;
hgrant1;
hgrant2;
busreq;
stateA1_0;
stateA1_1;
stateG2;
stateG3_0;
stateG3_1;
stateG3_2;
stateG10_1;
stateG10_2;

###############################################
# Environment specification
###############################################
[ENV_INITIAL] #9
hready=0;
hbusreq0=0;
hlock0=0;
hbusreq1=0;
hlock1=0;
hbusreq2=0;
hlock2=0;
hburst0=0;
hburst1=0;

[ENV_TRANSITIONS] #3
G( hlock0=1 -> hbusreq0=1 );
G( hlock1=1 -> hbusreq1=1 );
G( hlock2=1 -> hbusreq2=1 );

[ENV_FAIRNESS] #2
G(F(stateA1_1=0));
G(F(hready=1));

###############################################
# System specification
###############################################
[SYS_INITIAL] #18
hmaster0=0;
hmaster1=0;
hmastlock=0;
start=1;
decide=1;
locked=0;
hgrant0=1;
hgrant1=0;
hgrant2=0;
busreq=0;
stateA1_0=0;
stateA1_1=0;
stateG2=0;
stateG3_0=0;
stateG3_1=0;
stateG3_2=0;
stateG10_1=0;
stateG10_2=0;

[SYS_TRANSITIONS] #5
G((hmaster0=0) * (hmaster1=0) -> (hbusreq0=0 <-> busreq=0));
G((hmaster0=1) * (hmaster1=0) -> (hbusreq1=0 <-> busreq=0));
G((hmaster0=0) * (hmaster1=1) -> (hbusreq2=0 <-> busreq=0));
G(((stateA1_1=0) * (stateA1_0=0) * ((hmastlock=0) + (hburst0=1) + (hburst1=1))) ->
 X((stateA1_1=0) * (stateA1_0=0)));
G(((stateA1_1=0) * (stateA1_0=0) *  (hmastlock=1) * (hburst0=0) * (hburst1=0)) ->
 X((stateA1_1=1) * (stateA1_0=0)));

[SYS_FAIRNESS] #5
G(F(stateG2=0));
G(F((stateG3_0=0)  *  (stateG3_1=0)  *  (stateG3_2=0)));
G(F(((hmaster0=0) * (hmaster1=0))  +  hbusreq0=0));
G(F(((hmaster0=1) * (hmaster1=0))  +  hbusreq1=0));
G(F(((hmaster0=0) * (hmaster1=1))  +  hbusreq2=0)); """





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


