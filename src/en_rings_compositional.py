import argparse
import logging
import os
import sys
from helpers import automata_helper
from helpers.main_helper import setup_logging, create_spec_converter_z3
from helpers.automata_helper import  is_safety_automaton
from interfaces import automata
from module_generation.dot import to_dot
from parsing.en_rings_parser import is_parametrized, SCHED_ID_PREFIX, SENDS_NAME, ACTIVE_NAME, add_concretize_fair_sched, get_par_io, is_local_property, concretize_property, get_tok_rings_liveness_par_props, get_cutoff_size, HAS_TOK_NAME, SENDS_PREV_NAME, anonymize_property, parametrize_anon_var, get_fair_scheduler_property, get_tok_rings_liveness_anon_props
from parsing.parser import parse_ltl
from synthesis.par_model_searcher_compositional import search
from translation2uct.ltl2automaton import get_solid_property


def _is_safety_property(property, automaton_converter):
    #TODO: bug! negation of safety is not necessary a safety property!
    automaton = automaton_converter.convert(property)
    is_safety = is_safety_automaton(automaton)

    return is_safety


def _separate_properties(automaton_converter, props):
    #TODO: restore
    safety_props = set()
    #list(filter(lambda p: _is_safety_property(p, automaton_converter), props))
    liveness_props = list(set(props).difference(safety_props))
    return safety_props, liveness_props


def main(ltl_file, dot_files_prefix, bounds, cutoff, automaton_converter, solver, logger):
    raw_ltl_spec = parse_ltl(ltl_file.read())

    assert is_parametrized(raw_ltl_spec)

    par_inputs, par_outputs = get_par_io(raw_ltl_spec)


    loc_guarantee = """
(
(!g_i)
&& G( ((!r_i) && g_i) -> F((r_i&&g_i) || (!g_i)) )
&& G(r_i -> Fg_i)
&& (!F(g_i && X((!r_i)&&!g_i) && X(((!r_i)&&!g_i) U (g_i && !r_i) )) )
&& (!(((!r_i) && (!g_i)) U ((!r_i) && g_i)))
)
    """.strip().replace('\n', ' ')

    loc_assumption = 'true'

#    loc_assumption = \
#"""
#(!r_i) &&
#G((((!r_i) && g_i) || (r_i && !g_i)) -> (((!r_i) && X(!r_i)) || (r_i && Xr_i))) &&
#GF(!(r_i && g_i))
#""".strip().replace('\n', ' ')
#
#    loc_guarantee = \
#"""
#(!g_i) &&
#G((((!r_i) && (!g_i)) || (r_i && g_i)) ->  (((!g_i) && (X(!g_i))) || ((g_i) && (X(g_i))))) &&
#GF(((!r_i) && (!g_i)) || (r_i && g_i))
#""".strip().replace('\n', ' ')

#    loc_assumption = """
#true
#""".strip().replace('\n', ' ')
#
#    loc_guarantee = """
#(
#(!g_i)
#&& G( ((!r_i) && g_i) -> F((r_i&&g_i) || (!g_i)) )
#&& G(r_i -> F(g_i && Xg_i))
#&& (!F(g_i && X((!r_i)&&!g_i) && X(((!r_i)&&!g_i) U (g_i && !r_i) )) )
#&& (!(((!r_i) && (!g_i)) U ((!r_i) && g_i)))
#)
#""".strip().replace('\n', ' ')

#    loc_assumption = """
#(
#(!r_i) &&
#G(((!r_i)&&Xg_i) -> X(!r_i)) &&
#G((r_i&&X!g_i) -> Xr_i) &&
#G((r_i&&Xg_i) -> X(!r_i))
#)
#""".strip().replace('\n', ' ')
#
#    loc_guarantee = """
#(
#(!g_i) &&
#G(((!r_i)&&(!g_i))->X!g_i) &&
#G(r_i->XFg_i) &&
#G((r_i&&Xg_i) -> (XXg_i && XXX!g_i))
#)
#""".strip().replace('\n', ' ')

    tok_rings_guarantee = get_tok_rings_liveness_anon_props()[0]
#    tok_rings_assumption = 'GF({sends_prev})'.format(sends_prev = SENDS_PREV_NAME)
    tok_rings_assumption = 'G((!{tok}) -> F{sends_prev})'.format(tok = HAS_TOK_NAME, sends_prev = SENDS_PREV_NAME)

    #TODO: tmp!
    loc_property1 = '( ({tok_rings_assumption}) && ({loc_assumption}) ) -> ({tok_rings_guarantee})'\
    .format(tok_rings_assumption = tok_rings_assumption,
        loc_assumption = loc_assumption,
        tok_rings_guarantee = tok_rings_guarantee)
#    loc_property1 = '( ({tok_rings_assumption})) -> ({tok_rings_guarantee})'\
#        .format(tok_rings_assumption = tok_rings_assumption,
#            loc_assumption = loc_assumption,
#            tok_rings_guarantee = tok_rings_guarantee)

    loc_property2 = '(({tok_rings_assumption}) && ({loc_assumption})) -> ({loc_guarantee})'\
    .format(tok_rings_assumption=tok_rings_assumption,
        loc_assumption = loc_assumption,
        loc_guarantee = loc_guarantee)
#
#
#
    loc_property = '({0}) && ({1})'.format(loc_property1, loc_property2)
#    loc_property = '{0}'.format(loc_property1)

    loc_property = anonymize_property(loc_property, raw_ltl_spec._inputs+raw_ltl_spec.outputs)

    print(loc_property)
#    assert 0
    loc_automaton = automaton_converter.convert(loc_property)

#    print(automata_helper.to_dot(loc_automaton))
#    assert 0

#    global_automaton = None
    nof_processes = cutoff

#    sched_assmpts = get_fair_scheduler_property(nof_processes, SCHED_ID_PREFIX)

#    concrt_assmpts = concretize_property(get_solid_property(glob_assumptions), nof_processes)
#    concrt_guarantees = concretize_property(get_solid_property(glob_guarantees), nof_processes)
#    concrt_tok_rings_guarantees = concretize_property(get_solid_property(get_tok_rings_liveness_par_props()),
#        nof_processes)

#    full_concr_prop = '(({sched}) && ({orig_assmpt})) -> (({orig_gua} && {ring_gua}))'.format_map({'sched': sched_assmpts,
#                                                                                                'orig_assmpt': concrt_assmpts,
#                                                                                                'orig_gua': concrt_guarantees,
#                                                                                                'ring_gua': concrt_tok_rings_guarantees
#                                                                                                })

    glob_property = 'G(!(g_i && g_j))'
#    glob_property = '!g_i'
#    glob_property = ''
    full_concr_prop = concretize_property(glob_property, nof_processes)

#    full_concr_prop = concretize_property('!g_i', nof_processes)
#    full_concr_prop = 'G()'

    global_automaton = automaton_converter.convert(full_concr_prop)

    logger.info('global automaton has %i states', len(global_automaton.nodes))
    logger.info('full_concr_props is %s', full_concr_prop)

    logger.info('using the cutoff of size %i', nof_processes)

    models = search(loc_automaton, global_automaton, par_inputs, par_outputs,
        nof_processes,
        bounds,
        solver, SCHED_ID_PREFIX, ACTIVE_NAME, SENDS_NAME, HAS_TOK_NAME, SENDS_PREV_NAME,
        'smt_query.smt2') #TODO: hack: hardcode

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
