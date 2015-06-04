import logging
from itertools import product
import sys
from helpers.console_helpers import print_green

from helpers.labels_map import LabelsMap
from helpers.logging_helper import log_entrance
from helpers.python_ext import lmap
from interfaces.automata import Label, Automaton, LIVE_END, all_stimuli_that_satisfy, \
    get_next_states
from interfaces.lts import LTS
from interfaces.parser_expr import Signal
from interfaces.solver_interface import SolverInterface
from synthesis.func_description import FuncDescription
from synthesis.funcs_args_types_names import TYPE_MODEL_STATE, ARG_MODEL_STATE, ARG_S_a_STATE, ARG_S_g_STATE, \
    ARG_L_a_STATE, ARG_L_g_STATE, TYPE_S_a_STATE, TYPE_S_g_STATE, TYPE_L_a_STATE, TYPE_L_g_STATE, FUNC_REACH, FUNC_R, \
    smt_name_spec, smt_name_m, smt_name_free_arg, smt_arg_name_signal


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


class AssumeGuaranteeEncoder:
    def __init__(self,
                 logic,
                 S_a:Automaton,
                 S_g:Automaton,
                 L_a:Automaton,
                 L_g:Automaton,
                 underlying_solver:SolverInterface,
                 tau_desc:FuncDescription,
                 inputs,
                 descr_by_output,
                 model_init_state:int):  # the automata alphabet is inputs+outputs
        self.logger = logging.getLogger(__name__)

        self.solver = underlying_solver
        self.logic = logic

        self.S_a = S_a
        self.S_g = S_g
        self.L_a = L_a
        self.L_g = L_g

        self.inputs = inputs
        self.descr_by_output = descr_by_output
        self.tau_desc = tau_desc

        reach_args = {ARG_S_a_STATE: TYPE_S_a_STATE,
                      ARG_S_g_STATE: TYPE_S_g_STATE,
                      ARG_L_a_STATE: TYPE_L_a_STATE,
                      ARG_L_g_STATE: TYPE_L_g_STATE,
                      ARG_MODEL_STATE: TYPE_MODEL_STATE}

        r_args = reach_args

        self.reach_func_desc = FuncDescription(FUNC_REACH, reach_args, 'Bool', None)
        self.r_func_desc = FuncDescription(FUNC_R, r_args,
                                           logic.counters_type(sys.maxsize),
                                           None)

        #: :type: int
        self.model_init_state = model_init_state

        self.last_allowed_states = None

    def _smt_out(self, label:Label, smt_m:str, s_a, s_g, l_a, l_g) -> str:
        conjuncts = []

        args_dict = self._build_args_dict(smt_m, label, s_a, s_g, l_a, l_g)

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

    def _build_args_dict(self, smt_m:str, i_o, s_a, s_g, l_a, l_g) -> dict:
        args_dict = dict()
        args_dict[ARG_MODEL_STATE] = smt_m

        args_dict[ARG_S_a_STATE] = smt_name_spec(s_a, TYPE_S_a_STATE)
        args_dict[ARG_S_g_STATE] = smt_name_spec(s_g, TYPE_S_g_STATE)
        args_dict[ARG_L_a_STATE] = smt_name_spec(l_a, TYPE_L_a_STATE)
        args_dict[ARG_L_g_STATE] = smt_name_spec(l_g, TYPE_L_g_STATE)

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
        for (a, t) in [(self.S_a, TYPE_S_a_STATE),
                       (self.S_g, TYPE_S_g_STATE),
                       (self.L_a, TYPE_L_a_STATE),
                       (self.L_g, TYPE_L_g_STATE)]:
            self.solver.declare_enum(t,
                                     map(lambda n: smt_name_spec(n, t), a.nodes))

    def _encode_counters(self):
        self.solver.declare_fun(self.reach_func_desc)
        self.solver.declare_fun(self.r_func_desc)
    ##
    ##

    ## encoding rules
    def encode_initialization(self):
        for s_a, s_g, l_a, l_g, m in product(self.S_a.initial_nodes or [None],
                                             self.S_g.initial_nodes or [None],
                                             self.L_a.initial_nodes or [None],
                                             self.L_g.initial_nodes or [None],
                                             [self.model_init_state]):
            vals_by_vars = self._build_args_dict(smt_name_m(m), None, s_a, s_g, l_a, l_g)

            self.solver.assert_(
                self.solver.call_func(
                    self.reach_func_desc, vals_by_vars))

    def encode_run_graph(self, states_to_encode):
        # state_to_rejecting_scc = build_state_to_rejecting_scc(impl.automaton)  # TODO: Does it help?

        # One option is to encode automata directly into SMT and have a query like:
        #
        # forall (s_a, s_a'), (s_g, s_g'), (l_a, l_a'), (l_g, l_g'), (m, m'), i_o:
        # (s_a, i_o, s_a') \in edge(S_a) &
        # (s_g, i_o, s_g') \in edge(S_g) &
        # (l_a, i_o, l_a') \in edge(L_a) &
        # (l_g, i_o, l_g') \in edge(L_g) &
        # (tau(m,i) = m') & out(m,i,other_args) = o &
        # reach(s_a,s_g,l_a,l_g,m)
        # ->
        # reach(s_a',s_g',l_a',l_g',m') & r(...) >< r(...)
        #
        # This requires Z3 to optimize a lot
        # (e.g., to understand that only valid automata transitions should be considered)
        # But the plus is that the query is _very_ compact.
        # I don't know if Z3 capable of doing such optimization.
        #
        # Thus, instead we will construct a query like:
        #
        # forall s_a, s_g, l_a, l_g, m, (i_o,s_a') in edges(s_a):
        # out(..) = o &
        # reach(s_a,..,m)
        # ->
        # reach(..) & r(..) >< r(..)
        #
        # We will explicitly enumerate all i_o for a given label (of the edge),
        # and compute s_g', l_a', l_g' depending on i_o.
        # We will handle the special case when s_g' is the rejecting state.

        automata_alphabet = list(self.inputs) + list(self.descr_by_output.keys())

        for s_a, s_g, l_a, l_g, m in product(self.S_a.nodes or [LIVE_END],
                                             self.S_g.nodes or [LIVE_END],
                                             self.L_a.nodes or [LIVE_END],
                                             self.L_g.nodes or [LIVE_END],
                                             states_to_encode):

            self.solver.comment('encoding state: ' + str((s_a, s_g, l_a, l_g, m)) + '...')

            for label, dst_set_list in s_a.transitions.items():
                s_a_nexts = set(map(lambda node_flag: node_flag[0], dst_set_list[0]))

                for i_o in all_stimuli_that_satisfy(label, automata_alphabet):
                    s_g_nexts = get_next_states(s_g, i_o)
                    l_a_nexts = get_next_states(l_a, i_o)
                    l_g_nexts = get_next_states(l_g, i_o)

                    self._encode_transitions(s_a, s_g, l_a, l_g, m,
                                             i_o,
                                             s_a_nexts, s_g_nexts, l_a_nexts, l_g_nexts)

            self.solver.comment('encoded the state!')

    def _encode_transitions(self,
                            s_a, s_g, l_a, l_g, m:int,
                            i_o:Label,
                            s_a_nexts, s_g_nexts, l_a_nexts, l_g_nexts):

        assert len(l_a_nexts) == 1 and len(l_g_nexts) == 1, 'L_a and L_g must be deterministic'

        # syntax sugar
        smt_r = lambda args: self.solver.call_func(self.r_func_desc, args)
        smt_reach = lambda args: self.solver.call_func(self.reach_func_desc, args)
        #

        smt_m = smt_name_m(m)
        smt_out = self._smt_out(i_o, smt_m, s_a, s_g, l_a, l_g)

        args_dict = self._build_args_dict(smt_m, i_o, s_a, s_g, l_a, l_g)
        free_input_args = self._get_free_input_args(i_o)

        smt_pre = self.solver.op_and([smt_reach(args_dict), smt_out])

        # the case of next safety state is bad
        if not self.S_g.acc_nodes.isdisjoint(s_g_nexts):
            # aka reach(...) -> reach(..bad..) == \neg reach(...)
            self.solver.assert_(
                self.solver.forall_bool(free_input_args,
                                        self.solver.op_not(smt_pre)))
            return

        # the case of next safety state is 'normal'
        smt_m_next = self.solver.call_func(self.tau_desc, args_dict)

        smt_post_conjuncts = []
        for s_a_n, s_g_n, l_a_n, l_g_n in product(s_a_nexts, s_g_nexts, l_a_nexts, l_g_nexts):
            args_dict_next = self._build_args_dict(smt_m_next, None, s_a_n, s_g_n, l_a_n, l_g_n)
            smt_post_conjuncts.append(smt_reach(args_dict_next))

            if l_g_n not in self.L_g.acc_nodes:
                if l_a_n in self.L_a.acc_nodes:
                    op = self.solver.op_gt
                else:
                    op = self.solver.op_ge

                smt_post_conjuncts.append(op(smt_r(args_dict_next),
                                             smt_r(args_dict)))

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

        model = self.parse_sys_model(smt_lines)
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
                    TYPE_MODEL_STATE: [smt_name_m(m) for m in self.last_allowed_states],
                      TYPE_S_a_STATE: [smt_name_spec(s, TYPE_S_a_STATE) for s in self.S_a.nodes],
                      TYPE_S_g_STATE: [smt_name_spec(s, TYPE_S_g_STATE) for s in self.S_g.nodes],
                      TYPE_L_a_STATE: [smt_name_spec(s, TYPE_L_a_STATE) for s in self.L_a.nodes],
                      TYPE_L_g_STATE: [smt_name_spec(s, TYPE_L_g_STATE) for s in self.L_g.nodes]
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
    def parse_sys_model(self, smt_get_value_lines):  # TODO: depends on SMT format
        output_models = dict()
        for output_desc in self.descr_by_output.values():
            output_func_model = self._build_func_model_from_smt(smt_get_value_lines, output_desc)
            output_models[output_desc.name] = LabelsMap(output_func_model)

        init_states = list(product([self.model_init_state],
                                   self.S_a.initial_nodes,
                                   self.S_g.initial_nodes,
                                   self.L_a.initial_nodes,
                                   self.L_g.initial_nodes))

        tau_model = LabelsMap(self._build_func_model_from_smt(smt_get_value_lines, self.tau_desc))
        # tau_model = self._simplify_tau(tau_model, tau_func_desc, impl.states_by_process[0])

        lts = LTS(init_states,
                  output_models, tau_model,
                  ARG_MODEL_STATE,
                  self.inputs, list(self.descr_by_output.keys()))

        return lts

    def _build_func_model_from_smt(self, func_smt_lines, func_desc:FuncDescription) -> dict:
        """ Return transition(output) graph {label:output} """
        func_model = {}
        for l in func_smt_lines:
            #            (get-value ((tau t0 true true)))
            l = l.replace('get-value', '').replace('(', '').replace(')', '')
            tokens = l.split()
            if tokens[0] != func_desc.name:
                continue

            values = self._parse_values(tokens[1:])  # the very first - func_name
            args = Label(func_desc.get_args_dict(values[:-1]))
            func_model[args] = values[-1]
        return func_model

    def _parse_values(self, values):
        return [v == 'true' if v == 'true' or v == 'false'
                else v for v in values]
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
