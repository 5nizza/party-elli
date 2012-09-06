import argparse
from itertools import chain
import sys
import tempfile
from helpers.main_helper import setup_logging, create_spec_converter_z3
from helpers.automata_helper import  is_safety_automaton
from module_generation.dot import to_dot
from parsing.en_rings_parser import  SCHED_ID_PREFIX, SENDS_NAME, ACTIVE_NAME, concretize_property, get_tok_rings_liveness_par_props, HAS_TOK_NAME, SENDS_PREV_NAME, anonymize_property, get_fair_scheduler_property, get_tok_ring_par_io
from synthesis import par_model_searcher
from synthesis.smt_logic import UFLIA


def _is_safety_property(property, automaton_converter):
    #TODO: bug! negation of safety is not necessary a safety property!
    automaton = automaton_converter.convert(property)
    is_safety = is_safety_automaton(automaton)

    return is_safety


simple_arb_loc_guarantee = 'G((active_i && r_i) -> Fg_i)'

full_arb_loc_guarantee = """
(!g_i)
&& G( (active_i && (!r_i) && g_i) -> F((r_i&&g_i) || (!g_i)) )
&& G( (active_i && r_i) -> Fg_i )
&& (!F(g_i && X((!r_i) && !g_i) && X(((!r_i) && !g_i) U (g_i && !r_i) )) )
&& (!(((!r_i) && (!g_i)) U ((!r_i) && g_i)))
""".strip().replace('\n', ' ')


pnueli_arb_loc_assumption = """
(!r_i) &&
G((((!r_i) && g_i) || (r_i && !g_i)) -> (((!r_i) && X(!r_i)) || (r_i && Xr_i))) &&
GF(!(r_i && g_i))
""".strip().replace('\n', ' ')

pnueli_arb_loc_guarantee = """
(!g_i) &&
G((((!r_i) && (!g_i)) || (r_i && g_i)) ->  (((!g_i) && (X(!g_i))) || ((g_i) && (X(g_i))))) &&
GF(((!r_i) && (!g_i)) || (r_i && g_i))
""".strip().replace('\n', ' ')


xarb_loc_assumption = """
(!r_i) &&
G(((!r_i)&&Xg_i) -> X(!r_i)) &&
G((r_i&&X!g_i) -> Xr_i) &&
G((r_i&&Xg_i) -> X(!r_i))
""".strip().replace('\n', ' ')

xarb_loc_guarantee = """
(!g_i) &&
G(((!r_i)&&(!g_i))->X!g_i) &&
G(r_i->XFg_i) &&
G((r_i&&Xg_i) -> (XXg_i && XXXg_i && XXXX!g_i))
""".strip().replace('\n', ' ')


simple, full, pnueli, xarb = range(4)


def _get_spec(spec_type):
    #TODO: the only global property allowed is safety - mutual exclusion
    mutual_exclusion = 'G(!(g_i && g_j))'

    par_tok_ring_inputs, par_tok_ring_outputs = get_tok_ring_par_io()
    inputs = ['r_'] + par_tok_ring_inputs
    outputs = ['g_'] + par_tok_ring_outputs

    specs = [
        (inputs, outputs, 'true', simple_arb_loc_guarantee, mutual_exclusion),
        (inputs, outputs, 'true', full_arb_loc_guarantee, mutual_exclusion),
        (inputs, outputs, pnueli_arb_loc_assumption, pnueli_arb_loc_guarantee, mutual_exclusion),
        (inputs, outputs, xarb_loc_assumption, xarb_loc_guarantee, mutual_exclusion)]

    return specs[spec_type]


