import logging
from itertools import product
import sys
from helpers.console_helpers import print_green

from helpers.labels_map import LabelsMap
from helpers.logging_helper import log_entrance
from helpers.python_ext import StrAwareList
from interfaces.automata import Label, Automaton, get_next_states, Node, DEAD_END
from interfaces.lts import LTS
from interfaces.parser_expr import Signal
from interfaces.solver_interface import SolverInterface
from synthesis import smt_helper
from synthesis.assume_guarantee_encoder import assert_deterministic_transition
from synthesis.func_description import FuncDescription
from synthesis.funcs_args_types_names import TYPE_MODEL_STATE, ARG_MODEL_STATE, ARG_L_a_STATE, ARG_L_g_STATE, \
    TYPE_L_a_STATE, TYPE_L_g_STATE, FUNC_REACH, FUNC_R, \
    smt_name_spec, smt_name_m, smt_name_free_arg, smt_arg_name_signal, smt_unname_if_signal, smt_unname_m, \
    TYPE_S_STATE, ARG_S_STATE, FUNC_L_a_TRANS, FUNC_L_g_TRANS, \
    FUNC_L_a_ACC, FUNC_L_g_ACC


def _build_signals_values(signals, label) -> (dict, list):
    for s in signals:
        assert isinstance(s, Signal)

    value_by_signal = dict()
    free_values = []

    for s in signals:
        if s in label:
            value_by_signal[smt_arg_name_signal(s)] = str(label[s]).lower()
        else:
            value = '?{0}'.format(str(s)).lower()  # TODO: hack: we str(signal)
            value_by_signal[smt_arg_name_signal(s)] = value
            free_values.append(value)

    return value_by_signal, free_values


def intersection2(label1, label2):
    for var1, val1 in label1.items():
        if var1 in label2 and val1 != label2[var1]:
            return None
    intersection_dict = dict(label1)
    intersection_dict.update(label2)
    return Label(intersection_dict)


def intersection3(label1, label2, label3):
    l2_and_l3 = intersection2(label2, label3)
    if l2_and_l3 is None:
        return None

    l1_and_l2_and_l3 = intersection2(label1, l2_and_l3)
    return l1_and_l2_and_l3

def generate_combinations(s_label, s:Node, l_a:Node, l_g:Node):
    # for other nodes we cannot do the same, so check all possible combinations of next states

    l_a_labels = tuple(filter(lambda l: intersection2(s_label, l) is not None, l_a.transitions.keys()))
    l_g_labels = tuple(filter(lambda l: intersection2(s_label, l) is not None, l_g.transitions.keys()))

    edges = list()  # (label, s_nexts, l_a_nexts, l_g_nexts)
    for l_a_label, l_g_label in product(l_a_labels, l_g_labels):
        s_la_lg_label = intersection3(s_label, l_a_label, l_g_label)

        if s_la_lg_label is not None:
            s_nexts = get_next_states(s, s_la_lg_label)
            l_a_nexts = get_next_states(l_a, s_la_lg_label)
            l_g_nexts = get_next_states(l_g, s_la_lg_label)
            edges.append((s_la_lg_label, s_nexts, l_a_nexts, l_g_nexts))

    return edges


def smt_condition(state_arg_name, smt_q:str, label:Label):
    conjuncts = [smt_helper.op_eq(state_arg_name, smt_q)]

    for var,val in label.items():
        assert val in [True, False], 'unknown val: ' + str(val) + ', var: ' + str(var)

        if val:
            conjuncts.append(smt_arg_name_signal(var))
        else:
            conjuncts.append(smt_helper.op_not(smt_arg_name_signal(var)))

    return smt_helper.op_and(conjuncts)


