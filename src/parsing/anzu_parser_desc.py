import os
from parsing.anzu_lexer_desc import *

precedence = (
    ('left','OR'),
    ('left','IMPLIES','EQUIV'),
    ('left','AND'),
    ('left', 'TEMPORAL_BINARY'),
    ('left', 'NEG'),            #left - right should not matter..
    ('left', 'TEMPORAL_UNARY'), #left - right should not matter..
    ('nonassoc','EQUALS')
    )


def p_start(p):
    """start :  empty
             |  sections """
    if p[1] is not None:
        p[0] = p[1]
    else:
        p[0] = []


def p_empty(p):
    r"""empty :"""
    pass


def p_sections(p):
    """sections : section
                | sections section"""
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]


def p_section(p):
    """section : section_header section_data """
    p[0] = (p[1], p[2])


def p_section_header(p):
    """section_header : LBRACKET section_name RBRACKET"""
    p[0] = p[2]


def p_section_name(p):
    p[0] = p[1]
p_section_name.__doc__ = 'section_name : ' + ANZU_SECTIONS[0] + ' \n  | ' + '\n  | '.join(ANZU_SECTIONS[1:])


def p_section_data(p):
    """section_data : empty
                    | signals
                    | properties """
    if p[1] is None:
        p[0] = []
    else:
        p[0] = p[1]


def p_section_data_signals_definitions(p):
    """signals : signal_name SEP
               | signals signal_name SEP """
    if len(p) == 4:
        p[0] = p[1] + [p[2]]
    else:
        p[0] = [p[1]]


def p_signal_name(p):
    """ signal_name : SIGNAL_NAME
    """
    p[0] = QuantifiedSignal(p[1], 0)


def p_section_data_properties(p):
    """properties : property SEP
                  | properties property SEP"""
    if len(p) == 3:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]


def p_section_data_property_bool(p):
    """property   : BOOL"""
    p[0] = p[1]


def p_section_data_property_binary_operation(p):
    """property   : signal_name EQUALS NUMBER
                  | property AND property
                  | property OR property
                  | property IMPLIES property
                  | property EQUIV property

                  | property TEMPORAL_BINARY property"""
    assert p[2] in BIN_OPS
    p[0] = BinOp(p[2], p[1], p[3])


def p_section_data_property_unary(p):
    """property   : TEMPORAL_UNARY property
                  | NEG property """
    p[0] = UnaryOp(p[1], p[2])


def p_section_data_property_grouping(p):
    """property   : LPAREN property RPAREN"""
    p[0] = p[2]


def p_error(p):
    if p:
        print("----> Syntax error at '%s'" % p.value)
    else:
        print('----> Syntax error, t is None')
    assert 0


from third_party.ply import yacc
anzu_parser = yacc.yacc(debug=0, outputdir=os.path.dirname(os.path.realpath(__file__)))