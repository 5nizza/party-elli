from interfaces.expr import Expr, OpG, OpU, Bool


def weak_until(a:Expr, b:Expr) -> Expr:
    return OpU(a, b) | OpG(-b)


def convert_into_gr1_formula(S_a_init:Expr, S_g_init:Expr,  # TODO: rename into a_init, etc.
                             S_a_trans:Expr, S_g_trans:Expr,
                             L_a_property:Expr, L_g_property:Expr) -> Expr:

    if S_a_init is None:
        S_a_init = Bool(True)
    if S_g_init is None:
        S_g_init = Bool(True)
    if S_a_trans is None:
        S_a_trans = Bool(True)
    if S_g_trans is None:
        S_g_trans = Bool(True)
    if L_a_property is None:
        L_a_property = Bool(True)

    init_expr = -S_a_init | S_g_init
    safety_expr = -S_a_init | weak_until(S_g_trans, -S_a_trans)
    liveness_expr = -(S_a_init & OpG(S_a_trans) & L_a_property) | L_g_property

    return init_expr & safety_expr & liveness_expr
