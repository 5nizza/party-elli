from helpers.shell import execute_shell
from interfaces.ltl_spec import LtlSpec
from interfaces.uct import UCT
from translation2uct.ltl2ba import parse_ltl2ba_output


def _shift_input(ltl_spec):
    property = ltl_spec.property
    for i in ltl_spec.inputs:
        property = property.replace(i, '(X{0})'.format(i))

    return LtlSpec(ltl_spec.inputs, ltl_spec.outputs, property)


def _negate(ltl_spec):
    return LtlSpec(ltl_spec.inputs, ltl_spec.outputs, '!({0})'.format(ltl_spec.property))


def ltl2uct(ltl_spec, ltl2ba_path):
    shifted_negated = _shift_input(_negate(ltl_spec))

    rc, ba, err = execute_shell('{0} "{1}"'.format(ltl2ba_path +' -f', shifted_negated.property))
    assert rc == 0, rc
    assert (err == '') or err is None, err

    initial_nodes, nodes = parse_ltl2ba_output(ba)

    return UCT(initial_nodes, nodes)
