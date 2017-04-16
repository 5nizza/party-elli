from itertools import product

from typing import Iterable, Dict, List

from helpers.automata_classifier import is_absorbing
from helpers.logging_helper import log_entrance
from interfaces.LTS import LTS
from interfaces.automata import Label, Automaton, Node
from interfaces.expr import Signal
from interfaces.func_description import FuncDesc
from synthesis.encoder_helper import parse_model, encode_get_model_values, encode_model_bound, build_tau_args_dict, \
    smt_out, _get_free_input_args
from synthesis.encoder_interface import EncoderInterface
from synthesis.final_sccs_finder import build_state_to_final_scc
from synthesis.smt_format import op_and, call_func, op_implies, forall_bool, assertion, comment, declare_enum, \
    declare_fun, op_ge, op_gt, false, bool_type, real_type
from synthesis.smt_namings import TYPE_MODEL_STATE, ARG_MODEL_STATE, FUNC_REACH, FUNC_R, \
    smt_name_q, smt_name_m, ARG_A_STATE, TYPE_A_STATE


class CoBuchiEncoder(EncoderInterface):
    def __init__(self,
                 automaton:Automaton,
                 tau_desc:FuncDesc,
                 inputs:Iterable[Signal],
                 descr_by_output:Dict[Signal,FuncDesc],
                 model_init_state:int=0):  # the automata alphabet is inputs+outputs
        self.automaton = automaton

        self.inputs = inputs                    # type: Iterable[Signal]
        self.descr_by_output = descr_by_output  # type: Dict[Signal,FuncDesc]
        self.tau_desc = tau_desc                # type: FuncDesc

        reach_args_sig = {ARG_A_STATE: TYPE_A_STATE,
                      ARG_MODEL_STATE: TYPE_MODEL_STATE}

        rank_args = reach_args_sig

        self.reach_func_desc = FuncDesc(FUNC_REACH, reach_args_sig, bool_type())
        self.rank_func_desc = FuncDesc(FUNC_R, rank_args, real_type())

        self.model_init_state = model_init_state  # type: int
        self.last_allowed_states = None           # type: List[int]

    def encode_headers(self, model_states:Iterable[int]) -> List[str]:
        return self._encode_automata_functions() + \
               self._encode_model_functions(model_states) + \
               self._encode_counters()

    def _encode_model_functions(self, model_states:Iterable[int]) -> List[str]:
        return [declare_enum(TYPE_MODEL_STATE, map(smt_name_m, model_states))] + \
               [declare_fun(self.tau_desc)] + \
               [declare_fun(d) for d in self.descr_by_output.values()]

    def _encode_automata_functions(self) -> List[str]:
        return [declare_enum(TYPE_A_STATE, map(smt_name_q, self.automaton.nodes))]

    def _encode_counters(self) -> List[str]:
        return [declare_fun(self.reach_func_desc),
                declare_fun(self.rank_func_desc)]

    def encode_initialization(self) -> List[str]:
        assertions = []
        for q, m in product(self.automaton.init_nodes, [self.model_init_state]):
            vals_by_vars = {ARG_MODEL_STATE:smt_name_m(m), ARG_A_STATE:smt_name_q(q)}
            assertions.append(
                assertion(call_func(self.reach_func_desc, vals_by_vars))
            )
        return assertions

    def encode_run_graph(self, states_to_encode) -> List[str]:
        state_to_rejecting_scc = build_state_to_final_scc(self.automaton)

        res = []
        for q in self.automaton.nodes:
            for m in states_to_encode:
                for label in q.transitions:
                    res.extend(self._encode_transitions(q, m, label, state_to_rejecting_scc))
            res.append(comment('encoded spec state ' + smt_name_q(q)))
        return res

    def _get_greater_op(self, q, is_rejecting,
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

    def _encode_transitions(self,
                            q:Node,
                            m:int,
                            i_o:Label,
                            state_to_final_scc:dict=None) -> List[str]:
        # syntax sugar
        def smt_r(smt_m:str, smt_q:str):
            return call_func(self.rank_func_desc,
                             {ARG_MODEL_STATE:smt_m, ARG_A_STATE:smt_q})

        def smt_reach(smt_m:str, smt_q:str):
            return call_func(self.reach_func_desc,
                             {ARG_MODEL_STATE:smt_m, ARG_A_STATE:smt_q})

        def smt_tau(smt_m:str, i_o:Label):
            tau_args = build_tau_args_dict(self.inputs, smt_m, i_o)
            return call_func(self.tau_desc, tau_args)
        #

        smt_m, smt_q = smt_name_m(m), smt_name_q(q)
        smt_m_next = smt_tau(smt_m, i_o)

        smt_pre = op_and([smt_reach(smt_m, smt_q),
                          smt_out(smt_m, i_o, self.inputs, self.descr_by_output)])

        smt_post_conjuncts = []
        for q_next, is_fin in q.transitions[i_o]:
            if is_absorbing(q_next):
                smt_post_conjuncts = [false()]
                break

            smt_q_next = smt_name_q(q_next)

            smt_post_conjuncts.append(smt_reach(smt_m_next, smt_q_next))

            greater_op = self._get_greater_op(q, is_fin, q_next, state_to_final_scc)
            if greater_op is not None:
                smt_post_conjuncts.append(greater_op(smt_r(smt_m_next, smt_q_next),
                                                     smt_r(smt_m, smt_q)))

        smt_post = op_and(smt_post_conjuncts)
        pre_implies_post = op_implies(smt_pre, smt_post)
        free_input_args = _get_free_input_args(i_o, self.inputs)

        return [assertion(forall_bool(free_input_args, pre_implies_post))]

    def encode_model_bound(self, allowed_model_states:Iterable[int]) -> List[str]:
        self.last_allowed_states = list(allowed_model_states)
        return encode_model_bound(allowed_model_states, self.tau_desc)

    def encode_get_model_values(self) -> List[str]:
        return encode_get_model_values(self.tau_desc, self.descr_by_output,
                                       self.last_allowed_states)

    @log_entrance()
    def parse_model(self, smt_get_value_lines) -> LTS:
        return parse_model(smt_get_value_lines,
                           self.tau_desc,
                           self.descr_by_output, self.inputs,
                           self.model_init_state)
