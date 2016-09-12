from itertools import chain
from typing import Dict, Tuple, Set, Iterable

from helpers.expr_helper import get_names, Normalizer, get_sig_number
from helpers.python_ext import lfilter, to_str
from helpers.spec_helper import prop
from interfaces.aht_automaton import AHT, dualize_aht, Transition, ExtLabel, DstFormulaProp, DstFormulaPropMgr
from interfaces.automata import Automaton as NBW, Label
from interfaces.expr import Expr, Signal, UnaryOp, BinOp
from interfaces.spec import Spec
from ltl3ba.ltl2automaton import LTL3BA
from parsing.visitor import Visitor


def is_state_formula(formula:Expr, inputs:Iterable[Signal]):
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
            assert binary_op.name in 'URW*+', str(binary_op)

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


def nbw_to_nbt(nbw:NBW, inputs:Set[Signal], dst_form_prop_manager:DstFormulaPropMgr) -> AHT:
    aht_nodes = set(n.name for n in nbw.nodes)
    assert len(nbw.initial_nodes) == 1, "more than one is not supported"
    aht_init_node = list(nbw.initial_nodes)[0].name
    aht_final_nodes = set(map(lambda n: n.name, nbw.acc_nodes))

    aht_transitions = set()
    for n in nbw.nodes:
        for (l, dst_acc_pairs) in n.transitions.items():
            l_inputs = Label((s, l[s])
                             for s in set(l.keys()).intersection(inputs))
            l_outputs = Label((s, l[s])
                              for s in set(l.keys()).difference(inputs))
            for (dst_state, _) in dst_acc_pairs:
                ext_label = ExtLabel(l_inputs,
                                     inputs.difference(set(l_inputs.keys())),
                                     ExtLabel.EXISTS)
                dst_formula_prop = DstFormulaProp(ext_label, dst_state.name)

                # we introduce auxiliary signals for propositions '(ext_label, dst_state)'
                # and later work with boolean expressions over such signals
                # Here the boolean expression is simply 'aux_sig_name = 1'
                aux_sig_name = dst_form_prop_manager.get_add_signal_name(dst_formula_prop)
                expr = prop(aux_sig_name)

                t = Transition(n.name, l_outputs, expr)
                aht_transitions.add(t)

    aht = AHT(aht_init_node, aht_final_nodes, aht_transitions)
    return aht


def assert_no_name_collisions(formula, prefix_to_try:str):
    for n in get_names(formula):
        assert prefix_to_try not in n, str(n)


