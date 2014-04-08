from helpers.python_ext import add_dicts

PAR_INPUT_VARIABLES = 'INPUT_VARIABLES'
PAR_OUTPUT_VARIABLES = 'OUTPUT_VARIABLES'
PAR_ASSUMPTIONS = 'ASSUMPTIONS'
PAR_GUARANTEES = 'GUARANTEES'

PAR_SECTIONS = (PAR_INPUT_VARIABLES, PAR_OUTPUT_VARIABLES, PAR_ASSUMPTIONS, PAR_GUARANTEES)

#reserved words: syntactic sugar to help to match exactly reserved word
reserved_section_names = dict((s, s) for s in PAR_SECTIONS)
reserved_bools = dict((s, s) for s in ('TRUE', 'FALSE'))
reserved_quantifiers = {'Forall': 'QUANTIFIER'}

reserved_all = add_dicts(reserved_bools, reserved_quantifiers, reserved_section_names)

#states = (
#    ('quantified', 'inclusive'),
#)

tokens = ['COMMA', 'SIGNAL_NAME', 'NUMBER', 'BOOL',
          'TEMPORAL_UNARY', 'NEG', 'TEMPORAL_BINARY',
          'OR', 'AND', 'IMPLIES', 'EQUIV', 'EQUALS',
          'LPAREN', 'RPAREN', 'LBRACKET', 'RBRACKET',
          'SEP'
         ] +\
         list(reserved_section_names.values()) + \
         list(set(reserved_quantifiers.values()))
#             list(reserved_bools.values()) #i use BOOL currently

#constant to ensure consistency of the code
BIN_OPS = ('+', '*', '->', '<->', '=', 'U', 'W')  # TODO: what about Forall?

############################################################
t_OR = r'\+'
t_AND = r'\*'
t_IMPLIES = r'->'
t_EQUIV = r'<->'
t_EQUALS = r'='
t_NEG = r'\!'

t_LPAREN = r'\('
t_RPAREN = r'\)'

t_LBRACKET = r'\['
t_RBRACKET = r'\]'

t_COMMA = r','

t_ignore = " \t"
t_ignore_comment = r"\#.*"


def t_SEP(t):
    r""";+"""
    t.lexer.begin('INITIAL')  # end of quantified state
    return t


def t_TEMPORAL_UNARY(t):
    r"""(G|F|X)(?=[ \t\n]*\()"""  # temporal operators require parenthesis
    return t


def t_TEMPORAL_BINARY(t):
    # r"""U(?=[ \t\n]*\()"""  # temporal operators require parenthesis
    r"""(U|W)(?=[ \t\n])"""  # temporal operators require parenthesis
    return t


def t_SIGNAL_NAME(t):
    r"""[a-zA-Z_][a-zA-Z0-9_]*"""
    # Check for reserved words
    t.type = reserved_all.get(t.value, t.type)

    return t


def t_NUMBER(t):
    r"""\d+"""
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

par_lexer = lex.lex()