def _run(logic,
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
                dot = to_dot(lts)
                out.write(dot)


def main_with_async_hub(smt_file_prefix,
                        logic,
                        spec_type,
                        dot_files_prefix,
                        bounds,
                        cutoff,
                        automaton_converter,
                        solver,
                        logger):
    logger.info('async_hub')

    anon_inputs, anon_outputs, orig_loc_assumption, orig_loc_guarantee, orig_glob_guarantee = _get_spec(spec_type)

    hub_par_assumption = 'G((!{tok}i) -> F({prev}i && {active}i)) && G({tok}i -> !{prev}i)'.format(
        tok = HAS_TOK_NAME,
        prev = SENDS_PREV_NAME,
        active = ACTIVE_NAME)

    loc_property = '(({fair_sched} && {orig_loc_assumption} && {hub}) -> (({orig_loc_guarantee}) && {tok_ring_guarantee}))'.format(
        fair_sched = get_fair_scheduler_property(1, SCHED_ID_PREFIX),
        orig_loc_assumption = concretize_property(orig_loc_assumption, 1),
        orig_loc_guarantee = concretize_property(orig_loc_guarantee, 1),
        hub = concretize_property(hub_par_assumption, 1),
        tok_ring_guarantee = concretize_property(get_tok_rings_liveness_par_props()[0], 1))

    ring_with_hub_automaton = automaton_converter.convert(loc_property)

    full_concr_prop = concretize_property(orig_glob_guarantee, cutoff)
    global_automaton = automaton_converter.convert(full_concr_prop)

    global_automatae_pairs = [(global_automaton, cutoff), (ring_with_hub_automaton, 1)]

    _run(logic,
        global_automatae_pairs,
        None,
        anon_inputs, anon_outputs,
        bounds,
        solver,
        smt_file_prefix, dot_files_prefix)


def main_with_sync_hub(smt_file_name, logic, spec_type, dot_files_prefix, bounds, cutoff, automaton_converter, solver, logger):
    logger.info('sync hub')

    anon_inputs, anon_outputs, orig_loc_assumption, orig_loc_guarantee, orig_glob_guarantee = _get_spec(spec_type)

    #TODO: check two cases: when on SMT level and when here
    hub_par_assumption = 'G((!{tok}i) -> F{prev}i) && G({tok}i -> !{prev}i)'.format(
        tok = HAS_TOK_NAME,
        prev = SENDS_PREV_NAME)

    loc_property = '(({orig_loc_assumption} && {hub}) -> ({orig_loc_guarantee} && {tok_ring_guarantee}))'.format(
        orig_loc_assumption = orig_loc_assumption,
        orig_loc_guarantee = orig_loc_guarantee,
        hub=hub_par_assumption,
        tok_ring_guarantee = get_tok_rings_liveness_par_props()[0])

    loc_property = anonymize_property(loc_property, anon_inputs+anon_outputs+list(chain(*get_tok_ring_par_io())))
    #TODO: hack: no need for active_i in sync_hub version
    loc_property = loc_property.replace(ACTIVE_NAME+'i', 'true')

    loc_automaton = automaton_converter.convert(loc_property)

    full_concr_prop = concretize_property(orig_glob_guarantee, cutoff)
    global_automaton = automaton_converter.convert(full_concr_prop)

    global_automatae_pairs = [(global_automaton, cutoff)]

    _run(logic,
        global_automatae_pairs,
        loc_automaton,
        anon_inputs, anon_outputs,
        bounds,
        solver,
        smt_file_name, dot_files_prefix)


def main_compo(smt_file_prefix, logic, spec_type, dot_files_prefix, bounds, cutoff, automaton_converter, solver, logger):
    logger.info('compositional approach')

    anon_inputs, anon_outputs, orig_loc_assumption, orig_loc_guarantee, orig_glob_guarantee = _get_spec(spec_type)

    par_fair_token = 'GF({tok}i)'.format(
        tok=HAS_TOK_NAME,
        prev=SENDS_PREV_NAME)

    loc_property_wo_sched = '(({orig_loc_assumption} && {fair_tok}) -> ({orig_loc_guarantee} && {tok_ring_guarantee}))'.format(
        orig_loc_assumption = orig_loc_assumption,
        orig_loc_guarantee = orig_loc_guarantee,
        fair_tok = par_fair_token,
        tok_ring_guarantee = get_tok_rings_liveness_par_props()[0])
    loc_property_wo_sched = concretize_property(loc_property_wo_sched, 1)

    loc_property = '({fair_sched}) -> ({loc_property})'.format(
        fair_sched=get_fair_scheduler_property(2, SCHED_ID_PREFIX),
        loc_property = loc_property_wo_sched)

    loc_automaton = automaton_converter.convert(loc_property)

    full_concr_prop = concretize_property(orig_glob_guarantee, cutoff)
    global_automaton = automaton_converter.convert(full_concr_prop)

    automatae = [(loc_automaton, 2), (global_automaton, cutoff)]

    _run(logic, automatae, None, anon_inputs, anon_outputs,
        bounds,
        solver,
        smt_file_prefix, dot_files_prefix)


def main_global(smt_file_name, logic, spec_type, dot_files_prefix, bounds, cutoff, automaton_converter, solver, logger):
    logger.info('global approach')

    anon_inputs, anon_outputs, orig_loc_assumption, orig_loc_guarantee, orig_glob_guarantee = _get_spec(spec_type)

    glob_property = '({fair_sched}) -> (({loc_assumption}) -> ({loc_guarantee} && {tok_ring_guarantee}))'.format(
        fair_sched=get_fair_scheduler_property(cutoff, SCHED_ID_PREFIX),
        loc_assumption = concretize_property(orig_loc_assumption, cutoff if spec_type == pnueli else 1),
        loc_guarantee = concretize_property(orig_loc_guarantee, 1),
        tok_ring_guarantee = concretize_property(get_tok_rings_liveness_par_props()[0], 1))

    glob_property = '({0}) && {1}'.format(
        glob_property,
        concretize_property(orig_glob_guarantee, cutoff))

    automaton = automaton_converter.convert(glob_property)

    automaton_size_pairs = [(automaton, cutoff)]

    _run(logic, automaton_size_pairs,
        None,
        anon_inputs, anon_outputs,
        bounds,
        solver,
        smt_file_name, dot_files_prefix)


_OPT_TO_MAIN = {'sync_hub':main_with_sync_hub,
                'async_hub':main_with_async_hub,
                'compo':main_compo,
                'glob':main_global}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Parametrized Synthesis Tool for token rings architecture')
    parser.add_argument('ltl', metavar='ltl', type=str,
        help='type of LTL formula: acceptable are: pnueli, full, simple')
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

    smt_file = tempfile.NamedTemporaryFile(delete=False, dir='./')
    smt_file_name = smt_file.name
    smt_file.close()

    logger.info('temp file is used %s', smt_file_name)

    main_func = _OPT_TO_MAIN[args.opt]
    main_func(smt_file_name, logic,
        {'pnueli': pnueli, 'full':full, 'simple':simple, 'xarb': xarb}[args.ltl],
        args.dot, bounds, args.cutoff, ltl2ucw_converter, z3solver, logger)