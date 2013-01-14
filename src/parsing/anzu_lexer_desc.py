from interfaces.parser_expr import *

ANZU_SECTIONS = 'INPUT_VARIABLES OUTPUT_VARIABLES ENV_INITIAL SYS_INITIAL ENV_TRANSITIONS SYS_TRANSITIONS ENV_FAIRNESS SYS_FAIRNESS'.split()
ANZU_INPUT_VARIABLES, ANZU_OUTPUT_VARIABLES,\
ANZU_ENV_INITIAL, ANZU_SYS_INITIAL,\
ANZU_ENV_TRANSITIONS, ANZU_SYS_TRANSITIONS,\
ANZU_ENV_FAIRNESS, ANZU_SYS_FAIRNESS = ANZU_SECTIONS

#reserved words: syntactic sugar to help to match exactly reserved word
reserved_section_names = dict((s, s) for s in ANZU_SECTIONS)
reserved_bools =  dict((s, s) for s in ('TRUE', 'FALSE'))

tokens = [
             'SIGNAL_NAME', 'NUMBER', 'BOOL',
             'TEMPORAL_UNARY', 'NEG', 'TEMPORAL_BINARY',
             'OR','AND','IMPLIES', 'EQUIV', 'EQUALS',
             'LPAREN','RPAREN', 'LBRACKET', 'RBRACKET',
             'SEP'
         ] + list(reserved_section_names.values())
#             list(reserved_bools.values()) #i use BOOL currently

#constant to ensure consistency of the code
BIN_OPS = ('+','*','->','<->','=','U')


############################################################
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


def t_TEMPORAL_UNARY(t):
    r"""(G|F|X)(?=[ \t]*\()""" #temporal operators require parenthesis
    return t


def t_TEMPORAL_BINARY(t):
    r"""U(?=[ \t]*\()""" #temporal operators require parenthesis
    return t


def t_SIGNAL_NAME(t):
    r"""[a-zA-Z_][a-zA-Z0-9_]*"""

    # Check for reserved words
    if t.value in reserved_section_names:
        t.type = reserved_section_names[t.value]
        return t
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



import helpers.ply.lex as lex

anzu_lexer = lex.lex()
