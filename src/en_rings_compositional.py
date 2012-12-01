import argparse
from itertools import chain
import sys
import tempfile
from helpers.main_helper import setup_logging, create_spec_converter_z3
from module_generation.dot import moore_to_dot, to_dot
from parsing.en_rings_parser import  SCHED_ID_PREFIX, SENDS_NAME, ACTIVE_NAME, concretize_property, get_tok_rings_liveness_par_props, HAS_TOK_NAME, SENDS_PREV_NAME, anonymize_property, get_fair_scheduler_property, get_tok_ring_par_io, get_fair_proc_scheduling_property
from synthesis import par_model_searcher
from synthesis.smt_logic import UFLIA


simple_liveness_loc_guarantee = 'G((active_i && r_i) -> Fg_i)'

full_safety_loc_guarantee = """
(!g_i)
&& (!F(g_i && X((!r_i) && !g_i) && X(((!r_i) && !g_i) U (g_i && !r_i) )) )
&& (!(((!r_i) && (!g_i)) U ((!r_i) && g_i)))
""".strip().replace('\n', ' ')

full_liveness_loc_guarantee = """
G( (active_i && (!r_i) && g_i) -> F((r_i&&g_i) || (!g_i)) )
&& G( (active_i && r_i) -> Fg_i )
""".strip().replace('\n', ' ')


pnueli_safety_loc_assumption = """
(!r_i) &&
G((((!r_i) && g_i) || (r_i && !g_i)) -> (((!r_i) && X(!r_i)) || (r_i && Xr_i)))
""".strip().replace('\n', ' ')

pnueli_liveness_loc_assumption = """
GF(!(r_i && g_i))
""".strip().replace('\n', ' ')

pnueli_safety_loc_guarantee = """
(!g_i) &&
G((((!r_i) && (!g_i)) || (r_i && g_i)) ->  (((!g_i) && (X(!g_i))) || ((g_i) && (X(g_i)))))
""".strip().replace('\n', ' ')

pnueli_liveness_loc_guarantee = """
GF(((!r_i) && (!g_i)) || (r_i && g_i))
""".strip().replace('\n', ' ')


#xarb_loc_assumption = """
#(!r_i) &&
#G(((!r_i)&&Xg_i) -> X(!r_i)) &&
#G((r_i&&X!g_i) -> Xr_i) &&
#G((r_i&&Xg_i) -> X(!r_i))
#""".strip().replace('\n', ' ')
#
#xarb_loc_guarantee = """
#(!g_i) &&
#G(((!r_i)&&(!g_i))->X!g_i) &&
#G(r_i->XFg_i) &&
#G((r_i&&Xg_i) -> (XXg_i && XXXg_i && XXXX!g_i))
#""".strip().replace('\n', ' ')


#simple, full, pnueli, xarb = range(4)
simple, full, pnueli = range(3)


def _get_spec(spec_type):
    mutual_exclusion = 'G(!(g_i && g_j))'

    par_tok_ring_inputs, par_tok_ring_outputs = get_tok_ring_par_io()
    inputs = ['r_'] + par_tok_ring_inputs
    outputs = ['g_'] + par_tok_ring_outputs

    specs = [
        (inputs, outputs,
         'true', 'true',
         'true', simple_liveness_loc_guarantee,
         mutual_exclusion),
        (inputs, outputs,
         'true', 'true',
         full_safety_loc_guarantee,
         full_liveness_loc_guarantee,
         mutual_exclusion),
        (inputs, outputs,
         pnueli_safety_loc_assumption, pnueli_liveness_loc_assumption,
         pnueli_safety_loc_guarantee, pnueli_liveness_loc_guarantee,
         mutual_exclusion)]

    return specs[spec_type]


def _run(logger,
         is_moore,
         logic,
         global_automatae_pairs, loc_automaton,
         anon_inputs, anon_outputs,
         bounds,
         solver,
         smt_file_name,
         dot_files_prefix):

    logger.info('# of global automatae %i', len(global_automatae_pairs))

    for glob_automaton, cutoff in global_automatae_pairs:
        logger.info('global automaton %s', glob_automaton.name)
        logger.info('corresponding cutoff=%i', cutoff)
        logger.info('nof_nodes=%i', len(glob_automaton.nodes))

    if loc_automaton:
        logger.info('local automaton %s', loc_automaton.name)
        logger.info('nof_nodes=%i', len(loc_automaton.nodes))
    else:
        logger.info('no local automaton')

    models = par_model_searcher.search(logic,
        is_moore,
        global_automatae_pairs,
        loc_automaton,
        anon_inputs, anon_outputs,
        bounds,
        solver, SCHED_ID_PREFIX, ACTIVE_NAME, SENDS_NAME, HAS_TOK_NAME, SENDS_PREV_NAME,
        smt_file_name)

    logger.info('model%s found', ['', ' not'][models is None])

    if dot_files_prefix is not None and models is not None:
        for i, lts in enumerate(models):
            with open(dot_files_prefix + str(i) + '.dot', mode='w') as out:
                if is_moore:
                    dot = moore_to_dot(lts)
                else:
                    dot = to_dot(lts, [SENDS_NAME, HAS_TOK_NAME])
                out.write(dot)


