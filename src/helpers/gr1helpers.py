from interfaces.expr import Expr


def build_weak_gr1_formula(a_init:Expr, g_init:Expr,  # TODO: rename into a_init, etc.
                           a_safety:Expr, g_safety:Expr,
                           a_liveness:Expr, g_liveness:Expr) -> Expr:
    """
    NOTE that a_safety and g_safety are _safety_ formulas and not transition formulas
    (thus, they are of the form G(..))
    """

    init_expr = -a_init | g_init
    safety_implication = -a_init | -a_safety | g_safety
    liveness_expr = -(a_init & a_safety & a_liveness) | g_liveness

    return init_expr & safety_implication & liveness_expr
