import os
from parsing.helpers import Visitor
from interfaces.parser_expr import *
from parsing.par_lexer_desc import *


precedence = (
    ('right', 'QUANTIFIER'),
    ('left', 'OR'),
    ('right', 'IMPLIES','EQUIV'),
    ('left', 'AND'),
    ('left', 'TEMPORAL_BINARY'),
    ('left', 'NEG'),             # left - right should not matter..
    ('left', 'TEMPORAL_UNARY'),  # left - right should not matter..
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
p_section_name.__doc__ = 'section_name : ' + PAR_SECTIONS[0] + ' \n  | ' + '\n  | '.join(PAR_SECTIONS[1:])


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


#TODO: currently we treat all the signals with _ as parameterized?
def p_signal_name(p):
    """ signal_name : SIGNAL_NAME
    """
    p[0] = Signal(p[1])


def p_section_data_properties(p):
    """properties : property SEP
                  | properties property SEP"""
    if len(p) == 3:
        p[0] = [p[1]]
    else:
        p[0] = p[1] + [p[2]]


def p_section_data_property_bool(p):
    """property   : BOOL"""
    p[0] = Bool(p[1] == 'TRUE')


def p_section_data_property_binary_operation(p):
    """property   : signal_name EQUALS number
                  | property AND property
                  | property OR property
                  | property IMPLIES property
                  | property EQUIV property

                  | property TEMPORAL_BINARY property"""
    assert p[2] in BIN_OPS
    p[0] = BinOp(p[2], p[1], p[3])


def p_section_data_par_property(p):
    """property : par_property """
    p[0] = p[1]


class QuantifiedSignalsCreatorVisitor(Visitor):
    def __init__(self, binding_indices:list):
        self.binding_indices = binding_indices

    def visit_signal(self, signal:Signal):
        tokens = signal.name.split('_')

        base_name_tokens = [t for t in tokens if t not in self.binding_indices]
        indices_tokens = tuple(t for t in tokens if t not in base_name_tokens)

        return QuantifiedSignal('_'.join(base_name_tokens), *indices_tokens)


def _update_expr_with_quantified_signals(quantified_expr:Expr, binding_indices:list) -> Expr:
    quantified_signals_creator = QuantifiedSignalsCreatorVisitor(binding_indices)
    expr_with_quantified_signals = quantified_signals_creator.dispatch(quantified_expr)

    return expr_with_quantified_signals


def p_par_property(p):
    """par_property : QUANTIFIER binding_args property
    """
    binding_indices = p[2]
    p[0] = ForallExpr(binding_indices, _update_expr_with_quantified_signals(p[3], p[2]))


def p_binding_args(p):
    """ binding_args : LPAREN vars RPAREN
    """
    p[0] = p[2]


def p_vars_one(p):
    """ vars : var_name
    """
    p[0] = [p[1]]


def p_vars_many(p):
    """ vars : vars COMMA var_name
    """
    p[0] = p[1] + [p[3]]


def p_var_name(p):
    """ var_name : SIGNAL_NAME
    """
    p[0] = p[1]  # just a string name without type


def p_number(p):
    """ number : NUMBER
    """
    p[0] = Number(int(p[1]))


def p_section_data_property_unary(p):
    """property   : TEMPORAL_UNARY property
                  | NEG property """
    p[0] = UnaryOp(p[1], p[2])


def p_section_data_property_grouping(p):
    """property   : LPAREN property RPAREN"""
    p[0] = p[2]


def p_error(p):
    if p:
        print("Syntax error at '%s'" % p.value)
        print("lineno: %d" % p.lineno)
    else:
        print('Syntax error, no info available')
    assert 0


from third_party.ply import yacc
par_parser = yacc.yacc(debug=0, outputdir=os.path.dirname(os.path.realpath(__file__)))
