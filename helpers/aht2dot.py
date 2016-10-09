from collections import namedtuple
from typing import List
from typing import Set

from sympy import Symbol
from sympy.logic.boolalg import Or, And, Not, to_dnf
from sympy.logic.boolalg import true as sympy_true
from sympy.logic.boolalg import false as sympy_false

from helpers.expr_helper import get_sig_number
from helpers.python_ext import StrAwareList
from helpers.spec_helper import prop
from interfaces.aht_automaton import DstFormulaPropMgr, ExtLabel, SharedAHT, get_reachable_from, AHT
from interfaces.aht_automaton import Transition
from interfaces.expr import Expr, UnaryOp, Bool, BinOp, Number
from parsing.visitor import Visitor


def convert(aht:AHT or None, shared_aht:SharedAHT, dstFormPropMgr:DstFormulaPropMgr)\
        -> str:
    def _gen_unique_name(__=[]) -> str:  # mutable default arg is on purpose
        name = '__n' + str(len(__))
        __.append('')
        return name

    transitions = shared_aht.transitions if not aht \
        else get_reachable_from(aht.init_node, shared_aht.transitions, dstFormPropMgr)[1]

    all_nodes = set()  # Set[Node]
    trans_dot = StrAwareList()
    InvisNode = namedtuple('InvisNode', ['name', 'is_existential'])
    invis_nodes = set()  # type: Set['InvNode']
    for t in transitions:  # type: Transition
        all_nodes.add(t.src)

        inv_node = InvisNode(name=_gen_unique_name(),
                             is_existential=t.src.is_existential)
        invis_nodes.add(inv_node)

        trans_dot += '"{src}" -> "{invisible}" [label="{label}"];'.format(
            src=t.src.name, invisible=inv_node.name, label=_label_to_short_string(t.state_label))

        cubes = to_dnf_set(t.dst_expr)  # type: List[List[Expr]]

        colors = 'black blue purple green yellow orange red brown pink gray'.split()
        for cube in cubes:  # type: List[Expr]
            # each cube gets its own color
            color = colors.pop(0) if len(colors) else 'gray'
            for lit in cube:  # type: Expr
                assert lit.name == '=', "should be prop of the form sig=1; and not negated"
                dstFormProp = dstFormPropMgr.get_dst_form_prop(get_sig_number(lit)[0].name)

                trans_dot += '"{invisible}" -> "{dst}" [color={color}, label="{ext_label}"];'.format(
                    invisible=inv_node.name,
                    dst=dstFormProp.dst_state.name,
                    color=color,
                    ext_label=_ext_label_to_short_string(dstFormProp.ext_label))

                all_nodes.add(dstFormProp.dst_state)
    # end of 'for t in aht.transitions'

    invis_nodes_dot = ['{n} [label="DNF", shape=box, fontsize=6, style=rounded, margin=0, width=0.3, height=0.2];'
                           .format(n=n.name)
                       for n in invis_nodes]
    nodes_dot = '\n'.join(['"{n}" [color="{color}", shape="{shape}" {initial}];'
                               .format(n=n.name,
                                       color=('red', 'green')[n.is_existential],
                                       shape=('ellipse', 'doubleoctagon')[n.is_final],
                                       initial='' if n != (aht.init_node if aht else None) else ', style=filled, fillcolor=gray')
                           for n in all_nodes])

    dot_lines = StrAwareList() + 'digraph "automaton" {' + \
                'rankdir=LR;' + \
                (('label="%s"' % aht.name) if aht else '') + \
                nodes_dot + \
                trans_dot +\
                invis_nodes_dot +\
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
        res += '.'
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
