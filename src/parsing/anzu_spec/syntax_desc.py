from parsing.anzu_spec.interface import *


#TODO: cannot parse original GenBuf specification due to the conflict(?) in the word FULL
#TODO: add negation sign (used in arbiter examples)
tokens = (
    'SIGNAL_NAME', 'SECTION_NAME', 'NUMBER', 'BOOL',
    'TEMPORAL_UNARY', 'TEMPORAL_BINARY',
    'OR','AND','IMPLIES', 'EQUIV', 'EQUALS',
    'LPAREN','RPAREN', 'LBRACKET', 'RBRACKET',
    'SEPARATOR'
    )

#constant to ensure consistency of the code
BIN_OPS = ('+','*','->','<->','=','U')

t_OR      = r'\+'
t_AND     = r'\*'
t_IMPLIES = r'->'
t_EQUIV   = r'<->'
t_EQUALS  = r'='

t_LPAREN  = r'\('
t_RPAREN  = r'\)'

t_LBRACKET  = r'\['
t_RBRACKET  = r'\]'

t_SEPARATOR = r';+'

t_ignore = " \t"
t_ignore_comment = r"\#.*"

SECTIONS = 'INPUT_VARIABLES OUTPUT_VARIABLES ENV_INITIAL SYS_INITIAL ENV_TRANSITIONS SYS_TRANSITIONS ENV_FAIRNESS SYS_FAIRNESS'.split()
S_INPUT_VARIABLES, S_OUTPUT_VARIABLES, \
S_ENV_INITIAL, S_SYS_INITIAL, \
S_ENV_TRANSITIONS, S_SYS_TRANSITIONS, \
S_ENV_FAIRNESS, S_SYS_FAIRNESS = SECTIONS

def t_SECTION_NAME(t):
    return t
t_SECTION_NAME.__doc__ = '|'.join(SECTIONS)

def t_BOOL(t):
    r"""TRUE|FALSE""" #TODO: capitalize
    try:
        if not (t.value == 'FALSE' or t.value == 'TRUE'):
            raise ValueError()
        t.value = Bool(t.value == 'TRUE')
        return t
    except ValueError:
        print("Unknown boolean valueInteger value too large %d", t.value)

def t_TEMPORAL_UNARY(t):
    r"""G|F|X"""
    return t

def t_TEMPORAL_BINARY(t):
    r"""U"""
    return t

def t_SIGNAL_NAME(t):
    r"""[a-zA-Z_][a-zA-Z0-9_]*"""
    #    print('t_SIGNAL_NAME', t)
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

# Build the lexer
import helpers.ply.yacc as yacc
import helpers.ply.lex as lex

lex.lex()


########################################################################


precedence = (
    ('left','OR'),
    ('left','IMPLIES','EQUIV'),
    ('left','AND'),
    ('left', 'TEMPORAL_BINARY'),
    ('right', 'TEMPORAL_UNARY'), #TODO: right or left or ??
    ('right','EQUALS') #TODO: right or left or ??
    )

def p_start(p):
    """start :  empty
             |  section
             |  start section"""
#    print('p_start')
    if len(p) == 3:
        p[0] = p[1] + [p[2]]
    else:
        p[0] = [p[1]]

def p_empty(p):
    r"""empty :"""
    pass

def p_section(p):
    """section : section_header section_data"""
    p[0] = (p[1], p[2])

def p_section_header(p):
    """section_header : LBRACKET SECTION_NAME RBRACKET"""
#    print('p_section_header')
    p[0] = p[2]

def p_section_data_signal_definitions(p):
    """section_data : SIGNAL_NAME SEPARATOR
                    | SIGNAL_NAME SEPARATOR section_data"""
#    print('p_section_data_signal_definitions')
    if len(p) == 3:
        p[0] = [p[1]]
    else:
        p[0] = p[3] + [p[1]]

def p_section_data_properties(p): #TODO: separate cases of signal definitions and properties
    """section_data : property SEPARATOR
                    | property SEPARATOR section_data"""
#    print('p_section_data_properties')
    if len(p) == 3:
        p[0] = [p[1]]
    else:
        p[0] = p[3] + [p[1]]

def get_whole_right_line(p):
    all_except_zero = [p for i, p in enumerate(p) if i != 0]
    return ' '.join(all_except_zero)

def p_section_data_property_bool(p):
    """property   : BOOL"""
    p[0] = p[1]

def p_section_data_property_binary_operation(p):
    """property   : SIGNAL_NAME EQUALS NUMBER
                  | property AND property
                  | property OR property
                  | property IMPLIES property
                  | property EQUIV property

                  | property TEMPORAL_BINARY property"""
    assert p[2] in BIN_OPS
    p[0] = BinOp(p[2], p[1], p[3])

def p_section_data_property_unary(p):
    """property   : TEMPORAL_UNARY property"""
    p[0] = UnaryOp(p[1], p[2])

def p_section_data_property_grouping(p):
    """property   : LPAREN property RPAREN"""
    p[0] = p[2]

def p_error(p):
    if p:
        print("Syntax error at '%s'" % p.value)
    else:
        print('Syntax error, t is None')
    assert 0


yacc.yacc()