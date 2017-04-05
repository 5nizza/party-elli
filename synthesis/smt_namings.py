from typing import Iterable

from interfaces.automata import Node
from interfaces.aht_automaton import Node as AHTNode
from interfaces.expr import Signal


TYPE_MODEL_STATE = 'M'
TYPE_A_STATE = 'A'

FUNC_MODEL_TRANS = '__tau'
FUNC_REACH = '__reach'
FUNC_R = '__rk'

ARG_MODEL_STATE = '__m'
ARG_A_STATE = '__a'   # intended to be used for the whole specification (safety and liveness)


def smt_arg_name_signal(s:Signal) -> str:   # TODO: need better checks of no name collisions
    result = '%s_' % str(s).lower()
    assert result not in (ARG_A_STATE, ARG_MODEL_STATE)
    return result


def smt_unname_if_signal(arg_name:str, signals:Iterable[Signal]) -> str or Signal:
    signals = list(signals)  # we need an order
    signal_by_smt_name = dict((smt_arg_name_signal(s), s) for s in signals)

    if arg_name in signal_by_smt_name:
        assert arg_name != ARG_MODEL_STATE, arg_name  # no ambiguities!
        return signal_by_smt_name[arg_name]

    assert arg_name == ARG_MODEL_STATE, arg_name
    return ARG_MODEL_STATE


def smt_name_q(q:Node or AHTNode) -> str:
    return '{0}_{1}'.format(TYPE_A_STATE, q.name)


def smt_name_m(m:int) -> str:
    return '__m%i' % m


def smt_unname_m(str_m:str) -> int:
    return int(str_m[3:])


def smt_name_free_arg(smt_arg) -> str:
    return '?{0}'.format(smt_arg)