def main_with_sync_hub(smt_file_name, logic, spec_type, is_moore, dot_files_prefix, bounds, cutoff, automaton_converter, solver, logger):
    logger.info('sync hub')

    #TODO: check two cases: when on SMT level and when here
#    hub_par_assumption = 'G((!{tok}i) -> F{prev}i) && G({tok}i -> !{prev}i)'.format(
#        tok = HAS_TOK_NAME,
#        prev = SENDS_PREV_NAME)
#
#    loc_property = '(({orig_loc_assumption} && {hub}) -> ({orig_loc_guarantee} && {tok_ring_guarantee}))'.format(
#        orig_loc_assumption = orig_loc_assumption,
#        orig_loc_guarantee = orig_loc_guarantee,
#        hub=hub_par_assumption,
#        tok_ring_guarantee = get_tok_rings_liveness_par_props()[0])


    anon_inputs, anon_outputs,\
    safety_loc_assumption, liveness_loc_assumption,\
    safety_loc_guarantee, liveness_loc_guarantee,\
    orig_glob_property = _get_spec(spec_type)

    par_hub_safety_ass = 'G({tok}i -> !{prev}i)'.format(
        tok = HAS_TOK_NAME,
        prev = SENDS_PREV_NAME)

    loc_safety_part = '(({loc_safety_ass}) && ({loc_hub_safety_ass})) -> ({loc_safety_gua})'.format(
        loc_safety_ass = safety_loc_assumption,
        loc_safety_gua = safety_loc_guarantee,
        loc_hub_safety_ass = par_hub_safety_ass
    )

    par_hub_liveness_ass = 'G((!{tok}i) -> F({prev}i && {active}i))'.format(
        tok = HAS_TOK_NAME,
        prev = SENDS_PREV_NAME,
        active = ACTIVE_NAME)

    loc_liveness_part = '(({loc_safety_ass}) && ({loc_liveness_ass}) && ({hub_safety_ass}) && ({hub_liveness_ass})) -> (({loc_spec_liveness_gua}) && ({loc_tok_ring_liveness_gua}))'.format(
        loc_safety_ass = safety_loc_assumption,
        loc_liveness_ass = liveness_loc_assumption,
        loc_spec_liveness_gua = liveness_loc_guarantee,
        hub_safety_ass = par_hub_safety_ass,
        hub_liveness_ass = par_hub_liveness_ass,
        loc_tok_ring_liveness_gua = get_tok_rings_liveness_par_props()[0]
    )

    loc_property = '({loc_liveness_part}) && ({loc_safety_part})'.format(
        loc_liveness_part = loc_liveness_part,
        loc_safety_part = loc_safety_part
    )

    loc_property = anonymize_property(loc_property, anon_inputs+anon_outputs+list(chain(*get_tok_ring_par_io())))
    loc_property = loc_property.replace(ACTIVE_NAME+'i', 'true') #hack: no need for active_i in sync_hub version

    glob_property = '({loc_safety_ass}) -> ({glob})'.format( #hack: i know that glob is a safety property
        loc_safety_ass = concretize_property(safety_loc_assumption, 1),
        glob = concretize_property(orig_glob_property, cutoff)
    )

    loc_automaton = automaton_converter.convert(loc_property)
    global_automaton = automaton_converter.convert(glob_property)

    global_automatae_pairs = [(global_automaton, cutoff)]

    _run(logger,
        is_moore,
        logic,
        global_automatae_pairs,
        loc_automaton,
        anon_inputs, anon_outputs,
        bounds,
        solver,
        smt_file_name, dot_files_prefix)


