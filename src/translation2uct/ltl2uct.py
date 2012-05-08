from helpers.shell import execute_shell
from interfaces.ltl_spec import LtlSpec
from interfaces.automata import Automaton
from translation2uct.ltl2ba import parse_ltl2ba_ba


class Ltl2Uct:
    def __init__(self, ltl2ba_path):
        self._execute_cmd = ltl2ba_path +' -f'


    def convert(self, ltl_spec):
        shifted_negated = self._shift_input(self._negate(ltl_spec))

        rc, ba, err = execute_shell('{0} "{1}"'.format(self._execute_cmd, shifted_negated.property))
        assert rc == 0, rc
        assert (err == '') or err is None, err

        initial_nodes, rejecting_nodes, nodes = parse_ltl2ba_ba(ba)

        return Automaton(initial_nodes, rejecting_nodes, nodes)


    def _shift_input(self, ltl_spec):
        property = ltl_spec.property
        for i in ltl_spec.inputs:
            property = property.replace(i, '(X{0})'.format(i))

        return LtlSpec(ltl_spec.inputs, ltl_spec.outputs, property)


    def _negate(self, ltl_spec):
        return LtlSpec(ltl_spec.inputs, ltl_spec.outputs, '!({0})'.format(ltl_spec.property))
