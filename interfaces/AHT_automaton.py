import logging
from typing import Set, Iterable, Tuple

from interfaces.automaton import Label
from interfaces.expr import Expr, UnaryOp, BinOp, Bool, Number
from interfaces.expr import Signal
from parsing.visitor import Visitor


class Node:
    def __init__(self, name:str, is_existential:bool, is_final:bool):
        self.name = name                        # type: str
        self.is_existential = is_existential    # type: bool
        self.is_final = is_final                # type: bool

    def __eq__(self, other):
        if not isinstance(other, Node):
            return False
        return other.name == self.name and \
               other.is_existential == self.is_existential and \
               other.is_final == self.is_final

    def __hash__(self, *args, **kwargs):
        return hash(self.name) + self.is_final + self.is_existential

    def __str__(self):
        return "'%s' (%s,%s)" %\
               (self.name, ('uni', 'exi')[self.is_existential], ('nor', 'fin')[self.is_final])
# end of Node


class Transition:
    def __init__(self, src:Node, state_label:Label, dst_expr:Expr):
        self.src = src
        self.state_label = state_label  # TODO: use Expr for this
        self.dst_expr = dst_expr

    def __eq__(self, other):
        if not isinstance(other, Transition):
            return False
        return self.src == other.src and \
               self.state_label == other.state_label and \
               self.dst_expr == other.dst_expr

    def __hash__(self):
        return hash(self.src) + hash(self.state_label) + hash(self.dst_expr)

    def __str__(self):
        return 'src: "%s", state_label: "%s", dst_expr: "%s"' % \
               (self.src, str(self.state_label), str(self.dst_expr))

    __repr__ = __str__
# end of Transition


class AHT:
    def __init__(self, init_node:Node, name:str=None):
        self.init_node = init_node  # type: Node
        self.name = name            # type: str

    def __str__(self):
        return "AHT '%s' with init_node: '%s'" % (self.name or 'unnamed', self.init_node)

    def __eq__(self, other):
        if other is None:
            return False
        assert issubclass(other.__class__, AHT), str(other.__class__)
        return str(self) == str(other)

    def __hash__(self):
        return hash(str(self))


class SharedAHT:
    def __init__(self):
        # self.automata = set()           # type: Set[AHT]
        self.transitions = set()        # type: Set[Transition]


class ExtLabel:
    FORALL, EXISTS = 'forall', 'exists'

    def __init__(self,
                 fixed_inputs:  Label,
                 free_inputs:   Set[Signal],
                 type_:         str):
        self.fixed_inputs = fixed_inputs   # type: Label
        self.free_inputs = free_inputs     # type: Set[Signal]
        for fi in self.free_inputs:
            assert isinstance(fi, Signal)
        self.type_ = type_

    def dual(self) -> 'ExtLabel':
        return ExtLabel(self.fixed_inputs,
                        self.free_inputs,
                        (ExtLabel.FORALL, ExtLabel.EXISTS)[self.type_ == ExtLabel.FORALL])

    def __eq__(self, other):
        assert 0, 'implement me'

    def __hash__(self):
        assert 0, 'implement me'

    def __str__(self):
        res = ''
        if self.fixed_inputs:
            res += str(self.fixed_inputs)
        if self.free_inputs:
            res += "{Q}({free})".format(Q={self.FORALL:'A', self.EXISTS:'E'}[self.type_],
                                        free=','.join(map(str, self.free_inputs)))
        return res
# end of ExtLabel


class DstFormulaProp:
    def __init__(self, ext_label:ExtLabel, dst_state:Node):
        self.ext_label = ext_label  # type: ExtLabel
        self.dst_state = dst_state  # type: Node

    def __str__(self):
        return '({e}, {q})'.format(e=str(self.ext_label), q=str(self.dst_state))
# end of DstFormulaProp


class DstFormulaPropMgr:
    """
    NB Class does not ensure that these signal names are not present in the original AHT.
       But such name collisions are OK, since we (should) never use them on the same 'level'.
    """
    def __init__(self):
        self.__dstFormulaProp_by_sigName = dict()
        self.__sigName_by_dstFormulaProp = dict()

    def get_add_signal_name(self, dst_formula:DstFormulaProp) -> str:
        if dst_formula not in self.__sigName_by_dstFormulaProp:
            name = self._gen_name(dst_formula)
            self.__sigName_by_dstFormulaProp[dst_formula] = name
            self.__dstFormulaProp_by_sigName[name] = dst_formula

        return self.__sigName_by_dstFormulaProp[dst_formula]

    def get_dst_form_prop(self, sig_name:str) -> DstFormulaProp:
        return self.__dstFormulaProp_by_sigName[sig_name]

    def _gen_name(self, dst_formula:DstFormulaProp) -> str:
        return str(dst_formula)  # no requirements on uniqueness, stability, etc.
