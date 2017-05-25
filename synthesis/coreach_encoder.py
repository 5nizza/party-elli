from itertools import product
from typing import Iterable, Dict, List

from helpers.logging_helper import log_entrance
from helpers.python_ext import lmap
from interfaces.LTS import LTS
from interfaces.automaton import Automaton
from interfaces.expr import Signal
from interfaces.func_description import FuncDesc
from synthesis.buchi_cobuchi_encoder import encode_run_graph_ucw
from synthesis.encoder_helper import parse_model, encode_get_model_values, encode_model_bound
from synthesis.encoder_interface import EncoderInterface
from synthesis.smt_format import call_func, assertion, declare_enum, declare_fun, bool_type, op_not, declare_const, \
    op_implies, op_and
from synthesis.smt_namings import TYPE_MODEL_STATE, ARG_MODEL_STATE, FUNC_REACH, \
    smt_name_q, smt_name_m, ARG_A_STATE, TYPE_A_STATE


class CoreachEncoder(EncoderInterface):
    def __init__(self,
                 automaton:Automaton,
                 tau_desc:FuncDesc,
                 inputs:Iterable[Signal],
                 descr_by_output:Dict[Signal,FuncDesc],
                 all_model_states:Iterable[int],
                 max_k:int,
                 model_init_state:int=0):  # the automata alphabet is inputs+outputs
        self.automaton = automaton

        self.inputs = list(inputs)              # type: List[Signal]
        self.descr_by_output = descr_by_output  # type: Dict[Signal,FuncDesc]
        self.tau_desc = tau_desc                # type: FuncDesc
        self.max_model_states = list(all_model_states)

        reach_args_sig = {ARG_A_STATE: TYPE_A_STATE,
                      ARG_MODEL_STATE: TYPE_MODEL_STATE}

        self.reach_func_desc = FuncDesc(FUNC_REACH, reach_args_sig, bool_type())

        self.model_init_state = model_init_state  # type: int
        self.last_allowed_states = None           # type: List[int]
        self.max_k = max_k
        self.forbidding_atoms = lmap(lambda k: '__forbid%i'%k, range(self.max_k))  # type: List[str]

        # TODO: ensure no live states
        # sccs = find_final_sccs(self.automaton)
        # has_liveness = any(map(lambda scc: len(scc) > 1 or not is_final_sink(next(iter(scc))),
        #                        sccs))
        # if not has_liveness:

    def encode_headers(self) -> List[str]:
        return self._encode_automata_functions() + \
               self._encode_model_functions() + \
               self._encode_counters() + \
               self._declare_forbidding_atoms() + \
               self._encode_meaning_of_forbidding_atoms()

    def _encode_model_functions(self) -> List[str]:
        return [declare_enum(TYPE_MODEL_STATE, map(smt_name_m, self.max_model_states))] + \
               [declare_fun(self.tau_desc)] + \
               [declare_fun(d) for d in self.descr_by_output.values()]

    def _encode_automata_functions(self) -> List[str]:
        return [declare_enum(TYPE_A_STATE, map(smt_name_q, self.automaton.nodes))]

    def _encode_counters(self) -> List[str]:
        return [declare_fun(self.reach_func_desc)]

    def _declare_forbidding_atoms(self) -> List[str]:
        return lmap(lambda a: declare_const(a, bool_type()),
                    self.forbidding_atoms)

    def _encode_meaning_of_forbidding_atoms(self) -> List[str]:
        res = list()
        for k, a in enumerate(self.forbidding_atoms):
            states_to_forbid = set(filter(lambda n: n.k <= k, self.automaton.nodes))
            forbid_k_meaning = op_implies(a,
                                          op_and(map(lambda q_m: op_not(call_func(self.reach_func_desc,
                                                                                  {ARG_A_STATE:smt_name_q(q_m[0]),
                                                                                   ARG_MODEL_STATE:smt_name_m(q_m[1])})),
                                                     product(states_to_forbid, self.max_model_states))))
            res.append(assertion(forbid_k_meaning))
        return res

    def encode_initialization(self) -> List[str]:
        assertions = []
        for q, m in product(self.automaton.init_nodes, [self.model_init_state]):
            vals_by_vars = {ARG_MODEL_STATE:smt_name_m(m), ARG_A_STATE:smt_name_q(q)}
            assertions.append(
                assertion(call_func(self.reach_func_desc, vals_by_vars))
            )
        return assertions

    def encode_run_graph(self, states_to_encode) -> List[str]:
        return encode_run_graph_ucw(self.reach_func_desc,
                                    None,  # it will not be used, i promise
                                    self.tau_desc,
                                    self.descr_by_output,
                                    self.inputs,
                                    self.automaton, states_to_encode)

    def encode_model_bound(self, allowed_model_states:Iterable[int]) -> List[str]:
        self.last_allowed_states = list(allowed_model_states)
        return encode_model_bound(allowed_model_states, self.tau_desc)

    def encode_assumption_forbid_k(self, k:int) -> List[str]:
        # forbid states with counter being k or lower
        return self.forbidding_atoms[0:k+1] + lmap(lambda e: op_not(e), self.forbidding_atoms[k+1:])

    def encode_get_model_values(self) -> List[str]:
        return encode_get_model_values(self.tau_desc, self.descr_by_output,
                                       self.last_allowed_states)

    @log_entrance()
    def parse_model(self, smt_get_value_lines) -> LTS:
        return parse_model(smt_get_value_lines,
                           self.tau_desc,
                           self.descr_by_output, self.inputs,
                           self.model_init_state)
