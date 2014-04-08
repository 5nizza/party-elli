import os
from helpers.python_ext import lmap
from parsing.acacia_lexer_desc import *


class Assumption:
    def __init__(self, data):
        self.data = data


class Guarantee:
    def __init__(self, data):
        self.data = data


precedence = (
    ('left','OR'),
    ('left','IMPLIES','EQUIV'),
    ('left','AND'),
    ('left', 'TEMPORAL_BINARY'),
    ('left', 'NEG'),             # left - right should not matter..
    ('left', 'TEMPORAL_UNARY'),  # left - right should not matter..
    ('nonassoc','EQUALS')
    )


def p_start(p):
    """start :  empty
             |  units """
    if p[1] is not None:
        p[0] = p[1]
    else:
        p[0] = []


def p_empty(p):
    r"""empty :"""
    pass


def p_units(p):
    """units :  unit
              | units unit"""
    if len(p) == 2:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]


#TODO: figure out why conflict arises
#def p_unit_without_header(p):
#    """unit : unit_data """
#    p[0] = ('None', p[1])


def p_unit_with_header(p):
    """unit : unit_header unit_data """
    p[0] = (p[1], p[2])


def p_unit_header(p):
    """unit_header : LBRACKET SPEC_UNIT NAME RBRACKET"""
    p[0] = p[3]


def p_unit_data(p):
    """unit_data :    empty
                    | expressions """
    if p[1] is None:
        p[0] = ([],[])
    else:
        assumptions = lmap(lambda e: e.data, filter(lambda e: isinstance(e, Assumption), p[1]))
        guarantees = lmap(lambda e: e.data, filter(lambda e: isinstance(e, Guarantee), p[1]))
        p[0] = (assumptions, guarantees)


def p_signal_name(p):
    """ signal_name : NAME
    """
    p[0] = QuantifiedSignal(p[1], 0)


def p_unit_data_expressions(p):
    """expressions : expression SEP
                   | expressions expression SEP"""
    if len(p) == 3:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]


def p_unit_data_expression_assumption(p):
    """ expression : ASSUME property
    """
    p[0] = Assumption(p[2])


def p_unit_data_expression_guarantee(p):
    """ expression : property """
    p[0] = Guarantee(p[1])


def p_unit_data_property_bool(p):
    """property   : BOOL"""
    p[0] = p[1]


def p_unit_data_property_binary_operation(p):
    """property   : signal_name EQUALS NUMBER
                  | property AND property
                  | property OR property
                  | property IMPLIES property
                  | property EQUIV property

                  | property TEMPORAL_BINARY property"""
    assert p[2] in BIN_OPS
    p[0] = BinOp(p[2], p[1], p[3])


def p_unit_data_property_unary(p):
    """property   : TEMPORAL_UNARY property
                  | NEG property """
    p[0] = UnaryOp(p[1], p[2])


def p_unit_data_property_grouping(p):
    """property   : LPAREN property RPAREN"""
    p[0] = p[2]


def p_error(p):
    if p:
        print("----> Syntax error at '%s'" % p.value)
        print("lineno: %d" % p.lineno)
    else:
        print('----> Syntax error, t is None')
    assert 0


from third_party.ply import yacc
acacia_parser = yacc.yacc(debug=0, outputdir=os.path.dirname(os.path.realpath(__file__)))