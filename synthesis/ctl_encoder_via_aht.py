from typing import Iterable, Dict, List
from typing import Set

from helpers.expr_helper import get_sig_number
from helpers.logging_helper import log_entrance
from helpers.python_ext import lmap, lfilter
from interfaces.LTS import LTS
from interfaces.aht_automaton import AHT, Node, get_reachable_from, Transition, ExtLabel
from interfaces.aht_automaton import DstFormulaPropMgr
from interfaces.expr import Signal, BinOp, UnaryOp, Expr, Number
from interfaces.func_description import FuncDesc
from parsing.visitor import Visitor
from synthesis.encoder_helper import encode_get_model_values, parse_model, encode_model_bound, build_inputs_values, \
    smt_out
from synthesis.encoder_interface import EncoderInterface
from synthesis.smt_format import call_func, forall_bool, exists_bool, op_and, op_or, bool_type, declare_fun, comment, \
    op_implies, op_ge, op_gt, declare_enum, assertion, real_type, true
from synthesis.smt_namings import TYPE_A_STATE, TYPE_MODEL_STATE, ARG_MODEL_STATE, ARG_A_STATE, \
    FUNC_REACH, FUNC_R, smt_name_q, smt_name_m


class CTLEncoderViaAHT(EncoderInterface):
    def __init__(self,
                 aht:AHT, aht_transitions:Iterable[Transition],
                 dstPropMgr:DstFormulaPropMgr,
                 tau_desc:FuncDesc,
                 inputs:Iterable[Signal],
                 descr_by_output:Dict[Signal,FuncDesc],
                 model_init_state:int=0):  # the automata alphabet is inputs+outputs
        self.aht = aht                          # type: AHT
        self.aht_transitions = aht_transitions  # type: Iterable[Transition]
        self.dstPropMgr = dstPropMgr            # type: DstFormulaPropMgr

        self.inputs = inputs                    # type: Iterable[Signal]
        self.descr_by_output = descr_by_output  # type: Dict[Signal,FuncDesc]
        self.tau_desc = tau_desc                # type: FuncDesc

        reach_args = {ARG_A_STATE: TYPE_A_STATE,
                      ARG_MODEL_STATE: TYPE_MODEL_STATE}

        r_args = reach_args

        self.reach_func_desc = FuncDesc(FUNC_REACH, reach_args, bool_type())
        self.rank_func_desc = FuncDesc(FUNC_R, r_args, real_type())

        self.model_init_state = model_init_state  # type: int
        self.last_allowed_states = None           # type: range

    # encoding headers
    def encode_headers(self, model_states:Iterable[int]) -> List[str]:
        res = self._encode_automata_functions() +\
              self._encode_model_functions(model_states) +\
              self._encode_counters()
        return res

    def _encode_model_functions(self, model_states:Iterable[int]) -> List[str]:
        return [declare_enum(TYPE_MODEL_STATE, map(smt_name_m, model_states))] + \
               [declare_fun(self.tau_desc)] + \
               [declare_fun(d) for d in self.descr_by_output.values()]

    def _encode_automata_functions(self) -> List[str]:
        aht_nodes = get_reachable_from(self.aht.init_node, self.aht_transitions, self.dstPropMgr)[0]
        return [declare_enum(TYPE_A_STATE, map(lambda n: smt_name_q(n), aht_nodes))]

    def _encode_counters(self) -> List[str]:
        return [declare_fun(self.reach_func_desc),
                declare_fun(self.rank_func_desc)]

    def encode_initialization(self) -> List[str]:
        q_init = self.aht.init_node
        m_init = self.model_init_state
        reach_args = {ARG_A_STATE: smt_name_q(q_init),
                      ARG_MODEL_STATE: smt_name_m(m_init)}

        return [assertion(
                    call_func(
                        self.reach_func_desc, reach_args))]

    def encode_run_graph(self, states_to_encode:Iterable[int]) -> List[str]:
        # state_to_rejecting_scc = build_state_to_rejecting_scc(self.automaton)

        res = []
        states, _ = get_reachable_from(self.aht.init_node,
                                       self.aht_transitions,
                                       self.dstPropMgr)
        for q in states:                # type: Node
            for m in states_to_encode:  # type: int
                res += [comment("encoding spec state '%s':" % smt_name_q(q))]
                res += self._encode_state(q, m)
        return res

    def _get_greater_op(self, q:Node):
        # TODO: faster _is_ possible
        if q.is_existential:
            if q.is_final:
                return None
            else:
                return op_gt
        if not q.is_existential:
            if q.is_final:
                return op_gt
            else:
                return op_ge

        # crt_rejecting_scc = state_to_rejecting_scc.get(q, None)
        # next_rejecting_scc = state_to_rejecting_scc.get(q_next, None)
        #
        # if crt_rejecting_scc is not next_rejecting_scc:
        #     return None
        # if crt_rejecting_scc is None:
        #     return None
        # if next_rejecting_scc is None:
        #     return None
        #
        # return [self.solver.op_ge, self.solver.op_gt][is_rejecting]

    def _encode_state(self, q:Node, m:int) -> List[str]:
        q_transitions = lfilter(lambda t: t.src == q, self.aht_transitions)

        # Encoding:
        # - if q is existential, then one of the transitions must fire:
        #
        #     reach(q,t) ->
        #                OR{state_label \in q_transitions}: sys_out=state_label & reach(q',t')
        #
        # - if q is universal, then all transitions of that system output should fire
        #
        #     reach(q,t) ->
        #                AND{state_label \in q_transitions}: sys_out=state_label -> reach(q',t')
        #

        # build s_premise `reach(q,t)`
        s_m = smt_name_m(m)
        s_q = smt_name_q(q)
        s_premise = call_func(self.reach_func_desc, {ARG_MODEL_STATE: s_m,
                                                     ARG_A_STATE: s_q})

        # build s_conclusion `exists`
        s_conclusion_out_sExpr_pairs = set()   # type: Set[str, str]
        for t in q_transitions:  # type: Transition
            s_t_state_label = smt_out(s_m, t.state_label, self.inputs, self.descr_by_output)
            s_dst_expr = self._translate_dst_expr_into_smt(t.dst_expr, q, m)
            s_conclusion_out_sExpr_pairs.add( (s_t_state_label, s_dst_expr) )

        if q.is_existential:
            s_conclusion_elements = lmap(lambda sce: op_and(sce),
                                         s_conclusion_out_sExpr_pairs)
        else:
            s_conclusion_elements = lmap(lambda sce: op_implies(sce[0],
                                                                            sce[1]),
                                         s_conclusion_out_sExpr_pairs)

        s_conclusion = (op_and, op_or)[q.is_existential](s_conclusion_elements)

        s_assertion = op_implies(s_premise, s_conclusion)

        return [assertion(s_assertion)]

    def encode_model_bound(self, allowed_model_states:range) -> List[str]:
        self.last_allowed_states = allowed_model_states
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

    def _translate_dst_expr_into_smt(self, dst_expr:Expr, q:Node, m:int) -> str:
        class SMTConverter(Visitor):
            def __init__(self, encoder:CTLEncoderViaAHT, q:Node, m:int):
                self.encoder = encoder         # type: CTLEncoderViaAHT
                self.q = q                     # type: Node
                self.m = m                     # type: int

            def _visit_prop(self, sig:Signal, number:Number) -> str:
                # TODO: run it
                # Encode into SMT proposition `DstFormulaProp`, i.e., smth. like
                #   (r&E(c), q_next)
                # It should become
                #   \exists c: reach(q_next, tau(t, r, ?c)) &
                #              rank(q,t)<>rank(q_next, tau(t, r, ?c))

                assert number == Number(1), "program invariant: propositions are positive"
                dstFormProp = self.encoder.dstPropMgr.get_dst_form_prop(sig.name)

                ext_label, q_next = dstFormProp.ext_label, dstFormProp.dst_state

                # build s_m_next, s_q_next
                tau_input_args_dict, free_input_args = build_inputs_values(self.encoder.inputs,
                                                                           ext_label.fixed_inputs)
                tau_input_args_dict[ARG_MODEL_STATE] = smt_name_m(self.m)

                s_m_next = call_func(self.encoder.tau_desc, tau_input_args_dict)
                s_q_next = smt_name_q(q_next)

                # build reach_next
                reach_next_args = {ARG_A_STATE: s_q_next,
                                   ARG_MODEL_STATE: s_m_next}
                reach_next = call_func(self.encoder.reach_func_desc, reach_next_args)

                # build rank_cmp
                rank_args = {ARG_A_STATE: smt_name_q(self.q),
                             ARG_MODEL_STATE: smt_name_m(self.m)}
                rank_next_args = reach_next_args
                rank = call_func(self.encoder.rank_func_desc, rank_args)
                rank_next = call_func(self.encoder.rank_func_desc, rank_next_args)
                rank_cmp_op = self.encoder._get_greater_op(q_next)
                rank_cmp = rank_cmp_op(rank, rank_next) if rank_cmp_op else true()

                # build `\exists[forall]: reach_next & rank_cmp`
                reach_and_rank_cmp = op_and([reach_next, rank_cmp])

                op = (forall_bool, exists_bool)[ext_label.type_==ExtLabel.EXISTS]

                return op(free_input_args, reach_and_rank_cmp)

            def visit_binary_op(self, binary_op:BinOp):
                if binary_op.name == '=':
                    return self._visit_prop(*get_sig_number(binary_op))
                if binary_op.name == '*':
                    return op_and([self.dispatch(binary_op.arg1),
                                                       self.dispatch(binary_op.arg2)])
                if binary_op.name == '+':
                    return op_or([self.dispatch(binary_op.arg1),
                                                      self.dispatch(binary_op.arg2)])
                assert 0, "impossible: " + str(binary_op)

            def visit_unary_op(self, unary_op:UnaryOp):
                assert 0, "impossible"
        # end of SMTConverter

        # For example, if have dst_expr:
        #
        #   (E(c,r), 'n3_accept_all')=1 *
        #   (E(c,r), 'n5_accept_S1')=1 *
        #   (A(c,r), '~n4_T0_init')=1,
        #
        # then it translates into
        #
        #   \exists (c,r): reach('n3_accept_all', tau(t, c, r)) \and
        #                  rank(q, t) <> rank('n3_accept_all', tau(t, c, r)) \and
        #   \exists (c,r): reach('n5_accept_S1', tau(t, c, r)) \and
        #                  rank(q, t) <> rank('n5_accept_S1', tau(t, c, r)) \and
        #   \forall (c,r): reach('~n4_T0_init', tau(t, c, r)) \and
        #                  rank(q, t) <> rank('~n4_T0_init', tau(t, c, r))
        #
        # Thus:
        # - binary operations stay
        # - each proposition is translated into \exists\forall smt statement

        s_expr = SMTConverter(self, q, m).dispatch(dst_expr)
        return s_expr
