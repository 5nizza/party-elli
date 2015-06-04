from interfaces.automata import Node
from interfaces.parser_expr import Signal

TYPE_MODEL_STATE = 'M'
TYPE_S_a_STATE = 'S_a'
TYPE_S_g_STATE = 'S_g'
TYPE_L_a_STATE = 'L_a'
TYPE_L_g_STATE = 'L_g'

FUNC_MODEL_TRANS = '_tau_'
FUNC_REACH = '_reach_'
FUNC_R = '_r_'
# FUNC_S_a_TRANS = 'tauSa'
# FUNC_S_g_TRANS = 'tauSg'
# FUNC_L_a_TRANS = 'tauLa'
# FUNC_L_g_TRANS = 'tauLg'

ARG_MODEL_STATE = '_m_'
ARG_S_a_STATE = '_s_a_'
ARG_S_g_STATE = '_s_g_'
ARG_L_a_STATE = '_l_a_'
ARG_L_g_STATE = '_l_g_'


def smt_arg_name_signal(s:Signal):
    return '_%s_' % str(s).lower()


def smt_name_spec(spec_state:Node, spec_state_type:str):
    return '{0}_{1}'.format(spec_state_type, spec_state.name)


def smt_name_m(m:int):
    return '_m%i_' % m


def smt_name_free_arg(smt_arg):
    return '?{0}'.format(smt_arg)
