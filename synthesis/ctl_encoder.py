import logging
import sys
from itertools import product
from typing import Iterable, Dict, Tuple, List
from typing import Set

from helpers.expr_helper import get_sig_number
from helpers.logging_helper import log_entrance
from helpers.python_ext import lmap, lfilter
from interfaces.aht_automaton import AHT, Node, get_reachable_from, Transition, ExtLabel
from interfaces.aht_automaton import DstFormulaPropMgr
from interfaces.automata import Label
from interfaces.encoder_interface import EncoderInterface
from interfaces.expr import Signal, BinOp, UnaryOp, Expr, Number
from interfaces.func_description import FuncDesc
from interfaces.labels_map import LabelsMap
from interfaces.lts import LTS
from interfaces.solver_interface import SolverInterface
from parsing.visitor import Visitor
from synthesis.funcs_args_types_names import TYPE_MODEL_STATE, ARG_MODEL_STATE, FUNC_REACH, FUNC_R, \
    smt_name_spec, smt_name_m, smt_name_free_arg, smt_arg_name_signal, smt_unname_if_signal, smt_unname_m, \
    ARG_A_STATE, TYPE_A_STATE


def _build_inputs_values(inputs:Iterable[Signal],
                         label:Label)\
        -> Tuple[Dict[str,str], List[str]]:
    value_by_signal = dict()
    free_values = []

    for s in inputs:  # type: Signal
        if s in label:
            value_by_signal[smt_arg_name_signal(s)] = str(label[s]).lower()
        else:
            value = '?{0}'.format(str(s)).lower()  # FIXME: hack: we str(signal)
            value_by_signal[smt_arg_name_signal(s)] = value
            free_values.append(value)

    return value_by_signal, free_values


