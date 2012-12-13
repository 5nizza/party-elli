# -----------------------------------------------------------------------------
# calc.py
#
# A simple calculator with variables -- all in one file.
# -----------------------------------------------------------------------------

# NOTE on using reserved words:
# we want to have constant PI
# solution1: specify token PI explicitly by r'PI' -- cex1 is : PIk is recognized as 314k -> syntax error
# solution2: as solution1 but switch the priority PI-name -- cex1 is ok, but cex2: PI is recognized as name
# solution3: use 'reserved' and check explicitly in all ambiguous points(t_NAME) t.type=reserved.get(t.value, 'NAME')
# solution3 solves cex1, cex2


reserved = {'PI': 'PI'}

tokens = [
    'NAME','NUMBER',
    'PLUS','MINUS','TIMES','DIVIDE','EQUALS',
    'LPAREN','RPAREN','PI'
    ]# + list(reserved.values())

# Tokens

#t_PI=r'PI'
t_PLUS    = r'\+'
t_MINUS   = r'-'
t_TIMES   = r'\*'
t_DIVIDE  = r'/'
t_EQUALS  = r'='
t_LPAREN  = r'\('
t_RPAREN  = r'\)'

#def t_PI(t):
#    r'PI'
#    print('t_PI')
#    return t

def t_NAME(t):
    r'[a-zA-Z][a-zA-Z0-9_]*'
    t.type = reserved.get(t.value, 'NAME')
    print('t_name: type=', t.type)
    return t

def t_NUMBER(t):
    r'\d+'
    try:
        t.value = int(t.value)
    except ValueError:
        print("Integer value too large %d", t.value)
        t.value = 0
    return t

# Ignored characters
t_ignore = " \t"

def t_newline(t):
    r'\n+'
    t.lexer.lineno += t.value.count("\n")

def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)

# Build the lexer
import helpers.ply.lex as lex
lex.lex()

# Parsing rules

precedence = (
    ('left','PLUS','MINUS'),
    ('left','TIMES','DIVIDE'),
    ('right','UMINUS'),
    )

# dictionary of names
names = { }

def p_statement_assign(t):
    'statement : NAME EQUALS expression'
    names[t[1]] = t[3]

def p_statement_expr(t):
    'statement : expression'
    print(t[1])

def p_expression_binop(t):
    '''expression : expression PLUS expression
                  | expression MINUS expression
                  | expression TIMES expression
                  | expression DIVIDE expression'''
    if t[2] == '+'  : t[0] = t[1] + t[3]
    elif t[2] == '-': t[0] = t[1] - t[3]
    elif t[2] == '*': t[0] = t[1] * t[3]
    elif t[2] == '/': t[0] = t[1] / t[3]

def p_expression_uminus(t):
    'expression : MINUS expression %prec UMINUS'
    t[0] = -t[2]

def p_expression_group(t):
    'expression : LPAREN expression RPAREN'
    t[0] = t[2]

def p_expression_number(t):
    'expression : NUMBER'
    t[0] = t[1]

def p_expression_name(t):
    'expression : NAME'
    try:
        t[0] = names[t[1]]
    except LookupError:
        print("Undefined name '%s'" % t[1])
        t[0] = 0

def p_expression_ogo(p):
    '''expression : PI'''
    p[0] = 314

def p_error(t):
    print("Syntax error at '%s'" % t.value)

import helpers.ply.yacc as yacc
yacc.yacc()

while 1:
    try:
        s = input('calc > ')   # Use raw_input on Python 2
    except EOFError:
        break
    yacc.parse(s)