# end of class DstFormulaPropManager


class DualizerVisitor(Visitor):
    def __init__(self, dstFormPropManager:DstFormulaPropMgr):
        self.dstFormPropManager = dstFormPropManager

    def visit_unary_op(self, unary_op:UnaryOp):
        assert 0, "should never happen (i think it should!)"

    def visit_binary_op(self, binary_op:BinOp):
        if binary_op.name == '=':
            return BinOp('=',
                         self.dispatch(binary_op.arg1),
                         self.dispatch(binary_op.arg2))

        dual_op_name = '*+'[binary_op.name == '*']
        return BinOp(dual_op_name,
                     self.dispatch(binary_op.arg1), self.dispatch(binary_op.arg2))

    def visit_number(self, number:Number):
        assert number == Number(1), str(number)
        return super().visit_number(number)

    def visit_bool(self, bool_:Bool):
        return Bool(bool_ == Bool(False))

    def visit_signal(self, signal:Signal):
        dst_form_prop = self.dstFormPropManager.get_dst_form_prop(signal.name)
        # To dualize a proposition, dualize:
        # 1. ext_label
        # 2. dst_name
        # We need (2) since the dual automaton has dualized state names.
        dual_dst_form_prop = DstFormulaProp(dst_form_prop.ext_label.dual(),
                                            _dualize_node(dst_form_prop.dst_state))
        dual_signal = Signal(self.dstFormPropManager.get_add_signal_name(dual_dst_form_prop))
        return dual_signal
# end of Dualizer


class NodesCollector(Visitor):
    def __init__(self, dstPropFormMgr:DstFormulaPropMgr):
        self.dstPropFormMgr = dstPropFormMgr
        self.nodes = set()  # type: Set[Node]

    def visit_signal(self, signal:Signal):
        dstFormulaProp = self.dstPropFormMgr.get_dst_form_prop(signal.name)
        self.nodes.add(dstFormulaProp.dst_state)
        return super().visit_signal(signal)


def _dualize_state_name(name) -> str:
    return name[1:] if name.startswith('~')\
        else '~' + name


def _dualize_node(node:Node) -> Node:
    return Node(_dualize_state_name(node.name), not node.is_existential, node.is_final)


def get_dst_nodes(dstPropFormMgr:DstFormulaPropMgr, transition:Transition) -> Set[Node]:
    nc = NodesCollector(dstPropFormMgr)
    nc.dispatch(transition.dst_expr)
    return nc.nodes


def get_reachable_from(node:Node,
                       transitions:Iterable[Transition],
                       dstPropFormMgr:DstFormulaPropMgr)\
        -> Tuple[Set[Node], Set[Transition]]:
    # ~|transitions * nodes|
    reachable_transitions = set()   # type: Set[Transition]
    reachable_nodes = {node}        # type: Set[Node]
    while 1:
        has_changed = False

        for t in transitions:  # type: Transition
            if t.src in reachable_nodes:
                candidates = get_dst_nodes(dstPropFormMgr, t)
                has_changed |= len(candidates.difference(reachable_nodes)) > 0
                reachable_nodes.update(candidates)
                reachable_transitions.add(t)

        if not has_changed:
            break

    return reachable_nodes, reachable_transitions


def dualize_aht(aht:AHT,
                shared_aht:SharedAHT,
                dstFormPropMgr:DstFormulaPropMgr)\
        -> AHT:

    logging.info('dualize_aht: %s' % aht.init_node)

    aht_nodes, aht_transitions = get_reachable_from(aht.init_node,
                                                    shared_aht.transitions, dstFormPropMgr)
    for t in aht_transitions:
        shared_aht.transitions.add(Transition(_dualize_node(t.src),
                                              Label(t.state_label),
                                              DualizerVisitor(dstFormPropMgr).dispatch(t.dst_expr)))

    new_init_node = _dualize_node(aht.init_node)
    dual_aht = AHT(new_init_node, '~' + aht.name)

    return dual_aht
