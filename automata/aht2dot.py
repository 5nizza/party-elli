from collections import namedtuple
from typing import List
from typing import Set

from helpers.expr_helper import get_sig_number
from helpers.expr_to_dnf import to_dnf_set
from helpers.python_ext import StrAwareList
from interfaces.AHT_automaton import DstFormulaPropMgr, ExtLabel, SharedAHT, get_reachable_from, AHT
from interfaces.AHT_automaton import Transition
from interfaces.expr import Expr, BinOp


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
            for lit in cube:  # type: BinOp
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