def main_with_async_hub(smt_file_prefix,
                        logic,
                        spec_type,is_moore,
                        dot_files_prefix,
                        bounds,
                        cutoff,
                        automaton_converter,
                        solver,
                        logger):
    logger.info('async_hub')

    anon_inputs, anon_outputs,\
    safety_loc_assumption, liveness_loc_assumption,\
    safety_loc_guarantee, liveness_loc_guarantee,\
    orig_glob_property = _get_spec(spec_type)

    loc_safety_assumption = '{loc_safety_ass}'.format(
        loc_safety_ass = concretize_property(safety_loc_assumption, 1)
    )

    loc_safety_guarantee = '{loc_safety_gua}'.format(
        loc_safety_gua = concretize_property(safety_loc_guarantee, 1)
    )

    par_hub_safety_ass = 'G({tok}i -> !{prev}i)'.format(
        tok = HAS_TOK_NAME,
        prev = SENDS_PREV_NAME)

    loc_safety_part = '(({loc_safety_ass}) && ({loc_hub_safety_ass})) -> ({loc_safety_gua})'.format(
        loc_safety_ass = loc_safety_assumption,
        loc_safety_gua = loc_safety_guarantee,
        loc_hub_safety_ass = concretize_property(par_hub_safety_ass, 1)
    )

    par_hub_liveness_ass = 'G((!{tok}i) -> F({prev}i && {active}i))'.format(
        tok = HAS_TOK_NAME,
        prev = SENDS_PREV_NAME,
        active = ACTIVE_NAME)

    loc_liveness_part = '(({fair_sched}) && ({loc_safety_ass}) && ({loc_liveness_ass}) && ({hub_safety_ass}) && ({hub_liveness_ass})) -> (({loc_spec_liveness_gua}) && ({loc_tok_ring_liveness_gua}))'.format(
        fair_sched = get_fair_proc_scheduling_property(0, 1, SCHED_ID_PREFIX),
        loc_safety_ass = loc_safety_assumption,
        loc_liveness_ass = concretize_property(liveness_loc_assumption, 1),
        loc_spec_liveness_gua = concretize_property(liveness_loc_guarantee, 1),
        hub_safety_ass = concretize_property(par_hub_safety_ass, 1),
        hub_liveness_ass = concretize_property(par_hub_liveness_ass, 1),
        loc_tok_ring_liveness_gua = concretize_property(get_tok_rings_liveness_par_props()[0], 1)
    )

    loc_property = '({loc_liveness_part}) && ({loc_safety_part})'.format(
        loc_liveness_part = loc_liveness_part,
        loc_safety_part = loc_safety_part
    )

    glob_property = '({loc_safety_ass}) -> ({glob})'.format( #hack: i know that glob is a safety property
        loc_safety_ass = loc_safety_assumption,
        glob = concretize_property(orig_glob_property, cutoff)
    )

    ring_with_hub_automaton = automaton_converter.convert(loc_property)
    global_automaton = automaton_converter.convert(glob_property)

    global_automatae_pairs = [(global_automaton, cutoff), (ring_with_hub_automaton, 1)]

    _run(logger,
        is_moore,
        logic,
        global_automatae_pairs,
        None,
        anon_inputs, anon_outputs,
        bounds,
        solver,
        smt_file_prefix, dot_files_prefix)


