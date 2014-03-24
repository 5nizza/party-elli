from interfaces.parser_expr import *

#reserved words: syntactic sugar to help to match exactly reserved word
reserved_bools = dict((s, s) for s in ('TRUE', 'FALSE'))

tokens = [
             'ASSUME', 'SPEC_UNIT', 'NAME', 'NUMBER', 'BOOL',
             'TEMPORAL_UNARY', 'NEG', 'TEMPORAL_BINARY',
             'OR','AND','IMPLIES', 'EQUIV', 'EQUALS',
             'LPAREN','RPAREN', 'LBRACKET', 'RBRACKET',
             'SEP'
         ]

#constant to ensure consistency of the code
BIN_OPS = ('+','*','->','<->','=','U', 'W')


############################################################
#http://www.dabeaz.com/ply/ply.html#ply_nn6
# functions first, vars second
#All tokens defined by functions are added in the same order as they appear in the lexer file.
#Tokens defined by strings are added next by sorting them in order of decreasing regular expression length (longer expressions are added first).

t_OR      = r'\+'
t_AND     = r'\*'
t_IMPLIES = r'->'
t_EQUIV   = r'<->'
t_EQUALS  = r'='
t_NEG     = r'\!'

t_LPAREN  = r'\('
t_RPAREN  = r'\)'

t_LBRACKET  = r'\['
t_RBRACKET  = r'\]'

t_SEP = r';+'

t_ignore = " \t"
t_ignore_comment = r"\#.*"


def t_ASSUME(t):
    """assume"""
    return t


def t_GROUP_ORDER(t):
    """group_order.*"""
    pass


def t_SPEC_UNIT(t):
    """spec_unit"""
    return t


def t_TEMPORAL_UNARY(t):
    r"""(G|F|X)(?=[ \t\n]*\()"""  # temporal operators require parenthesis
    return t


def t_TEMPORAL_BINARY(t):
#    r"""U(?=[ \t]*\()""" #temporal operators require parenthesis
    r"""(U|W)(?=[ \t\n])"""  # temporal operators require parenthesis
    return t


def t_NAME(t):
    r"""[a-zA-Z_][a-zA-Z0-9_]*"""

    if t.value in reserved_bools:
        t.type = 'BOOL'
        t.value = Bool(t.value == 'TRUE')
        return t

    return t


def t_NUMBER(t):
    r"""\d+"""
    try:
        value = int(t.value)
        if not (0 <= value <= 1):
            raise ValueError('currently only 0, 1 are supported')
        t.value = Number(value)
    except ValueError:
        print("Integer value too large %d", t.value)
        t.value = '0'

    return t


def t_newline(t):
    r"""\n+"""
    t.lexer.lineno += t.value.count("\n")


def t_error(t):
    if t:
        print("Illegal character '%s'" % t.value[0])
        t.lexer.skip(1)
    else:
        print('Error somewhere, current token is None')
    assert 0


import third_party.ply.lex as lex

acacia_lexer = lex.lex()
