from functools import lru_cache
from typing import Dict
from typing import Set

from interfaces.automata import Label
from interfaces.expr import Expr, UnaryOp, BinOp, Bool, Number
from interfaces.expr import Signal
from parsing.visitor import Visitor


class Transition:
    def __init__(self, src:str, state_label:Label, dst_expr:Expr):
        self.src = src
        self.state_label = state_label
        self.dst_expr = dst_expr

    def __eq__(self, other):
        if not isinstance(other, Transition):
            return False
        return self.src == other.src and \
               self.state_label == other.state_label and \
               self.dst_expr == other.dst_expr

    def __hash__(self, *args, **kwargs):
        return hash(self.src) + hash(self.state_label) + hash(self.dst_expr)

    def __str__(self):
        return 'src: "%s", state_label: "%s", dst_expr: "%s"' % \
               (self.src, str(self.state_label), str(self.dst_expr))
# end of Transition

# class AHT:
#     """ Alternating hesitant tree automaton """
#     def __init__(self,
#                  init_node:       str,
#                  final_nodes:     Set[str],
#                  transitions:     Set[Transition]):
#         self.init_node = init_node
#         self.final_nodes = final_nodes
#         self.transitions = transitions
#
#     def __str__(self):
#         return "init_node: '%s', final_nodes: '%s', transitions: '%s'" % \
#                tuple(map(str, [self.init_node, self.final_nodes,
#                                ', '.join(map(str, self.transitions))]))
# end of AHT


Node = str   # Node is not a class -- it is an alias to str
AHT = Node   # AHT is not a class -- it is an alias to Node


class AtmRecord:
    def __init__(self):
        self.init_node = None  # type: Node
        self.transitions = set()  # type: Set[Transition]


class SharedAHT:
    def __init__(self):
        self.automata = dict()          # type: Dict[str, Node]
        self.transitions = set()        # type: Set[Transition]
        self.universal_nodes = set()    # type: Set[Node]
        self.final_nodes = set()        # type: Set[Node]


class ExtLabel:
    FORALL, EXISTS = 'forall', 'exists'

    def __init__(self,
                 fixed_inputs:  Label,
                 free_inputs:   Set[Signal],
                 type_:         str):
        self.fixed_inputs = fixed_inputs
        self.free_inputs = free_inputs
        for fi in self.free_inputs:
            assert isinstance(fi, Signal)
        self.type_ = type_

    def dual(self):
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
    def __init__(self, ext_label:ExtLabel, dst_state:str):
        self.ext_label = ext_label
        self.dst_state = dst_state

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

    def get_dst_expr_prop(self, sig_name:str) -> DstFormulaProp:
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
        dst_form_prop = self.dstFormPropManager.get_dst_expr_prop(signal.name)
        # To dualize a proposition, dualize:
        # 1. ext_label
        # 2. dst_name
        # We need (2) since the dual automaton has dualized state names.
        dual_dst_form_prop = DstFormulaProp(dst_form_prop.ext_label.dual(),
                                            _dualize_state_name(dst_form_prop.dst_state))
        dual_signal = Signal(self.dstFormPropManager.get_add_signal_name(dual_dst_form_prop))
        return dual_signal
# end of Dualizer


class RenamerVisitor(Visitor):
    def __init__(self, mapper):
        self.mapper = mapper

    def visit_signal(self, signal:Signal):
        assert 0, "wrong since propositions are tuples"
        return super().visit_signal(Signal(self.mapper(signal.name)))
# end of Renamer


def _dualize_state_name(name):
    return name[1:] if name.startswith('~')\
        else '~' + name


@lru_cache()
def dualize_aht(aht:AHT, dstFormPropManager:DstFormulaPropMgr) -> AHT:
    new_init_node = _dualize_state_name(aht.init_node)
    new_final_nodes = set(map(_dualize_state_name, aht.final_nodes))

    new_transitions = set(map(lambda t: Transition(_dualize_state_name(t.src),
                                                   Label(t.state_label),
                                                   DualizerVisitor(dstFormPropManager).dispatch(t.dst_expr)),
                               aht.transitions))

    return AHT(new_init_node, new_final_nodes, new_transitions)