def main_compo(smt_file_prefix, logic, spec_type, is_moore, dot_files_prefix, bounds, cutoff, automaton_converter, solver, logger):
    logger.info('compositional approach')

    anon_inputs, anon_outputs,\
    safety_loc_assumption, liveness_loc_assumption,\
    safety_loc_guarantee, liveness_loc_guarantee,\
    orig_glob_property = _get_spec(spec_type)

    loc_safety_assumption = '{loc_safety_ass}'.format(
        loc_safety_ass = concretize_property(safety_loc_assumption, 1)
    )

    loc_safety_guarantee = '{loc_safety_gua}'.format(
        loc_safety_gua = concretize_property(safety_loc_guarantee, 1)
    )

    loc_safety_part = '({loc_safety_ass}) -> ({loc_safety_gua})'.format(
        loc_safety_ass = loc_safety_assumption,
        loc_safety_gua = loc_safety_guarantee
    )

    par_fair_token = 'GF({tok}i)'.format(
        tok=HAS_TOK_NAME,
        prev=SENDS_PREV_NAME)

    loc_tok_ring_liveness_part = '(({fair_sched}) && ({loc_safety_ass}) && ({loc_liveness_ass})) -> ({loc_tok_ring_liveness_gua})'.format(
        fair_sched = get_fair_proc_scheduling_property(0, 2, SCHED_ID_PREFIX),
        loc_safety_ass = loc_safety_assumption,
        loc_liveness_ass = concretize_property(liveness_loc_assumption, 1),
        loc_tok_ring_liveness_gua = concretize_property(get_tok_rings_liveness_par_props()[0], 1)
    )

    loc_spec_liveness_part = '(({fair_sched}) && ({fair_tok}) && ({loc_safety_ass}) && ({loc_liveness_ass})) -> ({loc_spec_liveness_gua})'.format(
        fair_sched = get_fair_proc_scheduling_property(0, 2, SCHED_ID_PREFIX),
        fair_tok = concretize_property(par_fair_token, 1),
        loc_safety_ass = loc_safety_assumption,
        loc_liveness_ass = concretize_property(liveness_loc_assumption, 1),
        loc_spec_liveness_gua = concretize_property(liveness_loc_guarantee, 1)
    )

    loc_liveness_part = '({loc_spec_liveness_part}) && ({loc_tok_ring_liveness_part})'.format(
        loc_spec_liveness_part = loc_spec_liveness_part,
        loc_tok_ring_liveness_part = loc_tok_ring_liveness_part
    )

    loc_property = '({loc_liveness_part}) && ({loc_safety_part})'.format(
        loc_liveness_part = loc_liveness_part ,
        loc_safety_part = loc_safety_part
    )

    glob_property = '({loc_safety_ass}) -> ({glob})'.format( #hack: i know that glob is a safety property
        loc_safety_ass = loc_safety_assumption,
        glob = concretize_property(orig_glob_property, cutoff)
    )

    loc_automaton = automaton_converter.convert(loc_property)
    global_automaton = automaton_converter.convert(glob_property)

    automatae = [(loc_automaton, 2), (global_automaton, cutoff)]

    _run(logger,
        is_moore,
        logic, automatae, None, anon_inputs, anon_outputs,
        bounds,
        solver,
        smt_file_prefix, dot_files_prefix)


def main_strengthening(smt_file_name, logic, spec_type, is_moore, dot_files_prefix, bounds, cutoff, automaton_converter, solver, logger):
    logger.info('strengthening approach')

    anon_inputs, anon_outputs,\
    safety_loc_assumption, liveness_loc_assumption,\
    safety_loc_guarantee, liveness_loc_guarantee,\
    orig_glob_property = _get_spec(spec_type)

    loc_safety_assumption = '{loc_safety_ass}'.format(
        loc_safety_ass = concretize_property(safety_loc_assumption, 1)
    )

    loc_safety_guarantee = '{loc_safety_gua}'.format(
        loc_safety_gua = concretize_property(safety_loc_guarantee, 1)
    )

    loc_safety_part = '({loc_safety_ass}) -> ({loc_safety_gua})'.format(
        loc_safety_ass = loc_safety_assumption,
        loc_safety_gua = loc_safety_guarantee
    )

    par_fair_token = 'GF({tok}i)'.format(
        tok=HAS_TOK_NAME,
        prev=SENDS_PREV_NAME)

    loc_tok_ring_liveness_part = '(({fair_sched}) && ({loc_safety_ass}) && ({loc_liveness_ass})) -> ({loc_tok_ring_liveness_gua})'.format(
        fair_sched = get_fair_proc_scheduling_property(0, cutoff, SCHED_ID_PREFIX),
        loc_safety_ass = loc_safety_assumption,
        loc_liveness_ass = concretize_property(liveness_loc_assumption, 1),
        loc_tok_ring_liveness_gua = concretize_property(get_tok_rings_liveness_par_props()[0], 1)
    )

    loc_spec_liveness_part = '(({fair_sched}) && ({fair_tok}) && ({loc_safety_ass}) && ({loc_liveness_ass})) -> ({loc_spec_liveness_gua})'.format(
        fair_sched = get_fair_proc_scheduling_property(0, cutoff, SCHED_ID_PREFIX),
        fair_tok = concretize_property(par_fair_token, 1),
        loc_safety_ass = loc_safety_assumption,
        loc_liveness_ass = concretize_property(liveness_loc_assumption, 1),
        loc_spec_liveness_gua = concretize_property(liveness_loc_guarantee, 1)
    )

    loc_liveness_part = '({loc_spec_liveness_part}) && ({loc_tok_ring_liveness_part})'.format(
        loc_spec_liveness_part = loc_spec_liveness_part,
        loc_tok_ring_liveness_part = loc_tok_ring_liveness_part
    )

    loc_part = '({loc_liveness_part}) && ({loc_safety_part})'.format(
        loc_liveness_part = loc_liveness_part,
        loc_safety_part = loc_safety_part
    )

    glob_part = '({loc_safety_ass}) -> ({glob})'.format( #hack: i know that glob is a safety property
        loc_safety_ass = loc_safety_assumption,
        glob = concretize_property(orig_glob_property, cutoff)
    )

    glob_property = '({loc_part}) && ({glob_part})'.format(
        glob_part = glob_part,
        loc_part = loc_part)

    automaton = automaton_converter.convert(glob_property)

    automaton_size_pairs = [(automaton, cutoff)]

    _run(logger,
        is_moore,
        logic, automaton_size_pairs,
        None,
        anon_inputs, anon_outputs,
        bounds,
        solver,
        smt_file_name, dot_files_prefix)


