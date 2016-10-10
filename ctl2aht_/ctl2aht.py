from itertools import combinations
from typing import Dict, Tuple, Set, Iterable, List

from helpers.expr_helper import get_signal_names, Normalizer, get_sig_number
from helpers.nbw_automata_helper import common_label
from helpers.normalizer import normalize_nbw_inplace, normalize_aht_transitions
from helpers.python_ext import lfilter
from helpers.spec_helper import prop
from interfaces import automata
from interfaces.aht_automaton import AHT, dualize_aht, Transition, ExtLabel, DstFormulaProp, DstFormulaPropMgr, \
    SharedAHT, Node
from interfaces.automata import Automaton as NBW, Label
from interfaces.expr import Expr, Signal, UnaryOp, BinOp
from interfaces.spec import Spec
from ltl3ba.ltl2automaton import LTL3BA
from parsing.visitor import Visitor


def is_state_formula(formula:Expr, inputs:Iterable[Signal]) -> bool:
    class PathFormulaDetector(Visitor):
        def __init__(self, inputs_:Iterable[Signal]):
            self.inputs = inputs_
            self.is_path_detected = False

        def visit_unary_op(self, unary_op:UnaryOp):
            assert unary_op.name in 'GFX!AE', str(unary_op)

            if unary_op.name in 'GFX':
                self.is_path_detected = True

            return unary_op

        def visit_binary_op(self, binary_op:BinOp):
            assert binary_op.name in 'URW*+=', str(binary_op)

            if binary_op.name in '*+':
                return super().visit_binary_op(binary_op)  # inspect arguments

            if binary_op.name in 'URW':
                self.is_path_detected = True

            if binary_op.name == '=' and get_sig_number(binary_op)[0] in self.inputs:
                self.is_path_detected = True

            return binary_op
    # end of PathFormulaDetector

    detector = PathFormulaDetector(inputs)
    detector.dispatch(formula)
    return not detector.is_path_detected


def nbw_to_nbt(nbw:NBW,
               inputs:Set[Signal],
               shared_aht:SharedAHT, dst_form_prop_mgr:DstFormulaPropMgr)\
        -> AHT:
    # 1. create transitions
    aht_transitions = set()
    for n in nbw.nodes:  # type: automata.Node
        for (l, dst_acc_pairs) in n.transitions.items():
            l_inputs = Label((s, l[s])
                             for s in l.keys() & inputs)
            l_outputs = Label((s, l[s])
                              for s in l.keys() - inputs)
            for (dst_state, _) in dst_acc_pairs:  # type: Tuple[automata.Node, bool]
                ext_label = ExtLabel(l_inputs,
                                     inputs - l_inputs.keys(),
                                     ExtLabel.EXISTS)
                dst_formula_prop = DstFormulaProp(ext_label,
                                                  Node(dst_state.name,
                                                       True,
                                                       dst_state in nbw.acc_nodes))

                # We introduce auxiliary signals for propositions '(ext_label, dst_state)'
                # and later work with boolean expressions over such signals
                # Here the boolean expression is simply 'aux_sig_name = 1'
                aux_sig_name = dst_form_prop_mgr.get_add_signal_name(dst_formula_prop)
                expr = prop(aux_sig_name)

                t = Transition(Node(n.name, True, n in nbw.acc_nodes),
                               l_outputs,
                               expr)
                aht_transitions.add(t)
        # end of for (n.transitions)
    # end of for (nbw.nodes)

    shared_aht.transitions.update(aht_transitions)

    assert len(nbw.initial_nodes) == 1
    nbw_init_node = list(nbw.initial_nodes)[0]
    aht_init_node = Node(nbw_init_node.name, True, nbw_init_node in nbw.acc_nodes)
    aht = AHT(aht_init_node, 'E(%s)' % nbw.name)
    return aht


def assert_no_name_collisions(formula:Expr, prefix_to_try:str):
    for n in get_signal_names(formula):
        assert prefix_to_try not in n, str(n)