class CTLEncoder(EncoderInterface):
    def __init__(self,
                 logic,
                 aht:AHT, aht_transitions:Iterable[Transition],
                 dstPropMgr:DstFormulaPropMgr,
                 solver:SolverInterface,
                 tau_desc:FuncDesc,
                 inputs:Iterable[Signal],
                 descr_by_output:Dict[Signal,FuncDesc],
                 model_init_state:int=0):  # the automata alphabet is inputs+outputs
        self.logger = logging.getLogger(__name__)

        self.logic = logic
        self.solver = solver                    # type: SolverInterface

        self.aht = aht                          # type: AHT
        self.aht_transitions = aht_transitions  # type: Iterable[Transition]
        self.dstPropMgr = dstPropMgr            # type: DstFormulaPropMgr

        self.inputs = inputs                    # type: Iterable[Signal]
        self.descr_by_output = descr_by_output  # type: Dict[Signal,FuncDesc]
        self.tau_desc = tau_desc                # type: FuncDesc

        reach_args = {ARG_A_STATE: TYPE_A_STATE,
                      ARG_MODEL_STATE: TYPE_MODEL_STATE}

        r_args = reach_args

        self.reach_func_desc = FuncDesc(FUNC_REACH, reach_args, 'Bool', None)
        self.rank_func_desc = FuncDesc(FUNC_R, r_args,
                                       logic.counters_type(sys.maxsize),
                                       None)

        self.model_init_state = model_init_state  # type: int
        self.last_allowed_states = None           # type: range

    def _smt_out(self, label:Label, s_m:str) -> str:
        conjuncts = []

        args_dict = { ARG_MODEL_STATE: s_m }

        for sig, val in label.items():
            if sig not in self.descr_by_output:
                continue

            out_desc = self.descr_by_output[sig]

            condition_on_out = self.solver.call_func(out_desc, args_dict)

            if val is False:
                condition_on_out = self.solver.op_not(condition_on_out)

            conjuncts.append(condition_on_out)

        condition = self.solver.op_and(conjuncts)
        return condition

    def _get_free_input_args(self, i_o:Label):
        _, free_args = _build_inputs_values(self.inputs, i_o)
        return free_args

    def _get_counters_args(self, s_m:str, q:Node) -> Dict[str, str]:
        return {ARG_MODEL_STATE: s_m,
                    ARG_A_STATE: smt_name_spec(q.name, TYPE_A_STATE)}

    def _build_args_dict(self, s_m:str, state_label:Label, q:Node) -> Dict[str, str]:
        assert 0
        # args_dict = dict()
        # args_dict[ARG_MODEL_STATE] = smt_m
        # args_dict[ARG_A_STATE] = smt_name_spec(q.name, TYPE_A_STATE)
        #
        # if state_label is None:
        #     return args_dict
        #
        # smt_label_args, _ =
        #

        # value_by_signal = dict()
        # free_values = []
        #
        # for s in self.inputs:
        #     if s in label:
        #         value_by_signal[smt_arg_name_signal(s)] = str(label[s]).lower()
        #     else:
        #         value = '?{0}'.format(str(s)).lower()  # TODO: hack: we str(signal)
        #         value_by_signal[smt_arg_name_signal(s)] = value
        #         free_values.append(value)
        #
        # return value_by_signal, free_values

        # _build_inputs_values(self.inputs, label)
        # args_dict.update(smt_label_args)
        # return args_dict
    ##
    ##

    # encoding headers
    def encode_headers(self, model_states:Iterable[int]):
        self._encode_automata_functions()
        self._encode_model_functions(model_states)
        self._encode_counters()

    def _encode_model_functions(self, model_states:Iterable[int]):
        self.solver.declare_enum(TYPE_MODEL_STATE, [smt_name_m(m) for m in model_states])
        self._define_declare_functions([self.tau_desc])
        self._define_declare_functions(self.descr_by_output.values())

    def _encode_automata_functions(self):
        aht_nodes = get_reachable_from(self.aht.init_node, self.aht_transitions, self.dstPropMgr)[0]
        self.solver.declare_enum(TYPE_A_STATE,
                                 map(lambda n: smt_name_spec(n.name, TYPE_A_STATE), aht_nodes))

    def _encode_counters(self):
        self.solver.declare_fun(self.reach_func_desc)
        self.solver.declare_fun(self.rank_func_desc)

    # ################## encoding rules ####################
    def encode_initialization(self):
        q_init = self.aht.init_node
        m_init = self.model_init_state
        reach_args = {ARG_A_STATE: smt_name_spec(q_init.name, TYPE_A_STATE),
                      ARG_MODEL_STATE: smt_name_m(m_init)}

        self.solver.assert_(
            self.solver.call_func(
                self.reach_func_desc, reach_args))

    def encode_run_graph(self, states_to_encode:Iterable[int]):
        # state_to_rejecting_scc = build_state_to_rejecting_scc(self.automaton)

        states, _ = get_reachable_from(self.aht.init_node,
                                       self.aht_transitions,
                                       self.dstPropMgr)
        for q in states:                # type: Node
            for m in states_to_encode:  # type: int
                self.solver.comment("encoding spec state '%s':" % smt_name_spec(q.name, TYPE_A_STATE))
                self._encode_state(q, m)

    def _get_greater_op(self, q:Node):
        if q.is_existential:
            if q.is_final:
                return None
            else:
                return self.solver.op_gt
        if not q.is_existential:
            if q.is_final:
                return self.solver.op_gt
            else:
                return self.solver.op_ge

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

    def _encode_state(self, q:Node, m:int):
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
        s_q = smt_name_spec(q.name, TYPE_A_STATE)
        s_premise = self.solver.call_func(self.reach_func_desc,
                                          {ARG_MODEL_STATE: s_m,
                                           ARG_A_STATE: s_q})

        # build s_conclusion `exists`
        s_conclusion_out_sExpr_pairs = set()   # type: Set[str, str]
        for t in q_transitions:  # type: Transition
            s_t_state_label = self._smt_out(t.state_label, s_m)
            s_dst_expr = self._translate_dst_expr_into_smt(t.dst_expr, q, m)
            s_conclusion_out_sExpr_pairs.add( (s_t_state_label, s_dst_expr) )

        if q.is_existential:
            s_conclusion_elements = lmap(lambda sce: self.solver.op_and(sce),
                                         s_conclusion_out_sExpr_pairs)
        else:
            s_conclusion_elements = lmap(lambda sce: self.solver.op_implies(sce[0],
                                                                            sce[1]),
                                         s_conclusion_out_sExpr_pairs)

        s_conclusion = (self.solver.op_and,
                        self.solver.op_or)[q.is_existential]\
            (s_conclusion_elements)

        s_assertion = self.solver.op_implies(s_premise, s_conclusion)

        self.solver.assert_(s_assertion)

    def encode_model_bound(self, allowed_model_states:range):
        self.solver.comment('encoding model bound: ' + str(allowed_model_states))

        # all args of tau function are quantified
        args_dict = dict((a, smt_name_free_arg(a))
                         for (a,ty) in self.tau_desc.inputs)

        free_vars = [(args_dict[a],ty)
                     for (a,ty) in self.tau_desc.inputs]

        smt_m_next = self.solver.call_func(self.tau_desc, args_dict)

        disjuncts = []
        for allowed_m in allowed_model_states:
            disjuncts.append(self.solver.op_eq(smt_m_next,
                                               smt_name_m(allowed_m)))

        condition = self.solver.forall(free_vars,
                                       self.solver.op_or(disjuncts))
        self.solver.assert_(condition)

        self.last_allowed_states = allowed_model_states
    ##
    ##

    def _define_declare_functions(self, func_descs):
        # should preserve the order: some functions may depend on others
        desc_by_name = dict((desc.name, (i, desc)) for (i, desc) in enumerate(func_descs))
        # TODO: cannot use set of func descriptions due to hack in FuncDescription

        unique_index_descs_sorted = sorted(desc_by_name.values(), key=lambda i_d: i_d[0])
        unique_descs = lmap(lambda i_d: i_d[1], unique_index_descs_sorted)

        for desc in unique_descs:
            if desc.definition is not None:
                self.solver.define_fun(desc)
            else:
                self.solver.declare_fun(desc)

    #
    #
    # ##################### SMT Solver and Model Parser ###############################
    def push(self):
        return self.solver.push()

    def pop(self):
        return self.solver.pop()

    @log_entrance()
    def solve(self) -> LTS:
        self.solver.add_check_sat()

        self._encode_get_values()  # incremental solvers should not fail for such a strange case if UNSAT:)

        smt_lines = self.solver.solve()
        if not smt_lines:
            return None

        model = self._parse_sys_model(smt_lines)
        return model

    def _encode_get_values(self):
        func_descs = [self.tau_desc] + list(self.descr_by_output.values())

        for func_desc in func_descs:
            for input_dict in self._get_all_possible_inputs(func_desc):
                self.solver.get_value(self.solver.call_func(func_desc, input_dict))

    def _get_all_possible_inputs(self, func_desc:FuncDesc):
        arg_type_pairs = func_desc.inputs

        get_values = lambda t: {          'Bool': ('true', 'false'),
                                TYPE_MODEL_STATE: [smt_name_m(m) for m in self.last_allowed_states],
                                    TYPE_A_STATE: [smt_name_spec(s.name, TYPE_A_STATE)
                                                   for s in get_reachable_from(self.aht.init_node,
                                                                               self.aht_transitions,
                                                                               self.dstPropMgr)[0]]
                               }[t]

        records = product(*[get_values(t) for (_,t) in arg_type_pairs])

        args = list(map(lambda a_t: a_t[0], arg_type_pairs))

        dicts = []
        for record in records:
            assert len(args) == len(record)

            arg_value_pairs = zip(args, record)
            dicts.append(dict(arg_value_pairs))

        return dicts

    @log_entrance()
    def _parse_sys_model(self, smt_get_value_lines):
        # TODO: depends on the SMT format, while all other code here is abstracted from the low-level SMT
        output_models = dict()
        for output_sig, output_desc in self.descr_by_output.items():
            output_func_model = self._build_func_model_from_smt(smt_get_value_lines, output_desc)
            output_models[output_sig] = LabelsMap(output_func_model)

        tau_model = LabelsMap(self._build_func_model_from_smt(smt_get_value_lines, self.tau_desc))

        lts = LTS([self.model_init_state],
                  output_models, tau_model,
                  ARG_MODEL_STATE,
                  self.inputs, list(self.descr_by_output.keys()))

        return lts

    def _build_func_model_from_smt(self, func_smt_lines, func_desc:FuncDesc) -> dict:
        """
        Return graph for the transition (or output) function: {label:output}.
        For label's keys are used:
        - for inputs/outputs: original signals
        - for LTS states: ARG_MODEL_STATE
        """
        func_model = {}
        signals = set(list(self.inputs) + list(self.descr_by_output.keys()))

        for l in func_smt_lines:
            #            (get-value ((tau t0 true true)))
            l = l.replace('get-value', '').replace('(', '').replace(')', '')
            tokens = l.split()

            func_name = tokens[0]
            arg_values_raw = lmap(self._parse_value, tokens[1:-1])
            return_value_raw = tokens[-1]

            if func_name != func_desc.name:
                continue

            smt_args = func_desc.get_args_dict(arg_values_raw)

            args_label = Label(dict((smt_unname_if_signal(var, signals), val)
                                    for var, val in smt_args.items()))

            if func_desc.output_ty == TYPE_MODEL_STATE:
                return_value = smt_unname_m(return_value_raw)
            else:
                assert func_desc.output_ty == self.solver.TYPE_BOOL(), func_desc.output_ty
                assert return_value_raw.strip() == return_value_raw  # TODO: remove after debugging phase
                return_value = (return_value_raw == self.solver.get_true())

            func_model[args_label] = return_value

        return func_model

    def _parse_value(self, str_v):
        if not hasattr(self, 'node_by_smt_value'):  # aka static method of the field
            self.node_by_smt_value = dict()
            self.node_by_smt_value.update((smt_name_spec(s.name, TYPE_A_STATE), s)
                                         for s in get_reachable_from(self.aht.init_node,
                                                                     self.aht_transitions,
                                                                     self.dstPropMgr)[0])

        if str_v in self.node_by_smt_value:
            return self.node_by_smt_value[str_v]
        if str_v in ['false', 'true']:
            return str_v == 'true'
        return smt_unname_m(str_v)

    def _translate_dst_expr_into_smt(self, dst_expr:Expr, q:Node, m:int) -> str:
        class SMTConverter(Visitor):
            def __init__(self, encoder:CTLEncoder, q:Node, m:int):
                self.encoder = encoder         # type: CTLEncoder
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
                tau_input_args_dict, free_input_args = _build_inputs_values(self.encoder.inputs,
                                                                            ext_label.fixed_inputs)
                tau_input_args_dict[ARG_MODEL_STATE] = smt_name_m(self.m)

                s_m_next = self.encoder.solver.call_func(self.encoder.tau_desc, tau_input_args_dict)
                s_q_next = smt_name_spec(q_next.name, TYPE_A_STATE)

                # build reach_next
                reach_next_args = {ARG_A_STATE: s_q_next,
                                   ARG_MODEL_STATE: s_m_next}
                reach_next = self.encoder.solver.call_func(self.encoder.reach_func_desc, reach_next_args)

                # build rank_cmp
                rank_args = {ARG_A_STATE: smt_name_spec(self.q.name, TYPE_A_STATE),
                             ARG_MODEL_STATE: smt_name_m(self.m)}
                rank_next_args = reach_next_args
                rank = self.encoder.solver.call_func(self.encoder.rank_func_desc, rank_args)
                rank_next = self.encoder.solver.call_func(self.encoder.rank_func_desc, rank_next_args)
                rank_cmp_op = self.encoder._get_greater_op(q_next)
                rank_cmp = rank_cmp_op(rank, rank_next) if rank_cmp_op else self.encoder.solver.get_true()

                # build `\exists[forall]: reach_next & rank_cmp`
                reach_and_rank_cmp = self.encoder.solver.op_and([reach_next, rank_cmp])

                op = (self.encoder.solver.forall_bool,
                      self.encoder.solver.exists_bool)[ext_label.type_==ExtLabel.EXISTS]

                return op(free_input_args, reach_and_rank_cmp)

            def visit_binary_op(self, binary_op:BinOp):
                if binary_op.name == '=':
                    return self._visit_prop(*get_sig_number(binary_op))
                if binary_op.name == '*':
                    return self.encoder.solver.op_and([self.dispatch(binary_op.arg1),
                                                       self.dispatch(binary_op.arg2)])
                if binary_op.name == '+':
                    return self.encoder.solver.op_or([self.dispatch(binary_op.arg1),
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

# end of CTLEncoder
