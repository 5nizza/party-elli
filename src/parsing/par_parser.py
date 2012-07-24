import itertools
from interfaces.ltl_spec import LtlSpec


def _instantiate_input_output(ltl_spec, nof_times):
    instantiated_input = set()
    instantiated_output = set()

    for i in range(nof_times):
        instantiated_input.update(set([input.replace('_i', str(i))
                                       for input in ltl_spec.inputs]))

        instantiated_output.update(set([output.replace('_i', str(i))
                                       for output in ltl_spec.outputs]))

    return instantiated_input, instantiated_output


def _instantiate_i(ltl_property):
    new_prop = ltl_property.replace('_i', '')
    return 1, new_prop


def _instantiate_ii1(ltl_property):
    new_prop = ltl_property.replace('_i1', '1').replace('_i', '0')
    return 3, new_prop


def _instantiate_ij(ltl_property):
    props_list = ['({0})'.format(ltl_property.replace('_i', '0').replace('_j', str(j)))
                  for j in range(1, 4)]
    new_prop = ' && '.join(props_list)
    return 4, new_prop


def _instantiate_ii1j(ltl_property):
    props_list = ['({0})'.format(ltl_property.replace('_i1', '1').replace('_i', '0').replace('_j', str(j)))\
                  for j in range(1, 5)]
    new_prop = ' && '.join(props_list)
    return 5, new_prop


def _get_spec_type(ltl_property):
    """ Return one of the spec type: 'i', 'i i+1', 'i j', 'i i+1 j' """

    assert '_i' in ltl_property, ltl_property

    type = 'i'
    if '_i1' in ltl_property:
        type += ' i+1'
    if '_j' in ltl_property:
        type += ' j'

    return type


def is_parameterized(ltl_property):
    return '_i' in ltl_property\
           or '_j' in ltl_property\
           or '_i1' in ltl_property


def reduce_par_ltl(ltl_spec):
    """ Return (min_size, instantiated LtlSpec) """

    handlers = {'i':_instantiate_i,
                'i i+1':_instantiate_ii1,
                'i j':_instantiate_ij,
                'i i+1 j':_instantiate_ii1j}

    spec_type = _get_spec_type(ltl_spec.property)

    size, inst_ltl_property = handlers[spec_type](ltl_spec.property)

    inst_in, inst_out = _instantiate_input_output(ltl_spec, size)

    inst_ltl_spec = LtlSpec(inst_in, inst_out, inst_ltl_property)

    return size, inst_ltl_spec


def build_reduced_spec(proc_inputs, proc_outputs, property, nof_processes):
    """ Return the spec of the system as a whole """

    system_inputs = list(itertools.product(proc_inputs, range(nof_processes)))
    system_outputs = list(itertools.product(proc_outputs, range(nof_processes)))

    return LtlSpec(system_inputs, system_outputs, property)