def replace_top_AEs(formula:Expr) -> (Tuple[Tuple[Expr, Expr]], Expr):
    """
    :return: (new_proposition, formula) pairs,
             top formula with newly introduced propositions.
             Only the top A/E formulas are replaced --
             e.g., AG(EG(g & AFG(~r))) will be replaced by `AG(prop)`,
                   where `prop = EG(g & AFG(~r))`  (!note `AFG(~r)` is not replaced)
             NB: all introduced propositions refer to formulas of the form E(phi)
                 (no 'A's)
    """
    class ReplacerVisitor(Visitor):
        def __init__(self, new_props_prefix:str):
            self.last = 0
            self.new_prop_by_expr = dict()  # type: Dict[Expr, Expr]
            self.new_props_prefix = new_props_prefix

        def _get_add_new_prop(self, unary_op:UnaryOp) -> Expr:
            assert unary_op.name == 'E', str(unary_op)
            # Check if we already introduced a proposition for this expression.
            # It is sound to introduce different propositions
            # for equivalent expressions, but it increases the automaton
            # (we will have equivalent sub-automata).
            if unary_op not in self.new_prop_by_expr:
                new_prop_name = self.gen_new_name()
                self.new_prop_by_expr[unary_op] = prop(new_prop_name)
            return self.new_prop_by_expr[unary_op]

        def gen_new_name(self) -> str:
            self.last += 1
            return self.new_props_prefix + str(self.last)

        def visit_unary_op(self, unary_op: UnaryOp):
            if unary_op.name == 'E':
                return self._get_add_new_prop(unary_op)
            if unary_op.name == 'A':
                # if see `A(phi)`, then introduce proposition for `E~phi`,
                # and return ~proposition
                neg_arg = Normalizer().dispatch(~unary_op.arg)
                prop_for_neg = self._get_add_new_prop(UnaryOp('E', neg_arg))
                return ~prop_for_neg
            return super().visit_unary_op(unary_op)
        #
    # end of ReplacerVisitor

    prop_prefix = 'oxouv'  # FIXME: better name!
    assert_no_name_collisions(formula, prop_prefix)

    replacer = ReplacerVisitor(prop_prefix)
    new_f = replacer.dispatch(formula)
    return tuple(map(lambda e_p: (e_p[1],e_p[0]), replacer.new_prop_by_expr.items())),\
           new_f


def is_ltl_formula(f_with_props) -> bool:
    class AEFinder(Visitor):
        def __init__(self):
            self.is_found = False

        def visit_unary_op(self, unary_op: UnaryOp):
            if unary_op.name in 'AE':
                self.is_found = True
            return super().visit_unary_op(unary_op)
    # end of AEFinder
    finder = AEFinder()
    finder.dispatch(f_with_props)
    return not finder.is_found


def _assert_no_label_intersections_in_node(node_transitions:Iterable[Transition]):
    """
    Checks that there exists no state that has two transitions with 'intersecting' state labels.
    """
    n_labels = map(lambda t: t.state_label, node_transitions)
    for l1,l2 in combinations(n_labels, 2):  # type: Tuple[Label, Label]
        l1_l2 = common_label(l1, l2)
        assert l1_l2 is None, \
            "Transition labels should not intersect, but I found two intersecting labels: \n" + \
            str(l1_l2)


def intersect_transition_with_aux_aht_init_transitions(transition:Transition,
                                                       aux_sig:Signal,
                                                       aux_aht:AHT,
                                                       shared_aht:SharedAHT,
                                                       dstFormPropMgr:DstFormulaPropMgr)\
                                                       -> Set[Transition]:
    if aux_sig not in transition.state_label:
        return [transition]

    assert transition.src.is_existential,\
        "we never adapt alphabet of universal automata"  # the func is exec for uni trans, but it returns above

    p_aht = aux_aht if transition.state_label[aux_sig] else \
        dualize_aht(aux_aht, shared_aht, dstFormPropMgr)

    p_init_transitions = filter(lambda t: t.src == p_aht.init_node, shared_aht.transitions)
    p_relevant_init_transitions = lfilter(lambda p_t: None != common_label(transition.state_label, p_t.state_label),
                                          p_init_transitions)

    # NB: |p_relevant_init_transitions| > 1 is possible, but they all have different labels
    #     (thus, q-[g:True]->q' and q-[g:True,c:False]->q'' is not possible)
    #     (i.e., non-det/univ transitions is expressed via Transition::dst_expr)

    if not p_relevant_init_transitions:
        # We might get empty `p_relevant_init_transitions`, e.g.:
        # (non-det automaton):
        # a --[e,g]--> b
        # and universal automaton for `e` has only:
        # x --[!g]--> y
        # But actually the last means:
        # x --[!g]--> y
        #   --[ g]--> true
        # and hence we can keep the original transition.
        # In general, when `p_relevant_init_transitions` is empty:
        # (NB: we adapt alphabet of NBTs only)
        #    - if `p_aht` is universal, then `new_transition = orig_transition & true`  (stays the same)
        #    -      ...   is non-deter, then `new_transition = orig_transition & false` (thus, should be removed)
        if not p_aht.init_node.is_existential:  # p_aht is UCT
            new_trans_label = Label(transition.state_label)
            del new_trans_label[aux_sig]
            # transition stays almost unchanged,
            # except signal(p) is removed from `state_label`
            return [Transition(transition.src, new_trans_label, transition.dst_expr)]
        else:
            # p_aht is NBT -- transition is removed
            return []

    transition_label = Label(transition.state_label)
    del transition_label[aux_sig]

    p_induced_transitions = []
    for p_t in p_relevant_init_transitions:
        new_label = common_label(transition_label, p_t.state_label)

        new_dst = transition.dst_expr & p_t.dst_expr

        new_t = Transition(transition.src, new_label, new_dst)
        p_induced_transitions.append(new_t)

    return p_induced_transitions


