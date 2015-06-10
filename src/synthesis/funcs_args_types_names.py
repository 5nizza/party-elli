from interfaces.automata import Node, Label
from interfaces.parser_expr import Signal

TYPE_MODEL_STATE = 'M'
TYPE_S_a_STATE = 'S_a'
TYPE_S_g_STATE = 'S_g'
TYPE_L_a_STATE = 'L_a'
TYPE_L_g_STATE = 'L_g'

TYPE_A_STATE = 'A'
TYPE_S_STATE = 'S'

FUNC_MODEL_TRANS = '_tau_'
FUNC_REACH = '_reach_'
FUNC_R = '_r_'

FUNC_L_a_TRANS = 'tau_L_a'
FUNC_L_a_ACC = 'tau_L_a_acc'
FUNC_L_g_TRANS = 'tau_L_g'
FUNC_L_g_ACC = 'tau_L_g_acc'

ARG_MODEL_STATE = '_m_'
ARG_S_a_STATE = '_s_a_'
ARG_S_g_STATE = '_s_g_'
ARG_L_a_STATE = '_l_a_'
ARG_L_g_STATE = '_l_g_'
ARG_A_STATE = '_a_'   # intended to be used for the whole specification (safety and liveness)
ARG_S_STATE = '_s_'   # for the safety automaton


def smt_arg_name_signal(s:Signal):
    return '_%s_' % str(s).lower()


def smt_unname_if_signal(arg_name:str, signals):
    signals = list(signals)  # we need an order
    signal_by_smt_name = dict(zip([smt_arg_name_signal(s)
                                   for s in signals],
                                  signals))

    if arg_name in signal_by_smt_name:
        assert arg_name not in {ARG_MODEL_STATE,
                                ARG_S_a_STATE, ARG_S_g_STATE,
                                ARG_L_a_STATE, ARG_L_g_STATE}, arg_name  # not ambiguities!
        return signal_by_smt_name[arg_name]

    assert arg_name in {ARG_MODEL_STATE,
                        ARG_S_a_STATE, ARG_S_g_STATE,
                        ARG_L_a_STATE, ARG_L_g_STATE}, arg_name

    return arg_name


def smt_name_spec(spec_state:Node, spec_state_type:str):
    return '{0}_{1}'.format(spec_state_type, spec_state.name)


def smt_name_m(m:int):
    return '_m%i_' % m


def smt_unname_m(str_m):
    return int(str_m[2:-1])


def smt_name_free_arg(smt_arg):
    return '?{0}'.format(smt_arg)
