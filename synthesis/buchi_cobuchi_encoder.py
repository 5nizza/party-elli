from typing import List, Dict, Iterable, Set, Tuple

from automata.automata_classifier import is_final_sink
from interfaces.automaton import Node, Label, Automaton
from interfaces.expr import Signal
from interfaces.func_description import FuncDesc
from synthesis.encoder_helper import build_tau_args_dict, get_free_input_args, smt_out
from synthesis.final_sccs_finder import build_state_to_final_scc
from synthesis.smt_format import comment, call_func, op_and, false, assertion, forall_bool, op_implies, op_ge, op_gt, \
    op_or, true, exists_bool
from synthesis.smt_namings import smt_name_q, ARG_MODEL_STATE, ARG_A_STATE, smt_name_m


def encode_run_graph_nbw(reach_func_desc:FuncDesc,
                         rank_func_desc:FuncDesc,
                         tau_desc:FuncDesc,
                         desc_by_output:Dict[Signal, FuncDesc],
                         inputs:Iterable[Signal],
                         automaton:Automaton,
                         states_to_encode:Iterable[int]) -> List[str]:
    inputs = list(inputs)
    res = []
    for q in automaton.nodes:
        res += [comment('encoding state ' + q.name)]
        for m in states_to_encode:
            res += _encode_transitions_nbw(m, q, reach_func_desc, rank_func_desc,tau_desc, desc_by_output, inputs)
    return res


def _encode_transitions_nbw(m:int, q:Node,
                            reach_func_desc:FuncDesc,
                            rank_func_desc:FuncDesc,
                            tau_desc:FuncDesc,
                            desc_by_output:Dict[Signal, FuncDesc],
                            inputs:List[Signal]) -> List[str]:
    # syntax sugar
    def smt_r(smt_m:str, smt_q:str):
        return call_func(rank_func_desc,
                         {ARG_MODEL_STATE:smt_m, ARG_A_STATE:smt_q})

    def smt_reach(smt_m:str, smt_q:str):
        return call_func(reach_func_desc,
                         {ARG_MODEL_STATE:smt_m, ARG_A_STATE:smt_q})

    def smt_tau(smt_m:str, i_o:Label):
        tau_args = build_tau_args_dict(inputs, smt_m, i_o)
        return call_func(tau_desc, tau_args)

    # reach(q,t) ->
    #     OR{(q,io,q') \in \delta(q)}:
    #         sys_out=o & reach(q',t') & rank(q,t,q',t')

    s_m = smt_name_m(m)
    s_q = smt_name_q(q)
    s_pre = smt_reach(s_m, s_q)

    s_disjuncts = list()   # type: List[str]
    for lbl, qn_flag_pairs in q.transitions.items():  # type: Tuple[Label, Set[Tuple[Node, bool]]]
        s_m_next = smt_tau(s_m, lbl)
        s_out = smt_out(s_m, lbl, inputs, desc_by_output)
        free_inputs = get_free_input_args(lbl, inputs)
        for (q_next, is_acc) in qn_flag_pairs:
            if is_final_sink(q_next):
                s_disj = exists_bool(free_inputs, s_out)
                s_disjuncts.append(s_disj)
                break
            s_q_next = smt_name_q(q_next)
            s_reach = smt_reach(s_m_next, s_q_next)
            if is_acc:
                s_rank = true()  # TODO: SCCs
            else:
                s_rank = op_gt(smt_r(s_m, s_q), smt_r(s_m_next, s_q_next))

            s_disj = exists_bool(free_inputs, op_and([s_out, s_reach, s_rank]))
            s_disjuncts.append(s_disj)

    s_assertion = op_implies(s_pre, op_or(s_disjuncts))
    return [assertion(s_assertion)]


def encode_run_graph_ucw(reach_func_desc:FuncDesc,
                         rank_func_desc:FuncDesc,
                         tau_desc:FuncDesc,
                         desc_by_output:Dict[Signal, FuncDesc],
                         inputs:Iterable[Signal],
                         automaton:Automaton,
                         states_to_encode:Iterable[int]) -> List[str]:
    inputs = list(inputs)
    state_to_rejecting_scc = build_state_to_final_scc(automaton)

    res = []
    for q in automaton.nodes:
        res.append(comment('encoding spec state ' + smt_name_q(q)))
        for m in states_to_encode:
            for label in q.transitions:
                res += _encode_transitions_ucw(reach_func_desc,
                                               rank_func_desc,
                                               tau_desc,
                                               desc_by_output,
                                               inputs,
                                               q, m, label, state_to_rejecting_scc)
    return res


def _encode_transitions_ucw(reach_func_desc:FuncDesc,
                            rank_func_desc:FuncDesc,
                            tau_desc:FuncDesc,
                            desc_by_output:Dict[Signal, FuncDesc],
                            inputs:List[Signal],
                            q:Node,
                            m:int,
                            i_o:Label,
                            state_to_final_scc:dict=None) -> List[str]:
    # syntax sugar
    def smt_r(smt_m:str, smt_q:str):
        return call_func(rank_func_desc,
                         {ARG_MODEL_STATE:smt_m, ARG_A_STATE:smt_q})

    def smt_reach(smt_m:str, smt_q:str):
        return call_func(reach_func_desc,
                         {ARG_MODEL_STATE:smt_m, ARG_A_STATE:smt_q})

    def smt_tau(smt_m:str, i_o:Label):
        tau_args = build_tau_args_dict(inputs, smt_m, i_o)
        return call_func(tau_desc, tau_args)
    #

    smt_m, smt_q = smt_name_m(m), smt_name_q(q)
    smt_m_next = smt_tau(smt_m, i_o)

    smt_pre = op_and([smt_reach(smt_m, smt_q),
                      smt_out(smt_m, i_o, inputs, desc_by_output)])

    smt_post_conjuncts = []
    for q_next, is_fin in q.transitions[i_o]:
        if is_final_sink(q_next):
            smt_post_conjuncts = [false()]
            break

        smt_q_next = smt_name_q(q_next)

        smt_post_conjuncts.append(smt_reach(smt_m_next, smt_q_next))

        greater_op = _get_greater_op_ucw(q, is_fin, q_next, state_to_final_scc)
        if greater_op is not None:
            smt_post_conjuncts.append(greater_op(smt_r(smt_m, smt_q),
                                                 smt_r(smt_m_next, smt_q_next)))

    smt_post = op_and(smt_post_conjuncts)
    pre_implies_post = op_implies(smt_pre, smt_post)
    free_input_args = get_free_input_args(i_o, inputs)

    return [assertion(forall_bool(free_input_args, pre_implies_post))]


def _get_greater_op_ucw(q, is_rejecting,
                        q_next,
                        state_to_rejecting_scc):
    crt_rejecting_scc = state_to_rejecting_scc.get(q, None)
    next_rejecting_scc = state_to_rejecting_scc.get(q_next, None)

    if crt_rejecting_scc is not next_rejecting_scc:
        return None
    if crt_rejecting_scc is None:
        return None
    if next_rejecting_scc is None:
        return None

    return (op_ge, op_gt)[is_rejecting]
