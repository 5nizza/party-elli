from itertools import chain
from typing import Iterable, Dict, List, Set

from helpers.python_ext import lmap
from interfaces.LTS import LTS
from interfaces.automaton import Automaton, Label
from interfaces.expr import BinOp as Prop, Bool
from interfaces.expr import Signal, Expr, BinOp, UnaryOp, Number
from interfaces.func_description import FuncDesc
from parsing.visitor import Visitor
from synthesis.buchi_cobuchi_encoder import encode_run_graph_ucw, encode_run_graph_nbw
from synthesis.encoder_helper import parse_model, encode_model_bound, encode_get_model_values, smt_out
from synthesis.encoder_interface import EncoderInterface
from synthesis.smt_format import real_type, bool_type, declare_enum, declare_fun, call_func, op_and, op_or, assertion, \
    op_not, define_fun
from synthesis.smt_namings import ARG_A_STATE, TYPE_A_STATE, ARG_MODEL_STATE, TYPE_MODEL_STATE, FUNC_REACH, FUNC_R, \
    smt_name_q, smt_name_m


class CTLEncoderDirect(EncoderInterface):
    def __init__(self,
                 top_formula:Expr,
                 atm_by_p:Dict[Prop, Automaton],
                 UCWs:Iterable[Automaton],
                 tau_desc:FuncDesc,
                 inputs:Iterable[Signal],
                 desc_by_output:Dict[Signal, FuncDesc],
                 model_init_state:int=0):

        self.top_formula = top_formula    # type:Expr
        self.atm_by_sig = dict(map(lambda p_atm: (p_atm[0].arg1, p_atm[1]), atm_by_p.items()))  # type: Dict[Signal, Automaton]
        self.UCWs = set(UCWs)             # type: Set[Automaton]

        assert len(set(map(lambda n: n.name,
                           chain(*lmap(lambda a: a.nodes, chain(atm_by_p.values(),
                                                                self.atm_by_sig.values())))))) \
               == \
               len(set(chain(*lmap(lambda a: a.nodes, chain(atm_by_p.values(),
                                                            self.atm_by_sig.values()))))), \
            'node names are not unique'

        self.inputs = set(inputs)               # type: Set[Signal]
        self.tau_desc = tau_desc                # type: FuncDesc
        self.desc_by_outSig = desc_by_output    # type: Dict[Signal,FuncDesc]
        # we create fake outputs for A/E propositions;
        # they are defined via reach in `encode_headers`:
        #   ( define-fun _prop ((m M)) Bool (__reach q0_prop m) )
        self.desc_by_pSig = dict(map(lambda sig: (sig, FuncDesc(sig.name, {ARG_MODEL_STATE:TYPE_MODEL_STATE}, 'Bool')),
                                     self.atm_by_sig))
        self.desc_by_sig = dict(chain(self.desc_by_pSig.items(), self.desc_by_outSig.items()))

        assert set(map(lambda out_func: out_func.name, self.desc_by_outSig.values()))\
            .isdisjoint(set(map(lambda prop_func:prop_func.name, self.desc_by_pSig.values()))),\
            "output and prop func names should not collide"

        self.model_init_state = model_init_state  # type: int
        self.last_allowed_states = None           # type: List[int]

        reach_args = {ARG_A_STATE: TYPE_A_STATE,
                      ARG_MODEL_STATE: TYPE_MODEL_STATE}

        r_args = reach_args

        self.reach_func_desc = FuncDesc(FUNC_REACH, reach_args, bool_type())
        self.rank_func_desc = FuncDesc(FUNC_R, r_args, real_type())

    def encode_headers(self, all_model_states:Iterable[int]) -> List[str]:
        return self._encode_automata_functions() + \
               self._encode_model_functions(all_model_states) + \
               self._encode_counters() + \
               self._encode_prop_outputs()

    def _encode_automata_functions(self) -> List[str]:
        atm_states = chain(*lmap(lambda a: a.nodes, self.atm_by_sig.values()))
        return [declare_enum(TYPE_A_STATE,
                             map(smt_name_q, atm_states))]

    def _encode_model_functions(self, model_states:Iterable[int]) -> List[str]:
        return [declare_enum(TYPE_MODEL_STATE, map(smt_name_m, model_states))] + \
               [declare_fun(self.tau_desc)] + \
               [declare_fun(d) for d in self.desc_by_outSig.values()]

    def _encode_prop_outputs(self) -> List[str]:
        res = []
        for pSig, func in self.desc_by_pSig.items():
            body = call_func(self.reach_func_desc, {ARG_MODEL_STATE:ARG_MODEL_STATE,
                                                    ARG_A_STATE:smt_name_q(next(iter(self.atm_by_sig[pSig].init_nodes)))})
            res += [define_fun(func, body)]
        return res

    def _encode_counters(self) -> List[str]:
        return [declare_fun(self.reach_func_desc),
                declare_fun(self.rank_func_desc)]

    def encode_initialization(self) -> List[str]:
        # Recall that the running example is:
        #   AGEF(~g) & EFG(g) & ~g
        # where after atomizing we have:
        #   p2 & p1 & ~g
        class TopExprWalker(Visitor):
            def visit_unary_op(self, unary_op:UnaryOp):
                assert unary_op.name == '!', unary_op
                return op_not(self.dispatch(unary_op.arg))

            def visit_binary_op(me, binary_op:BinOp):
                assert binary_op.name in '=*+', binary_op
                if binary_op.name == '=':
                    assert binary_op.arg2 == Number(1), binary_op
                    return call_func(self.desc_by_sig[binary_op.arg1],
                                     {ARG_MODEL_STATE:smt_name_m(self.model_init_state)})

                else:
                    op = (op_and, op_or)[binary_op.name == '+']
                    smt1 = me.dispatch(binary_op.arg1)
                    smt2 = me.dispatch(binary_op.arg2)
                    return op([smt1, smt2])

        return [assertion(TopExprWalker().dispatch(self.top_formula))]

    def encode_run_graph(self, new_states:Iterable[int]) -> List[str]:
        # The running example is (in positive normal form!):
        #   AGEF(~g) & EFG(g) & ~g
        # after atomizing it becomes:
        #   p2 & p1 & ~g
        # where:
        # p2 = AG(p0)
        # p1 = EFG(g)
        # p0 = EF(~g)
        # Automata are:
        # p2: UCW for G(p0)
        #     init: p0 -> init
        #          ~p0 -> rej_sink
        #
        # p0: NBW for F(~g):
        #     init: g -> init,
        #          ~g -> acc_sink
        #
        # p1: NBW for FG(g):
        #     init: true -> init
        #              g -> mid_acc
        #     mid_acc: g -> mid_acc

        # We already encoded the top-level formula in `encode_initialization`.
        # Here we encode the propositions only.
        # We encode all the propositions:
        # for each proposition:
        # 1. if the proposition is for A(phi): encode using CoBuchi constraint
        # 2. if the proposition is for E(phi):    ... using Buchi

        # running example: atm_by_sig has signals {p0,p1,p2}
        all_constraints = list()  # type: List[str]
        for sig, atm in self.atm_by_sig.items():
            encoder_func = (encode_run_graph_nbw, encode_run_graph_ucw)[atm in self.UCWs]
            all_constraints += encoder_func(self.reach_func_desc,
                                            self.rank_func_desc,
                                            self.tau_desc,
                                            self.desc_by_sig,  # we treat outputs and A/E propositions equally!
                                            self.inputs,
                                            atm,
                                            new_states)
        return all_constraints

    def parse_model(self, smt_get_value_lines:List[str]) -> LTS:
        return parse_model(smt_get_value_lines,
                           self.tau_desc,
                           self.desc_by_outSig, self.inputs,
                           self.model_init_state)

    def encode_model_bound(self, cur_all_states:Iterable[int]) -> List[str]:
        self.last_allowed_states = cur_all_states
        return encode_model_bound(cur_all_states, self.tau_desc)

    def encode_get_model_values(self) -> List[str]:
        return encode_get_model_values(self.tau_desc, self.desc_by_outSig,
                                       self.last_allowed_states)
