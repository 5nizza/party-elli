from typing import List

from sympy import Symbol
from sympy.logic.boolalg import Or, And, Not, to_dnf
from sympy.logic.boolalg import true as sympy_true
from sympy.logic.boolalg import false as sympy_false

from helpers.expr_helper import get_sig_number
from helpers.python_ext import StrAwareList
from helpers.spec_helper import prop
from interfaces.aht_automaton import DstFormulaPropMgr, ExtLabel, SharedAHT
from interfaces.aht_automaton import Transition
from interfaces.expr import Expr, UnaryOp, Bool, BinOp, Number
from parsing.visitor import Visitor


def convert(shared_aht:SharedAHT, dstFormPropMgr:DstFormulaPropMgr)\
        -> str:
    def _gen_unique_name(__=[]) -> str:  # mutable default arg is on purpose
        name = '__n' + str(len(__))
        __.append('')
        return name

    final_nodes = set()  # Set[Node]
    exist_nodes = set()  # Set[Node]

    trans_dot = StrAwareList()
    inv_nodes = set()
    for t in shared_aht.transitions:  # type: Transition
        inv_node = _gen_unique_name()
        inv_nodes.add(inv_node)

        trans_dot += '"{src}" -> "{invisible}" [label="{label}"];'.format(
            src=str(t.src), invisible=inv_node, label=_label_to_short_string(t.state_label))

        cubes = to_dnf_set(t.dst_expr)  # type: List[List[Expr]]

        colors = 'black purple green yellow blue orange red brown pink gray'.split()
        for cube in cubes:  # type: List[Expr]
            # each cube gets its own color
            color = colors.pop(0) if len(colors) else 'gray'
            for lit in cube:  # type: Expr
                assert lit.name == '=', "should be prop of the form sig=1; and not negated"
                dstFormProp = dstFormPropMgr.get_dst_expr_prop(get_sig_number(lit)[0].name)

                trans_dot += '"{invisible}" -> "{dst}" [color={color}, label="{ext_label}"];'.format(
                    invisible=inv_node,
                    dst=str(dstFormProp.dst_state),
                    color=color,
                    ext_label=_ext_label_to_short_string(dstFormProp.ext_label))

                dst_state = dstFormProp.dst_state
                if dst_state.is_final:
                    final_nodes.add(dst_state)
                if dst_state.is_existential:
                    exist_nodes.add(dst_state)
    # end of 'for t in aht.transitions'

    inv_nodes_dot = ['{n} [shape=point];'.format(n=n) for n in inv_nodes]
    final_nodes_dot = '\n'.join(['"{0}" [shape=doubleoctagon];'.format(n)
                                 for n in final_nodes])
    # TODO: mark exist states

    dot_lines = StrAwareList() + 'digraph "automaton" {' + \
                'rankdir=LR;' + \
                final_nodes_dot + '\n' + \
                trans_dot +\
                inv_nodes_dot +\
                '}'

    return '\n'.join(dot_lines)


def to_dnf_set(dst_expr:Expr) -> List[List[Expr]]:
    class SympyConverter(Visitor):
        def visit_binary_op(self, binary_op:BinOp):
            assert binary_op.name in '*+=', str(binary_op)
            if binary_op.name == '=':
                sig, num = get_sig_number(binary_op)
                assert num == Number(1), str(num)
                sympy_prop = Symbol(sig.name)
                return sympy_prop

            if binary_op.name == '*':
                return self.dispatch(binary_op.arg1) & self.dispatch(binary_op.arg2)

            if binary_op.name == '+':
                return self.dispatch(binary_op.arg1) | self.dispatch(binary_op.arg2)

        def visit_bool(self, bool_const:Bool):
            return (sympy_false, sympy_true)[bool_const==Bool(True)]

        def visit_unary_op(self, unary_op:UnaryOp):
            assert unary_op.name == '!', str(unary_op)
            return ~self.dispatch(unary_op.arg)
    # end of SympyConverter
    sympy_dst_expr = SympyConverter().dispatch(dst_expr)
    dnf_sympy_dst_expr = to_dnf(sympy_dst_expr, simplify=True)
    cubes = _get_cubes(dnf_sympy_dst_expr)
    cubes_list = []
    for cube in cubes:
        literals = _get_literals(cube)
        props_list = []
        for l in literals:
            if isinstance(l, Not):
                props_list.append(~prop(str(l.args[0])))   # it should print its name..
            else:
                props_list.append(prop(str(l)))  # it should print its name..
        cubes_list.append(props_list)
    return cubes_list


def _label_to_short_string(label):
    if len(label) == 0:
        return '1'

    short_string = '.'.join(map(lambda var_val: ['!',''][var_val[1]] + str(var_val[0]), label.items()))
    return short_string


def _ext_label_to_short_string(el:ExtLabel) -> str:
    res = ''
    if el.fixed_inputs:
        res += _label_to_short_string(el.fixed_inputs)
    if el.free_inputs:
        res += "{Q}({free})".format(Q={el.FORALL:'A', el.EXISTS:'E'}[el.type_],
                                    free=','.join(map(str, el.free_inputs)))
    return res


def _get_cubes(dnf_expr) -> tuple:
    if isinstance(dnf_expr, Or):
        return dnf_expr.args
    return dnf_expr,


def _get_literals(expr) -> tuple:
    if isinstance(expr, Or) or isinstance(expr, And):
        return expr.args
    assert isinstance(expr, (Not, Symbol)), str(expr.__class__)
    return expr,  # tuple
