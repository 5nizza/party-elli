from parsing.interface import *

tokens = (
    'QUANTIFIERS',
    'SIGNAL_NAME', 'SECTION_NAME', 'NUMBER', 'BOOL',
    'TEMPORAL_UNARY', 'NEG', 'TEMPORAL_BINARY',
    'OR','AND','IMPLIES', 'EQUIV', 'EQUALS',
    'LPAREN','RPAREN', 'LBRACKET', 'RBRACKET',
    'SEP'
    )

#constant to ensure consistency of the code
BIN_OPS = ('+','*','->','<->','=','U')

t_QUANTIFIERS = r'(Forall)|(Exists)'
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


SECTIONS = 'INPUT_VARIABLES OUTPUT_VARIABLES ENV_INITIAL SYS_INITIAL ENV_TRANSITIONS SYS_TRANSITIONS ENV_FAIRNESS SYS_FAIRNESS'.split()
S_INPUT_VARIABLES, S_OUTPUT_VARIABLES,\
S_ENV_INITIAL, S_SYS_INITIAL,\
S_ENV_TRANSITIONS, S_SYS_TRANSITIONS,\
S_ENV_FAIRNESS, S_SYS_FAIRNESS = SECTIONS

def t_SECTION_NAME(t):
    return t
t_SECTION_NAME.__doc__ = '|'.join(SECTIONS)

def t_BOOL(t):
    r"""TRUE|FALSE"""
    try:
        if not (t.value == 'FALSE' or t.value == 'TRUE'):
            raise ValueError()
        t.value = Bool(t.value == 'TRUE')
        return t
    except ValueError:
        print("Unknown boolean valueInteger value too large %d", t.value)

def t_TEMPORAL_UNARY(t):
    r"""(G|F|X)(?=[ \t]*\()""" #temporal operators require parenthesis
    return t

def t_TEMPORAL_BINARY(t):
    r"""U(?=[ \t]*\()""" #temporal operators require parenthesis
    return t

def t_SIGNAL_NAME(t):
    r"""[a-zA-Z_][a-zA-Z0-9_]*"""
    t.value = Signal(t.value)
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
