import math
import itertools
from helpers.python_ext import bin_fixed_list
from interfaces.spec import Spec


SCHED_ID_PREFIX = 'sch'
ACTIVE_NAME_PREFIX = 'active'
SENDS_NAME, SENDS_PREV_NAME, HAS_TOK_NAME = 'sends_', 'sends_prev_', 'has_tok_'


def _concretize_var(par_var, process_index):
    return par_var[:-1]+ str(process_index)


def concretize(par_variables, process_index): #TODO: repetitions
    concretized_vars = [_concretize_var(i, process_index) for i in par_variables]

    return concretized_vars


def parametrize(concrete_variable):
    assert concrete_variable[-2] not in '1234567890', 'no support for > 9 processes'
    proc_index = int(concrete_variable[-1])

    par_value = concrete_variable[:-1] + '_'

    return par_value, proc_index


def _instantiate_i(ltl_property, nof_processes):
    props_list = ['({0})'.format(ltl_property.replace('_i', str(i)))
                  for i in range(nof_processes)]
    new_prop = ' && '.join(props_list)
    return new_prop


def _instantiate_ii1(ltl_property, nof_processes):
    new_prop = ltl_property.replace('_i1', '1').replace('_i', '0')
    return new_prop


def _instantiate_ij(ltl_property, nof_processes):
    props_list = ['({0})'.format(ltl_property.replace('_i', '0').replace('_j', str(j)))
                  for j in range(1, nof_processes)]
    new_prop = ' && '.join(props_list)
    return new_prop


def _instantiate_ii1j(ltl_property, nof_processes):
    props_list = ['({0})'.format(ltl_property.replace('_i1', '1').replace('_i', '0').replace('_j', str(j)))
                  for j in range(1, nof_processes)]
    new_prop = ' && '.join(props_list)
    return new_prop


def concretize_property(ltl_property, nof_processes):
    handlers = {'i':_instantiate_i,
                'i i+1':_instantiate_ii1,
                'i j':_instantiate_ij,
                'i i+1 j':_instantiate_ii1j}

    spec_type = _get_spec_type(ltl_property)

    return handlers[spec_type](ltl_property, nof_processes)


def is_parametrized(ltl_spec):
    ltl_property = ltl_spec.property
    return '_i' in ltl_property\
           or '_j' in ltl_property\
    or '_i1' in ltl_property


def get_fair_scheduler_property(nof_processes, sched_id_prefix, sends_prefix):
    nof_sched_bits = int(math.ceil(math.log(nof_processes, 2)))

    sched_constraints = []
    for i in range(nof_processes):
        bits = [int(b) for b in bin_fixed_list(i, nof_sched_bits)]
        id_as_formula = ' && '.join(['{0}{1}{2}'.format(['!', ''][bit_value], sched_id_prefix, bit_index)
                                     for bit_index, bit_value in enumerate(bits)])

        sched_constraints.append('GF({0})'.format(id_as_formula))

    return ' && '.join(sched_constraints)


def get_tok_ring_par_io():
    return [SENDS_PREV_NAME], [SENDS_NAME, HAS_TOK_NAME]


def get_tok_ring_concr_properties(nof_processes):
    tok_dont_disappear = 'G(({tok}i && !{sends}i) -> X{tok}i)'.format_map({'sends': SENDS_NAME,
                                                                           'tok': HAS_TOK_NAME})

    sends_with_token_only = "G({sends}i -> {tok}i)".format_map({'sends':SENDS_NAME,
                                                                'tok':HAS_TOK_NAME})

    sends_means_release = "G(({active}i && {sends}i) -> X({tok}i1 && !{tok}i))".format_map({'sends':SENDS_NAME,
                                                                                              'tok':HAS_TOK_NAME,
                                                                                              'active':ACTIVE_NAME_PREFIX+'_'})

    par_safety_property = '{0} && {1} && {2}'.format(sends_with_token_only,
        sends_means_release,
        tok_dont_disappear)

    concr_global_property = concretize_property(par_safety_property, nof_processes)

    init_tok_distr = ' && '.join([_concretize_var(HAS_TOK_NAME, 0)] +
                                 ['(!{0})'.format(_concretize_var(HAS_TOK_NAME, i)) for i in range(1, nof_processes)])

    #liveness, requires fair scheduling
    concr_finally_release_tok = concretize_property("G({tok}i -> F{sends}i)".format_map(
            {'sends':SENDS_NAME,
             'tok':HAS_TOK_NAME}),
        nof_processes)

    return '({0}) && ({1})'.format(init_tok_distr, concr_global_property), concr_finally_release_tok


def _get_spec_type(ltl_property):
    """ Return one of the spec type: 'i', 'i i+1', 'i j', 'i i+1 j' """

    assert '_i' in ltl_property, ltl_property

    type = 'i'
    if '_i1' in ltl_property:
        type += ' i+1'
    if '_j' in ltl_property:
        type += ' j'

    return type


def get_cutoff_size(ltl_property):
    spec_type = _get_spec_type(ltl_property)
    return {'i':2, 'i i+1':3, 'i j':4, 'i i+1 j':5}[spec_type]