from interfaces.automata import Node, Label
from interfaces.expr import Signal


# TODO: remove non-used


TYPE_MODEL_STATE = 'M'
TYPE_A_STATE = 'A'
TYPE_S_STATE = 'S'

FUNC_MODEL_TRANS = '_tau_'
FUNC_REACH = '_reach_'
FUNC_R = '_r_'

ARG_MODEL_STATE = '_m_'
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
        assert arg_name != ARG_MODEL_STATE,arg_name  # no ambiguities!
        return signal_by_smt_name[arg_name]

    assert arg_name in ARG_MODEL_STATE, arg_name

    return arg_name


def smt_name_spec(spec_state:Node, spec_state_type:str):
    return '{0}_{1}'.format(spec_state_type, spec_state.name)


def smt_name_m(m:int):
    return '_m%i_' % m


def smt_unname_m(str_m):
    return int(str_m[2:-1])


def smt_name_free_arg(smt_arg):
    return '?{0}'.format(smt_arg)