def replace_ae(formula:Expr) -> (Tuple[Tuple[Expr, Expr]], Expr):
    """
    :return: (new_proposition, formula) pairs,
             top formula with newly introduced propositions
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

    prop_prefix = 'oxouv'  # TODO: better name?
    assert_no_name_collisions(formula, prop_prefix)

    replacer = ReplacerVisitor(prop_prefix)
    new_f = replacer.dispatch(formula)
    return tuple(map(lambda e_p: (e_p[1],e_p[0]), replacer.new_prop_by_expr.items())),\
           new_f


def is_ltl_formula(f_with_props):
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


def _get_used_alien_props(nbt:AHT, all_alien_props:Iterable[Expr]) -> Iterable[Expr]:
    aht_label_signals = set(chain(*[t.state_label.keys() for t in nbt.transitions]))
    aht_label_props = set(prop(s.name) for s in aht_label_signals)
    return aht_label_props.intersection(set(all_alien_props))


def adapt_alphabet(nbt:AHT, aht_by_p:Dict[Expr, AHT], dstFormPropManager, transMgr:Set[Transition]) -> AHT:
    """
    :param aht_by_p: must be: AHT by 'positive' proposition (signal=1)
    :return _PARTIAL_ AHT, the resulting automaton does not unwind sub-automata transitions
            except transitions from the initial state.
            Thus:
            - you need to complete the transitions!
            - you need to complete the states:
              the resulting AHT states are original states
              plus only _some_ states of sub-automata
              (those activated by transitions from the init states of sub-automata)
    """
    new_transitions = set()
    for t in nbt.transitions:
        print()
        print(t)
        t_new_transitions = adapt_alphabet_for_transition(t, aht_by_p, dstFormPropManager)
        print(to_str(t_new_transitions))
        new_transitions.update(t_new_transitions)

    alien_props_seen = _get_used_alien_props(nbt, set(aht_by_p.keys()))

    new_final_nodes = set(nbt.final_nodes)
    new_final_nodes.update(chain(*[aht_by_p[p].final_nodes for p in alien_props_seen]))

    result_aht = AHT(nbt.init_node,
                     new_final_nodes,
                     new_transitions)

    return result_aht


def _common_props(state_label:Label, props:Iterable[Expr]) -> Set[Expr]:
    result = set()
    prop_signals = set(map(lambda p: get_sig_number(p)[0], props))
    for sig in state_label:  # type: Signal
        if sig in prop_signals:
            result.add(prop(sig.name))
    return result


def _occurs_positive(proposition:Expr, state_label:Label) -> bool:
    prop_sig = get_sig_number(proposition)[0]

    assert prop_sig in state_label, "'{%s}' does not occur in '{%s}'" %\
                                    (str(proposition), str(state_label))

    return state_label[prop_sig]


def adapt_alphabet_for_transition(transition:Transition,
                                  aht_by_p:Dict[Expr, AHT],
                                  dstFormPropManager) -> Iterable[Transition]:
    props_to_adapt = _common_props(transition.state_label, aht_by_p.keys())

    if not props_to_adapt:
        return [transition]

    # 1. Pick one alien proposition and adapt the transition wrt. it
    # 2. Then call myself recursively for newly created transitions

    # 1. Build new transitions as a result of removing alien proposition p
    p = props_to_adapt.pop()

    p_aht = aht_by_p[p] if _occurs_positive(p, transition.state_label) else \
            dualize_aht(aht_by_p[p], dstFormPropManager)

    p_init_transitions = filter(lambda p_t: p_t.src == p_aht.init_node,
                                p_aht.transitions)
    p_relevant_init_transitions = lfilter(lambda p_t: is_non_empty_intersection(transition.state_label, p_t.state_label),
                                          p_init_transitions)

    assert p_relevant_init_transitions, "For every o |= t.state_label, " \
                                        "there must be at least one transition satisfying o " \
                                        "from the init state of 'aux' AHT (p_aht)"

    p_induced_transitions = list()
    for p_t in p_relevant_init_transitions:
        label_and = Label(transition.state_label)
        del label_and[get_sig_number(p)[0]]
        label_and = intersection(label_and, p_t.state_label)

        dst_and = transition.dst_expr & p_t.dst_expr

        t_and = Transition(transition.src, label_and, dst_and)
        p_induced_transitions.append(t_and)

    # 2. Adapt each newly generated transition.
    #    (It does not contain the `p` but may contain other alien propositions.)
    new_transitions = list()
    for t in p_induced_transitions:
        new_transitions.extend(adapt_alphabet_for_transition(t,
                                                             aht_by_p,
                                                             dstFormPropManager))
    return new_transitions


def is_non_empty_intersection(base_label, l):
    for k in base_label:
        if k in l and l[k] != base_label[k]:
            return False
    return True


def intersection(base_label, l):
    assert is_non_empty_intersection(base_label, l), str(base_label) + ' & ' + str(l)

    new_dict = dict(base_label)
    new_dict.update(l)
    return Label(new_dict)


def ctl2aht(spec:Spec,
            ltl2ba:LTL3BA,
            dst_form_prop_mgr:DstFormulaPropMgr,
            shared_aht:SharedAHT,
            _uniq=[]) -> AHT:
    """
    Assumes that spec.formula is in the normalized form
    """

    _uniq.append('')  # to generate unique prefix names

    assert is_state_formula(spec.formula, spec.inputs), str(spec.formula)

    if spec.formula.name == 'A':
        neg_spec = Spec(spec.inputs, spec.outputs, Normalizer().dispatch(~spec.formula))
        neg_aht = ctl2aht(neg_spec, ltl2ba, dst_form_prop_mgr)
        return dualize_aht(neg_aht)

    if spec.formula.name == 'E':
        f = spec.formula.arg
    else:  # non-quantified state formula
        f = spec.formula

    prop_f_pairs, f_with_props = replace_ae(f)

    assert is_ltl_formula(f_with_props), str(f_with_props)

    nbw = ltl2ba.convert(f_with_props, 'n%i_'%len(_uniq))  # todo: do not create automaton for f, if it was already created

    nbt = nbw_to_nbt(nbw, spec.inputs, dst_form_prop_mgr)

    aht_by_p = dict()
    for p,f in prop_f_pairs:
        aht_by_p[p] = ctl2aht(Spec(spec.inputs, spec.outputs, f),
                              ltl2ba,
                              dst_form_prop_mgr)

    aht = adapt_alphabet(nbt, aht_by_p, dst_form_prop_mgr)

    # assert that no alien propositions should be mentioned
    for t in aht.transitions:  # type: Transition
        assert set(t.state_label.keys()).issubset(list(spec.inputs) + list(spec.outputs)), \
               "invariant violation"

    # complete the automaton
    # current

    return aht