def build_smt_for_automaton_acc(automaton:Automaton,
                                state_type, state_arg_name,
                                func_name) -> FuncDescription:
    automaton_acc_func = FuncDescription(func_name,
                                         {state_arg_name:state_type},
                                         'Bool',
                                         None)
    # args_def = '({arg_name} {ty})'.format(arg_name=state_arg_name,
    #                                       ty=state_type)

    smt_lines = StrAwareList()

    # the first line is output by the smt_helper
    # smt_lines += '(define-fun {func_name} ({args_def}) Bool'.format(func_name=func_name, args_def=args_def)

    disjuncts = []
    for q in automaton.acc_nodes:
        disjuncts.append(smt_helper.op_eq(state_arg_name, smt_name_spec(q, state_type)))

    smt_lines += smt_helper.op_or(disjuncts)

    automaton_acc_func._body = smt_lines.to_str()

    return automaton_acc_func


def build_smt_for_automaton_trans(automaton:Automaton, alphabet,
                                  state_type, state_arg_name,
                                  func_name) -> FuncDescription:
    """
    pre: the automaton must be deterministic and total
    """

    type_by_arg = {state_arg_name:state_type}
    type_by_arg.update([(smt_arg_name_signal(sig), 'Bool')
                        for sig in alphabet])
    automaton_func = FuncDescription(func_name, type_by_arg, state_type, None)  # ctor fixes the order of input args
                                                                                # we use that order below
    # args_def = ' '.join(['({arg_name} {ty})'.format(arg_name=a, ty=ty)
    #                     for (a,ty) in automaton_func.inputs])

    smt_lines = StrAwareList()
    # smt_lines += '(define-fun {func_name} ({args_def}) {state_type}'.format(func_name=func_name,
    #                                                                         args_def=args_def,
    #                                                                         state_type=state_type)

    nof_transitions = sum(map(lambda n: len(n.transitions), automaton.nodes))
    cur_transition = 0
    for q in automaton.nodes:
        for label, dst_set_list in q.transitions.items():
            assert len(dst_set_list) == 1
            dst_set = dst_set_list[0]
            assert len(dst_set) == 1

            q_next = tuple(map(lambda node_flag: node_flag[0], dst_set))[0]
            if cur_transition != nof_transitions - 1:
                smt_lines += '(ite {smt_label} {q_next}'.format(smt_label=smt_condition(state_arg_name,
                                                                                        smt_name_spec(q, state_type),
                                                                                        label),
                                                                q_next=smt_name_spec(q_next, state_type))
            else:
                # we assume that the automaton is deterministic total,
                # hence checking the last ite condition is not needed
                smt_lines += '{q_next}'.format(q_next=smt_name_spec(q_next, state_type))

            cur_transition += 1

    smt_lines += ')' * (nof_transitions - 1)

    automaton_func._body = smt_lines.to_str()

    return automaton_func


