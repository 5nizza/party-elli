import argparse
import logging
import sys
from helpers.main_helper import setup_logging, create_spec_converter_z3
from interfaces.spec import Spec
from module_generation.dot import to_dot
from parsing.en_rings_parser import is_parametrized, SCHED_ID_PREFIX, SENDS_NAME, ACTIVE_NAME_PREFIX, add_concretize_fair_sched, get_par_io, is_local_property, concretize_property, get_par_tok_ring_safety_props, get_tok_rings_liveness_par_props, get_cutoff_size, HAS_TOK_NAME, SENDS_PREV_NAME
from parsing.parser import parse_ltl
from synthesis.par_model_searcher_compositional import search
from translation2uct.ltl2automaton import get_solid_property


def main(ltl_file, dot_files_prefix, bounds, automaton_converter, solver, logger):
    raw_ltl_spec = parse_ltl(ltl_file.read())

    assert is_parametrized(raw_ltl_spec)

    #TODO: assumed that a fairness doesn't play a role in local properties..
    all_props = raw_ltl_spec.properties + get_par_tok_ring_safety_props() + \
                get_tok_rings_liveness_par_props()

    #TODO: Current: move all rings properties on the SMT level!

    loc_props = list(filter(lambda p: is_local_property(p), all_props))
    glob_props = list(filter(lambda p: p not in loc_props, all_props))
#    logger.debug('local properties:%s', '\n'+'\n'.join(loc_props))
#    logger.debug('global properties:%s', '\n'+'\n'.join(glob_props))

    par_inputs, par_outputs = get_par_io(raw_ltl_spec)

    local_automaton = None
    if loc_props:
        concrt_loc_prop = concretize_property(get_solid_property(loc_props), 1)
        local_automaton = automaton_converter.convert(Spec(par_inputs, par_outputs, [concrt_loc_prop]))
        logger.info('local automaton has %i states', len(local_automaton.nodes))

    global_automaton = None
    nof_processes = 1
    if glob_props:
        #TODO: check for safety property first
        full_concr_prop = add_concretize_fair_sched(glob_props)
        global_automaton = automaton_converter.convert(Spec(par_inputs, par_outputs, [full_concr_prop]))
        logger.info('global automaton has %i states', len(global_automaton.nodes))
        nof_processes = get_cutoff_size(get_solid_property(glob_props))
#    logger.debug('concr property:\n' + full_concr_prop)
#    logger.info('cutoff of size %i', nof_processes)
#    logger.debug('par_inputs %s, par_outputs %s', str(par_inputs), str(par_outputs))

    models = search(local_automaton, global_automaton, par_inputs, par_outputs,
        nof_processes,
        bounds,
        solver, SCHED_ID_PREFIX, ACTIVE_NAME_PREFIX, SENDS_NAME, HAS_TOK_NAME, SENDS_PREV_NAME)

    logger.info('model %s found', ['', 'not'][models is None])

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
    parser.add_argument('-v', '--verbose', action='count', default=0)

    args = parser.parse_args(sys.argv[1:])

    setup_logging(args.verbose)

    ltl2ucw_converter, z3solver = create_spec_converter_z3(False)

    bounds = list(range(1, args.bound + 1) if args.size is None else range(args.size, args.size + 1))

    main(args.ltl, args.dot, bounds, ltl2ucw_converter, z3solver, logging.getLogger(__name__))

    args.ltl.close()
