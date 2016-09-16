import logging

from typing import List

from helpers.expr_helper import and_expr
from interfaces.expr import Expr, UnaryOp, BinOp
from ltl3ba.ast_to_ltl3ba import ConverterToLtl2BaFormatVisitor


def strengthen1(a_inits:List[Expr], g_inits:List[Expr],
                a_safeties:List[Expr], g_safeties:List[Expr],
                a_livenesses:List[Expr], g_livenesses:List[Expr]) \
               -> Expr:
    """
    PRE: a_safeties and g_safeties are iterable of _safety_ formulas and not transition formulas
    (thus, they are of the form G(..))
    """
    a_init = and_expr(a_inits)
    g_init = and_expr(g_inits)
    a_safety = and_expr(a_safeties)
    g_safety = and_expr(g_safeties)
    a_liveness = and_expr(a_livenesses)
    g_liveness = and_expr(g_livenesses)

    init_expr = a_init >> g_init
    safety_implication = (a_init & a_safety) >> g_safety
    liveness_expr = (a_init & a_safety & a_liveness) >> g_liveness

    return init_expr & safety_implication & liveness_expr


def strengthen2(a_inits:List[Expr], g_inits:List[Expr],
                a_safeties:List[Expr], g_safeties:List[Expr],
                a_livenesses:List[Expr], g_livenesses:List[Expr]) \
               -> Expr:
    """
    Assumes input expressions are not weirdos.
    Splits safety into two types (+init):
    formulas of the form G(..) and others.
    :return: conjunction of:
    init -> init
    init & non_G_safety -> (g_state W !a_state)
    init & non_G_safety & G(state) -> non_G_safety
    init & orig_safety & liveness -> liveness
    """
    # TODO: init are classified as non_state, _as_should_be4_correctness, but may be better way
    a_init = and_expr(a_inits)
    g_init = and_expr(g_inits)

    a_state = and_expr(map(lambda e: e.arg, filter(lambda e: e.name=='G', a_safeties)))
    g_state = and_expr(map(lambda e: e.arg, filter(lambda e: e.name=='G', g_safeties)))
    a_non_state = and_expr(filter(lambda e: e.name!='G', a_safeties))
    g_non_state = and_expr(filter(lambda e: e.name!='G', g_safeties))

    safety_init = a_init >> g_init
    safety_weak = (a_init & a_non_state) >> BinOp.W(g_state, ~a_state)
    safety_other = (a_init & a_non_state & UnaryOp.G(a_state)) >> g_non_state

    a_liveness = and_expr(a_livenesses)
    g_liveness = and_expr(g_livenesses)

    liveness = (a_init & a_non_state & UnaryOp.G(a_state) & a_liveness) >> g_liveness

    logging.debug('a_state: ' + str(ConverterToLtl2BaFormatVisitor().dispatch(a_state)))
    logging.debug('g_state: ' + str(g_state))
    logging.debug('a_non_state: ' + str(a_non_state))
    logging.debug('g_non_state: ' + str(g_non_state))
    logging.debug('a_liveness: ' + str(a_liveness))
    logging.debug('g_liveness: ' + str(g_liveness))

    return safety_init & safety_weak & safety_other & liveness















