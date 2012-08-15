import argparse
import logging
import sys
from helpers.main_helper import setup_logging, create_spec_converter_z3
from helpers.automata_helper import  is_safety_automaton
from module_generation.dot import to_dot
from parsing.en_rings_parser import is_parametrized, SCHED_ID_PREFIX, SENDS_NAME, ACTIVE_NAME, add_concretize_fair_sched, get_par_io, is_local_property, concretize_property, get_tok_rings_liveness_par_props, get_cutoff_size, HAS_TOK_NAME, SENDS_PREV_NAME, anonymize_property, parametrize_anon_var
from parsing.parser import parse_ltl
from synthesis.par_model_searcher_compositional import search
from translation2uct.ltl2automaton import get_solid_property


def _is_safety_property(property, automaton_converter):
    #no need to negate
    automaton = automaton_converter.convert(property)
    is_safety = is_safety_automaton(automaton)

    return is_safety


def _separate_properties(automaton_converter, props):
    safety_props = list(filter(lambda p: _is_safety_property(p, automaton_converter), props))
    liveness_props = list(set(props).difference(safety_props))
    return safety_props, liveness_props


def main(ltl_file, dot_files_prefix, bounds, cutoff, automaton_converter, solver, logger):
    raw_ltl_spec = parse_ltl(ltl_file.read())

    assert is_parametrized(raw_ltl_spec)

    #TODO: is such a separation valid?
    loc_props = list(filter(lambda p: is_local_property(p), raw_ltl_spec.properties))
    glob_props = list(filter(lambda p: p not in loc_props, raw_ltl_spec.properties))

    logger.debug('local properties:%s', '\n'+'\n'.join(loc_props))
    logger.debug('global properties:%s', '\n'+'\n'.join(glob_props))

    par_inputs, par_outputs = get_par_io(raw_ltl_spec)

    local_automaton = None
    if loc_props:
        safety_props, liveness_props = _separate_properties(automaton_converter, loc_props)

        logger.debug('safety local props: \n%s', safety_props)
        logger.debug('liveness local props: \n%s', liveness_props)

        #local_safety G(tok-> not sends_prev) is on SMT level

        local_fairness = 'GF{prev}'.format_map({'prev':parametrize_anon_var(SENDS_PREV_NAME)})
        fair_liveness_prop = '({assmpt}) -> ({original})'.format_map({'assmpt': local_fairness,
                                                                      'original': get_solid_property(liveness_props)})

        #TODO: move on SMT level
        tok_ring_props = get_tok_rings_liveness_par_props()

        all_local_props = safety_props + [fair_liveness_prop] + tok_ring_props

        all_anon_vars = par_inputs + par_outputs + [ACTIVE_NAME]
        anon_loc_prop = anonymize_property(get_solid_property(all_local_props), all_anon_vars)

        local_automaton = automaton_converter.convert(anon_loc_prop)
        logger.info('local automaton has %i states', len(local_automaton.nodes))


    global_automaton = None
    nof_processes = 1
    if glob_props:
        safety_glob_props, liveness_glob_props = _separate_properties(automaton_converter, glob_props)
        logger.debug('safety global props: \n%s', safety_glob_props)
        logger.debug('liveness global props: \n%s', liveness_glob_props)

        nof_processes = cutoff if cutoff else get_cutoff_size(get_solid_property(liveness_glob_props+safety_glob_props))

        concrt_safety_props = []
        if safety_glob_props:
            concrt_safety_props = [concretize_property(get_solid_property(safety_glob_props), nof_processes)]

        fair_concrt_liveness_props = []
        if liveness_glob_props:
            fair_concrt_liveness_props = [add_concretize_fair_sched(liveness_glob_props, nof_processes)]

        full_concr_props = concrt_safety_props + fair_concrt_liveness_props

        global_automaton = automaton_converter.convert(get_solid_property(full_concr_props))

        logger.info('global automaton has %i states', len(global_automaton.nodes))
        logger.info('full_concr_props is %s', full_concr_props)


    logger.info('using the cutoff of size %i', nof_processes)


    models = search(local_automaton, global_automaton, par_inputs, par_outputs,
        nof_processes,
        bounds,
        solver, SCHED_ID_PREFIX, ACTIVE_NAME, SENDS_NAME, HAS_TOK_NAME, SENDS_PREV_NAME)

    logger.info('model%s found', ['', ' not'][models is None])

    if dot_files_prefix is not None and models is not None:
        for i, lts in enumerate(models):
            with open(dot_files_prefix + str(i) + '.dot', mode='w') as out:
                dot = to_dot(lts)
                out.write(dot)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Parametrized Synthesis Tool for token rings architecture')
    parser.add_argument('ltl', metavar='ltl', type=argparse.FileType(),
        help='loads the LTL formula from the given input file')
    parser.add_argument('--dot', metavar='dot', type=str, required=False,
        help='writes the output into a dot graph files prefixed with this prefix')
    parser.add_argument('--bound', metavar='bound', type=int, default=2, required=False,
        help='upper bound on the size of local process (default: %(default)i)')
    parser.add_argument('--size', metavar='size', type=int, default=None, required=False,
        help='exact size of the process implementation(default: %(default)i)')
    parser.add_argument('--cutoff', metavar='cutoff', type=int, default=None, required=False,
        help='force specified cutoff size')
    parser.add_argument('-v', '--verbose', action='count', default=0)

    args = parser.parse_args(sys.argv[1:])

    setup_logging(args.verbose)

    ltl2ucw_converter, z3solver = create_spec_converter_z3(False)

    bounds = list(range(1, args.bound + 1) if args.size is None else range(args.size, args.size + 1))

    main(args.ltl, args.dot, bounds, args.cutoff, ltl2ucw_converter, z3solver, logging.getLogger(__name__))

    args.ltl.close()