def adapt_alphabet(aht_by_p:Dict[Expr, AHT],
                   shared_aht:SharedAHT,
                   dstFormPropMgr:DstFormulaPropMgr):
    """
    :pre: all automata are 'normalized' (no two transitions can fire simultaneously)
          (namely, normalization step assumes this)
    :param aht_by_p: must be: AHT by 'positive' proposition (signal=1)
    """

    all_aux_signals = set(map(lambda e: get_sig_number(e)[0], aht_by_p.keys()))
    if not all_aux_signals:  # to avoid disappearing of transitions
        return

    transitions = shared_aht.transitions
    nodes = set(map(lambda t: t.src, transitions))

    for n in nodes:
        n_transitions = lfilter(lambda t: t.src == n, transitions)
        n_orig_transitions = n_transitions  # save original transitions -- later we replace them with newly generated
        for aux_sig in all_aux_signals:
            n_new_transitions = list()  # type: List[Transition]
            for t in n_transitions:
                t_new_transitions = intersect_transition_with_aux_aht_init_transitions(t,
                                                                                       aux_sig,
                                                                                       aht_by_p[prop(aux_sig.name)],  # TODO: ugly prop call
                                                                                       shared_aht, dstFormPropMgr)
                n_new_transitions.extend(t_new_transitions)
            n_transitions = n_new_transitions  # we extended one aux_sig -- the next is extended on new transitions

        normalized_n_new_transitions = normalize_aht_transitions(n_transitions)
        _assert_no_label_intersections_in_node(normalized_n_new_transitions)

        transitions.difference_update(n_orig_transitions)
        transitions.update(normalized_n_new_transitions)

        # NB1: we need normalization, since different `aux_sig` can produce intersecting transitions:
        #        q --[e]-->..
        #        q --[i]-->..
        #        e --[g]-->..
        #        i --[g]-->..
        #      And we will get two transitions with `g` from state `q`

        # NB2: For the result to be correct,
        #      all automata (before rm aux signals) should be normalized
        #      (since we AND:
        #         new_transitions = t1 & _t1, t1 & _t2, ...
        #       and if some universal _t is fractured into several components _tA, _tB
        #       (but should be _t = _tA & _tB),
        #       then we would get `t1 & _tA OR t1 & _tB` instead of `t1 & _tA & _tB`)
        #      )
    # end of `for n in nodes`
# end of adapt_alphabet


def ctl2aht(spec:Spec,
            ltl2ba:LTL3BA,
            shared_aht:SharedAHT,
            dstFormPropMgr:DstFormulaPropMgr,
            _uniq=[])\
        -> AHT:
    """
    Assumes that spec.formula is in the normalized form
    """

    _un_index = len(_uniq)
    _uniq.append('')  # to generate unique prefix names

    assert is_state_formula(spec.formula, spec.inputs), str(spec.formula)

    if spec.formula.name == 'A':
        neg_spec = Spec(spec.inputs, spec.outputs, Normalizer().dispatch(~spec.formula))
        neg_aht = ctl2aht(neg_spec, ltl2ba, shared_aht, dstFormPropMgr)
        return dualize_aht(neg_aht, shared_aht, dstFormPropMgr)

    if spec.formula.name == 'E':
        f = spec.formula.arg
    else:  # non-quantified state formula
        f = spec.formula

    prop_f_pairs, f_with_props = replace_top_AEs(f)

    # We first create AHTs for sub-formulas.
    # NB: we must do this before call `nbw_to_nbt`,
    #     since `adapt_alphabet` goes over _all_ edges.
    aht_by_p = dict()  # type: Dict[Expr, AHT]
    for p,f in prop_f_pairs:
        aht_by_p[p] = ctl2aht(Spec(spec.inputs, spec.outputs, f),
                              ltl2ba,
                              shared_aht,
                              dstFormPropMgr)

    assert is_ltl_formula(f_with_props), str(f_with_props)

    nbw = ltl2ba.convert(f_with_props, 'n%i_' % _un_index)
    normalize_nbw_inplace(nbw)  # FIXME: SSA -- should be nbw = normalize_nbw(nbw)

    aht = nbw_to_nbt(nbw, spec.inputs, shared_aht, dstFormPropMgr)

    adapt_alphabet(aht_by_p, shared_aht, dstFormPropMgr)  # FIXME: SSA -- should be `aht = adapt_alphabet(aht)`

    # assert that no alien propositions are mentioned
    for t in shared_aht.transitions:  # type: Transition
        assert t.state_label.keys() <= (spec.inputs | spec.outputs), \
               "invariant violation: " + str(t.state_label.keys())

    return aht