def main_bottomup(smt_file_name, logic, spec_type,is_moore, dot_files_prefix, bounds, cutoff, automaton_converter, solver, logger):
    logger.info('bottom-up approach')

    anon_inputs, anon_outputs, \
    safety_loc_assumption, liveness_loc_assumption,\
    safety_loc_guarantee, liveness_loc_guarantee,\
    orig_glob_property = _get_spec(spec_type)

    ass = '({fair_sched}) && ({safety_ass}) && ({liveness_ass})'.format(
        fair_sched = get_fair_scheduler_property(cutoff, SCHED_ID_PREFIX),
        safety_ass = concretize_property(safety_loc_assumption, cutoff),
        liveness_ass = concretize_property(liveness_loc_assumption, cutoff)
    )

    gua = '({safety_loc_gua}) && ({liveness_loc_gua}) && ({glob}) && ({tok_ring_gua})'.format(
        safety_loc_gua = concretize_property(safety_loc_guarantee, 1), #1 - due to isomorphism
        liveness_loc_gua = concretize_property(liveness_loc_guarantee, 1),
        glob = concretize_property(orig_glob_property, cutoff),
        tok_ring_gua = concretize_property(get_tok_rings_liveness_par_props()[0], 1)
    )

    glob_property = '({ass}) -> ({gua})'.format(ass = ass, gua = gua)

    automaton = automaton_converter.convert(glob_property)

    automaton_size_pairs = [(automaton, cutoff)]

    _run(logger,
        is_moore,
        logic, automaton_size_pairs,
        None,
        anon_inputs, anon_outputs,
        bounds,
        solver,
        smt_file_name, dot_files_prefix)


_OPT_TO_MAIN = {'sync_hub':main_with_sync_hub,
                'async_hub':main_with_async_hub,
                'compo':main_compo,
                'strength':main_strengthening,
                'bottomup':main_bottomup}


def main():
    parser = argparse.ArgumentParser(description='Parametrized Synthesis Tool for token rings architecture')
    parser.add_argument('ltl', metavar='ltl', type=str,
        help='type of LTL formula: acceptable are: pnueli, full, simple')
    parser.add_argument('--moore', action='store_true', required=False, default=False,
        help='treat the spec as Moore and produce Moore machine')
    parser.add_argument('--dot', metavar='dot', type=str, required=False,
        help='writes the output into a dot graph files prefixed with this prefix')
    parser.add_argument('--bound', metavar='bound', type=int, default=2, required=False,
        help='upper bound on the size of local process (default: %(default)i)')
    parser.add_argument('--size', metavar='size', type=int, default=None, required=False,
        help='exact size of the process implementation(default: %(default)i)')
    parser.add_argument('--cutoff', metavar='cutoff', type=int, default=None, required=True,
        help='force specified cutoff size')
    parser.add_argument('-v', '--verbose', action='count', default=0)

    parser.add_argument('--opt', choices=tuple(_OPT_TO_MAIN.keys()), required=True)

    args = parser.parse_args(sys.argv[1:])

    logger = setup_logging(args.verbose)

    logger.debug(args)

    ltl2ucw_converter, z3solver = create_spec_converter_z3(False)

    bounds = list(range(2, args.bound + 1) if args.size is None else range(args.size, args.size + 1))

    logic = UFLIA(None)

    with tempfile.NamedTemporaryFile(delete=False, dir='./') as smt_file:
        smt_file_name = smt_file.name

    logger.info('temp file prefix used is %s', smt_file_name)

    main_func = _OPT_TO_MAIN[args.opt]
    main_func(smt_file_name, logic,
        {'pnueli': pnueli, 'full':full, 'simple':simple}[args.ltl],
        args.moore,
        args.dot, bounds, args.cutoff, ltl2ucw_converter, z3solver, logger)


if __name__ == '__main__':
    main()


#    main()

#    profile_file_name = 'profile_data'
#
#    cProfile.run('tmp()', filename=profile_file_name)
#    p = pstats.Stats(profile_file_name)
#
#    p.sort_stats('cumulative').print_stats(15)