class SymbolicAutomataEncoder:
    def __init__(self,
                 logic,
                 safety_automaton:Automaton,
                 L_a:Automaton,
                 L_g:Automaton,
                 solver:SolverInterface,
                 tau_desc:FuncDescription,
                 inputs,
                 descr_by_output,
                 model_init_state:int):  # the automata alphabet is inputs+outputs
        self.logger = logging.getLogger(__name__)

        self.solver = solver
        self.logic = logic

        self.safety_automaton = safety_automaton

        alphabet = tuple(inputs) + tuple(descr_by_output.keys())
        self.L_a_func = build_smt_for_automaton_trans(L_a, alphabet, TYPE_L_a_STATE, ARG_L_a_STATE, FUNC_L_a_TRANS)
        self.L_a_acc_func = build_smt_for_automaton_acc(L_a, TYPE_L_a_STATE, ARG_L_a_STATE, FUNC_L_a_ACC)
        self.L_a = L_a

        self.L_g_func = build_smt_for_automaton_trans(L_g, alphabet, TYPE_L_g_STATE, ARG_L_g_STATE, FUNC_L_g_TRANS)
        self.L_g_acc_func = build_smt_for_automaton_acc(L_g, TYPE_L_g_STATE, ARG_L_g_STATE, FUNC_L_g_ACC)
        self.L_g = L_g

        self.inputs = inputs
        self.descr_by_output = descr_by_output
        self.tau_desc = tau_desc

        reach_args = {ARG_S_STATE: TYPE_S_STATE,
                      ARG_L_a_STATE: TYPE_L_a_STATE,
                      ARG_L_g_STATE: TYPE_L_g_STATE,
                      ARG_MODEL_STATE: TYPE_MODEL_STATE}

        r_args = {ARG_L_a_STATE: TYPE_L_a_STATE,
                  ARG_L_g_STATE: TYPE_L_g_STATE,
                  ARG_MODEL_STATE: TYPE_MODEL_STATE}

        self.reach_func_desc = FuncDescription(FUNC_REACH, reach_args, 'Bool', None)
        self.r_func_desc = FuncDescription(FUNC_R, r_args,
                                           logic.counters_type(sys.maxsize),
                                           None)

        #: :type: int
        self.model_init_state = model_init_state

        self.last_allowed_states = None

    def _smt_out(self, label:Label, smt_m:str, smt_l_a:str, smt_l_g:str) -> str:
        conjuncts = []

        args_dict = self._build_args_dict(smt_m, label, None, smt_l_a, smt_l_g)

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
        _, free_args = _build_signals_values(self.inputs, i_o)
        return free_args

    def _build_args_dict(self,
                         smt_m:str,
                         i_o:Label or None,
                         smt_s:str or None,
                         smt_l_a:str or None,
                         smt_l_g:str or None) -> dict:
        args_dict = dict()
        args_dict[ARG_MODEL_STATE] = smt_m

        if smt_s:
            args_dict[ARG_S_STATE] = smt_s
        if smt_l_a:
            args_dict[ARG_L_a_STATE] = smt_l_a
        if smt_l_g:
            args_dict[ARG_L_g_STATE] = smt_l_g

        if i_o is None:
            return args_dict

        smt_label_args, _ = _build_signals_values(self.inputs, i_o)
        args_dict.update(smt_label_args)
        return args_dict
    ##
    ##

    ## encoding headers
    def encode_headers(self, model_states):
        self._encode_automata_functions()
        self._encode_model_functions(model_states)
        self._encode_counters()

    def _encode_model_functions(self, model_states):
        self.solver.declare_enum(TYPE_MODEL_STATE, [smt_name_m(m) for m in model_states])
        self._define_declare_functions([self.tau_desc])
        self._define_declare_functions(self.descr_by_output.values())

    def _encode_automata_functions(self):
        self.solver.declare_enum(TYPE_S_STATE,
                                 map(lambda n: smt_name_spec(n, TYPE_S_STATE), self.safety_automaton.nodes))

        self.solver.declare_enum(TYPE_L_a_STATE,
                                 map(lambda n: smt_name_spec(n, TYPE_L_a_STATE), self.L_a.nodes))

        self.solver.declare_enum(TYPE_L_g_STATE,
                                 map(lambda n: smt_name_spec(n, TYPE_L_g_STATE), self.L_g.nodes))

        self._define_declare_functions([self.L_a_func])
        self._define_declare_functions([self.L_a_acc_func])

        self._define_declare_functions([self.L_g_func])
        self._define_declare_functions([self.L_g_acc_func])

    def _encode_counters(self):
        self.solver.declare_fun(self.reach_func_desc)
        self.solver.declare_fun(self.r_func_desc)
    ##
    ##

    ## encoding rules
    def encode_initialization(self):
        for s, l_a, l_g, m in product(self.safety_automaton.initial_nodes,
                            self.L_a.initial_nodes,
                            self.L_g.initial_nodes,
                            [self.model_init_state]):
            vals_by_vars = self._build_args_dict(smt_name_m(m),
                                                 None,
                                                 smt_name_spec(s, TYPE_S_STATE),
                                                 smt_name_spec(l_a, TYPE_L_a_STATE),
                                                 smt_name_spec(l_g, TYPE_L_g_STATE))

            self.solver.assert_(
                self.solver.call_func(
                    self.reach_func_desc, vals_by_vars))

    # def encode_run_graph(self, states_to_encode):
    #     # state_to_rejecting_scc = build_state_to_rejecting_scc(self.automaton)
    #
    #     for q in self.safety_automaton.nodes:
    #         for m in states_to_encode:
    #             for label, dst_set_list in q.transitions.items():
    #                 self._encode_transitions(q, m, label)
    #
    #         self.solver.comment('encoded spec state ' + smt_name_spec(q, TYPE_A_STATE))

    def encode_run_graph(self, states_to_encode):
        """
        pre:
        - L_a, L_g are deterministic and total (=1 transition for each io)
        """
        # One option is to encode automata directly into SMT and have a query like:
        # (assuming the automata are deterministic)
        #
        # forall s_a, s_g, l_a, l_g, m, i:
        # s_a'(out(m,i,other_args),..) is accepting &
        # reach(s_a,s_g,l_a,l_g,m)
        # ->
        # reach(s_a'(..), s_g'(..), l_a'(..), l_g'(..), m'(..)) & r(...) >< r(...)
        #
        # It seems that this requires Z3 to optimize a lot ????
        # But the plus is that the query is _very_ compact.

        # TODO: also try `forall l_a,l_g` version
        for s, l_a, l_g, m in product(self.safety_automaton.nodes,
                                      self.L_a.nodes,
                                      self.L_g.nodes,
                                      states_to_encode):

            self.solver.comment('encoding state: ' + str((s, l_a, l_g, m)) + '...')

            for label, dst_set_list in s.transitions.items():
                assert len(dst_set_list) == 1
                s_nexts = tuple(map(lambda node_flag: node_flag[0], dst_set_list[0]))

                for s_n in s_nexts:
                    self._encode_transitions(s, l_a, l_g, m,
                                             label,
                                             s_n)

            self.solver.comment('encoded the state!')

    def _encode_transitions(self,
                            s:Node, l_a:Node, l_g:Node, m:int,
                            label:Label,
                            s_n:Node):

        # syntax sugar
        smt_r = lambda args: self.solver.call_func(self.r_func_desc, args)
        smt_reach = lambda args: self.solver.call_func(self.reach_func_desc, args)
        #

        smt_m = smt_name_m(m)
        smt_s = smt_name_spec(s, TYPE_S_STATE)
        smt_l_a = smt_name_spec(l_a, TYPE_L_a_STATE)
        smt_l_g = smt_name_spec(l_g, TYPE_L_g_STATE)
        smt_out = self._smt_out(label, smt_m, smt_l_a, smt_l_g)

        args_dict = self._build_args_dict(smt_m,
                                          label,
                                          smt_s,
                                          smt_l_a,
                                          smt_l_g)
        free_input_args = self._get_free_input_args(label)

        # we update args_dict to include the current output values
        for out_sig, desc in self.descr_by_output.items():
            smt_out_arg = smt_arg_name_signal(out_sig)
            smt_out_value = self.solver.call_func(desc, args_dict)
            args_dict[smt_out_arg] = smt_out_value

        smt_pre = self.solver.op_and([smt_reach(args_dict), smt_out])

        # the case of next safety state is bad
        if s_n is DEAD_END or 'accept_all' in s_n.name or s_n in self.safety_automaton.acc_nodes:  # TODO: hm, weird hack
            self.solver.assert_(
                self.solver.forall_bool(free_input_args,
                                        self.solver.op_not(smt_pre)))
            return

        # the case of next safety state is 'normal'
        smt_m_next = self.solver.call_func(self.tau_desc, args_dict)

        smt_post_conjuncts = []

        smt_l_a_n = self.solver.call_func(self.L_a_func, args_dict)
        smt_l_g_n = self.solver.call_func(self.L_g_func, args_dict)

        args_dict_next = self._build_args_dict(smt_m_next,
                                               None,
                                               smt_name_spec(s_n, TYPE_S_STATE),
                                               smt_l_a_n,
                                               smt_l_g_n)
        smt_post_conjuncts.append(smt_reach(args_dict_next))

        smt_ranks_gt = self.solver.op_gt(smt_r(args_dict_next),
                                         smt_r(args_dict))

        smt_ranks_ge = self.solver.op_ge(smt_r(args_dict_next),
                                         smt_r(args_dict))

        smt_post_rank = '(ite (not {L_g_n_acc})' \
                        '  (ite {L_a_n_acc}' \
                        '    {smt_ranks_gt}' \
                        '    {smt_ranks_ge}' \
                        '  )' \
                        '  true' \
                        ')'
        smt_post_rank = smt_post_rank.format(L_g_n_acc=self.solver.call_func(self.L_g_acc_func, args_dict_next),
                                             L_a_n_acc=self.solver.call_func(self.L_a_acc_func, args_dict_next),
                                             smt_ranks_ge=smt_ranks_ge,
                                             smt_ranks_gt=smt_ranks_gt)

        smt_post_conjuncts.append(smt_post_rank)

        # (ite (not L_g.acc(l_g_n))
        #   (ite (L_a.acc(l_a_n))
        #     (greater_than condition)
        #     (greater condition))
        #   (true))

        # if l_g_n not in self.L_g.acc_nodes:
        #     if l_a_n in self.L_a.acc_nodes:
        #         op = self.solver.op_gt
        #     else:
        #         op = self.solver.op_ge
        #
        #     smt_post_conjuncts.append(op(smt_r(args_dict_next),
        #                                  smt_r(args_dict)))

        smt_post = self.solver.op_and(smt_post_conjuncts)
        pre_implies_post = self.solver.op_implies(smt_pre, smt_post)
        self.solver.assert_(
            self.solver.forall_bool(free_input_args,
                                    pre_implies_post))

    def encode_model_bound(self, allowed_model_states):
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
        for desc in func_descs:
            if desc.definition is not None:
                self.solver.define_fun(desc)
            else:
                self.solver.declare_fun(desc)

    #
    #
    ###################### SMT Solver and Model Parser ###############################
    def push(self):
        return self.solver.push()

    def pop(self):
        return self.solver.pop()

    @log_entrance(logging.getLogger(), logging.INFO)
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

    def _get_all_possible_inputs(self, func_desc:FuncDescription):
        arg_type_pairs = func_desc.inputs

        def get_values(t):
            return {          'Bool': ('true', 'false'),
                        TYPE_S_STATE: [smt_name_spec(s, TYPE_S_STATE) for s in self.safety_automaton.nodes],
                        TYPE_L_a_STATE: [smt_name_spec(s, TYPE_L_a_STATE) for s in self.L_a.nodes],
                        TYPE_L_g_STATE: [smt_name_spec(s, TYPE_L_g_STATE) for s in self.L_g.nodes],
                              TYPE_MODEL_STATE: [smt_name_m(m) for m in self.last_allowed_states]
                   }[t]
        records = product(*[get_values(t) for (_,t) in arg_type_pairs])

        args = list(map(lambda a_t: a_t[0], arg_type_pairs))

        dicts = []
        for record in records:
            assert len(args) == len(record)

            arg_value_pairs = zip(args, record)
            dicts.append(dict(arg_value_pairs))

        return dicts

    @log_entrance(logging.getLogger(), logging.INFO)
    def _parse_sys_model(self, smt_get_value_lines):  # TODO: depends on SMT format
        output_models = dict()
        for output_sig, output_desc in self.descr_by_output.items():
            output_func_model = self._build_func_model_from_smt(smt_get_value_lines, output_desc)
            output_models[output_sig] = LabelsMap(output_func_model)

        tau_model = LabelsMap(self._build_func_model_from_smt(smt_get_value_lines, self.tau_desc))
        # tau_model = self._simplify_tau(tau_model, tau_func_desc, impl.states_by_process[0])

        lts = LTS([self.model_init_state],
                  output_models, tau_model,
                  ARG_MODEL_STATE,
                  self.inputs, list(self.descr_by_output.keys()))

        return lts

    def _build_func_model_from_smt(self, func_smt_lines, func_desc:FuncDescription) -> dict:
        """
        Return graph for the transition (or output) function: {label:output}.
        For label's keys are used:
        - for inputs/outputs: original signals
        - for states of automata and LTS: ARG_MODEL_STATE/ARG_S_a_STATE/etc.
        """
        func_model = {}
        signals = set(list(self.inputs) + list(self.descr_by_output.keys()))

        for l in func_smt_lines:
            #            (get-value ((tau t0 true true)))
            l = l.replace('get-value', '').replace('(', '').replace(')', '')
            tokens = l.split()
            if tokens[0] != func_desc.name:
                continue

            values = [self._parse_value(str_v)
                      for str_v in tokens[1:]]  # the very first - func_name
            smt_args = func_desc.get_args_dict(values[:-1])

            args = dict((smt_unname_if_signal(var,signals),val)
                        for var,val in smt_args.items())

            func_model[Label(args)] = values[-1]
        return func_model

    def _parse_value(self, str_v):
        if not hasattr(self, 'node_by_smt_value'):  # aka static method of the field
            self.node_by_smt_value = dict()
            self.node_by_smt_value.update((smt_name_spec(s, TYPE_S_STATE), s)
                                          for s in self.safety_automaton.nodes)
            self.node_by_smt_value.update((smt_name_spec(s, TYPE_L_a_STATE), s)
                                          for s in self.L_a.nodes)
            self.node_by_smt_value.update((smt_name_spec(s, TYPE_L_g_STATE), s)
                                          for s in self.L_g.nodes)

        if str_v in self.node_by_smt_value:
            return self.node_by_smt_value[str_v]
        if str_v in ['false', 'true']:
            return str_v == 'true'
        return smt_unname_m(str_v)

    #
    #

    ############################### PARTIAL MODEL #################################
    def encode_model_solution(self, model:LTS, impl):  # TODO: no distributed case
        def to_bool(val:bool):
            return [self.solver.false(),
                    self.solver.true()][val]

        tau_model = impl.model_taus_descs[0]
        out_descs_dict = dict(map(lambda desc: (desc.name, desc), impl.outvar_desc_by_process[0].values()))

        for outvar_signal, labels_map in model.output_models.items():
            out_desc = out_descs_dict[outvar_signal]

            for args_dict, defined_bool_value in labels_map.items():
                defined_value = to_bool(defined_bool_value)

                computed_value = self.solver.call_func(out_desc, args_dict)

                condition = self.solver.op_eq(computed_value, defined_value)
                self.solver.assert_(condition)

        for args_dict, defined_next_state in model.tau_model.items():
            computed_next_state = self.solver.call_func(tau_model, args_dict)

            condition = self.solver.op_eq(computed_next_state, defined_next_state)
            self.solver.assert_(condition)

            # def _simplify_tau(self, tau_model:LabelsMap, tau_func_desc:FuncDescription, states) -> LabelsMap:
            #     tau_dict = dict()  # (t1,t2) -> labels
            #
            #     for (t1,t2) in product(states, repeat=2):
            #         labels = self._get_transitions(t1, t2, tau_model)
            #
            #         set_of_labels_wo_state = set()
            #         for lbl in labels:
            #             assert lbl['state'] == t2
            #
            #             lbl, _ = separate(lambda signal_value: signal_value[0] != 'state', lbl.items())
            #             set_of_labels_wo_state.add(lbl)
            #
            #         simplified_set = minimize_dnf_set(set_of_labels_wo_state)
            #         # notice that if the empty set then it is True
            #         tau_dict[(t1,t2)] = simplified_set
            #
            #     simplified_tau_model = LabelsMap()
            #     for ((t1,t2),labels) in tau_dict.items():
            #         for lbl in labels:
            #             # restore labels and add 'state'
            #             lbl['state'] = t1
            #             simplified_tau_model[lbl] = t2
            #
            #     return simplified_tau_model

            # def _get_transitions(self, t1, t2, tau_model:LabelsMap) -> Iterable:
            #     transitions = set()
            #     for (label,next_state) in tau_model.items():
            #         if label['state'] == t1 and next_state == t2:
            #             transitions.add(label)
            #     return transitions
