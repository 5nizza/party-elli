import logging
from functools import reduce
from itertools import chain
from math import ceil, log
from pprint import pprint, pformat
from typing import List, Tuple, Dict

from CTL_to_LTL_.ctl_atomizer import CTLAtomizerVisitor
from helpers.spec_helper import G, prop2
from interfaces.LTL_to_automaton import LTLToAutomaton
from interfaces.expr import Expr, Signal, Bool, BinOp, Number
from interfaces.spec import Spec
from parsing.visitor import Visitor


SignalsTuple = Tuple[Signal]


def conjunction(iterable) -> Expr:
    return reduce(lambda x,y: x&y, iterable, Bool(True))


def create_LTL_for_A_formula(p:Expr, path_formula:Expr) -> Expr:
    return G(p >> path_formula)


def create_LTL_for_E_formula(v_bits:SignalsTuple,  # v_bits[0] will correspond to j_bits[0] (left-most bit)
                             path_formula:Expr,
                             d:Dict[int,SignalsTuple],
                             ordered_inputs:Tuple[Signal]) -> Expr:
    # TODO: what if we |v_bits| = 3 but not all bit valuations are used?
    # We create the conjunction:
    # for each j:
    #   G[ v=j -> (Gd_j -> path_formula) ]
    #
    # How to specify v=j?
    # - v should be represented by bits
    # - convert j into binary
    # - conjunct (v[i] == j_bits[i]) for each bit
    #
    # How to specify d_j?
    # - each d_j is represented by bits
    # - d_j actually means (d_j[in1], d_j[in2], ..., d_j[inK])
    # - then d_j is the conjunction "for each inK: d_j[inK]==inK"
    result = Bool(True)
    nof_IDs = len(d)
    for j in range(1,nof_IDs+1):
        v_eq_j = make_v_eq_j(j, v_bits)
        d_j_expr = conjunction([(prop2(d[j][idx])>>prop2(inp)) &
                                (prop2(d[j][idx])<<prop2(inp))
                                for idx,inp in enumerate(ordered_inputs)])
        result &= G(v_eq_j >> (G(d_j_expr) >> path_formula))
    return result


def make_v_eq_j(j:int, v_bits:SignalsTuple) -> Expr:
    j_bits = '0' * (len(v_bits) - len(bin(j)[2:])) + bin(j)[2:]
    v_eq_j = conjunction([BinOp('=', v_bits[idx], Number(1)) if j_bit=='1' else ~BinOp('=', v_bits[idx], Number(1))
                          for idx, j_bit in enumerate(j_bits)])
    return v_eq_j


def _replace_exist_propositions(ltl_formula:Expr,
                                v_bits_by_exist_p:Dict[BinOp,SignalsTuple],
                                nof_IDs:int) -> Expr:
    class Replacer(Visitor):
        def visit_binary_op(self, binary_op:BinOp):
            if binary_op.name != '=' or binary_op not in v_bits_by_exist_p:
                return super().visit_binary_op(binary_op)
            return reduce(lambda x,y: x|y,
                          [make_v_eq_j(j, v_bits_by_exist_p[binary_op]) for j in range(1,nof_IDs+1)])
    return Replacer().dispatch(ltl_formula)


def convert(spec:Spec,
            nof_IDs:int or None,
            ltl_to_atm:LTLToAutomaton) -> Spec:
    # (E.g. EG¬g ∧ AGEF¬g ∧ EFg)
    # The algorithm is:
    #   collect all E-subformulas
    #   for each unique E-subformula:
    #     introduce new v-variable if not yet introduced
    #   if nof_IDs is not given:
    #     nof_IDs = the number of states in all existential automata
    #     # nof_IDs defines the range of every v-variable
    #   introduce nof_IDs d-variables (each is a valuation of all inputs)
    #   for each unique A-subformula:
    #     introduce p-variable
    #   for each unique E-subformula:
    #     create an LTL formula         (1)
    #   for each unique A-subformula:
    #     create an LTL formula         (2)
    #   create the top-level formula    (3)
    #   create the conjunction (1) & (2) & (3)
    #   replace in the conjunction existential propositions by 'v != 0'.

    atomizer = CTLAtomizerVisitor('__p')
    top_formula = atomizer.dispatch(spec.formula)

    exist_props = [p for (p,f) in atomizer.f_by_p.items() if f.name == 'E']

    if nof_IDs is None:
        atm_by_exist_p = dict((p, ltl_to_atm.convert(atomizer.f_by_p[p].arg, '__q_'+p.arg1.name))
                              for p in exist_props)
        nof_IDs = sum(len(atm.nodes) for atm in atm_by_exist_p.values())

    v_bits_by_exist_p = dict((p, tuple(reversed([Signal('__v%s_%i'%(p.arg1.name.replace('_',''),i))
                                                 for i in range(ceil(log(nof_IDs+1, 2)) or 1)]))  # NB: +1 to account for 0
                              )
                             for p in exist_props)
    ordered_inputs = tuple(spec.inputs)
    dTuple_by_id = dict((j, tuple(Signal('__d%i_%s'%(j,i)) for i in ordered_inputs))
                        for j in range(1, nof_IDs+1))

    ltl_formula = top_formula
    ltl_formula &= conjunction(create_LTL_for_E_formula(v_bits_by_exist_p[p],
                                                        atomizer.f_by_p[p].arg,
                                                        dTuple_by_id,
                                                        ordered_inputs)
                               for p in exist_props)
    ltl_formula &= conjunction(create_LTL_for_A_formula(p, atomizer.f_by_p[p].arg)
                               for p in set(atomizer.f_by_p)-set(exist_props))
    ltl_formula = _replace_exist_propositions(ltl_formula, v_bits_by_exist_p, nof_IDs)

    logging.debug("exist propositions: \n%s", pformat([ep.arg1 for ep in v_bits_by_exist_p]))

    new_outputs = list(chain(*v_bits_by_exist_p.values())) + \
                  list(chain(*dTuple_by_id.values())) + \
                  [p.arg1 for p in (atomizer.f_by_p.keys() - set(exist_props))]

    return Spec(spec.inputs,
                set(new_outputs) | spec.outputs,
                ltl_formula)





























