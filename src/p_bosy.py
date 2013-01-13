import argparse
import sys
import tempfile

from argparse import FileType
from collections import Iterable
from itertools import chain
from logging import Logger
from architecture.scheduler import InterleavingScheduler, SCHED_ID_PREFIX, ACTIVE_NAME
from architecture.tok_ring import TokRingArchitecture, SENDS_NAME, HAS_TOK_NAME, SENDS_PREV_NAME

from helpers.main_helper import setup_logging, create_spec_converter_z3
from interfaces.automata import Automaton
from interfaces.parser_expr import Bool
from interfaces.spec import SpecProperty, and_properties, expr_from_property
from module_generation.dot import moore_to_dot, to_dot
from optimizations import localize, strengthen, inst_property, apply_log_bit_scheduler_optimization, _instantiate_expr
from parsing import par_parser
from parsing.par_lexer_desc import PAR_INPUT_VARIABLES, PAR_OUTPUT_VARIABLES, PAR_ASSUMPTIONS, PAR_GUARANTEES
from synthesis import par_model_searcher
from synthesis.par_model_searcher import BaseNames
from synthesis.smt_logic import UFLIA
from translation2uct.ltl2automaton import Ltl2UCW


NO, STRENGTH, ASYNC_HUB, SYNC_HUB = 'no', 'strength', 'async_hub', 'sync_hub'
OPTS = {NO:0, STRENGTH:1, ASYNC_HUB:2, SYNC_HUB:3}


def _get_spec(ltl_text:str, logger:Logger) -> (list, list, list, list):
    #all the assumptions are conjugated together
    #the guarantees are separated into different SpecProperty objects

    data_by_section = par_parser.parse_ltl(ltl_text, logger)
    if data_by_section is None:
        return

    assumptions = data_by_section[PAR_ASSUMPTIONS]
    guarantees = data_by_section[PAR_GUARANTEES]

    anon_inputs = [s.name for s in data_by_section[PAR_INPUT_VARIABLES]]
    anon_outputs = [s.name for s in data_by_section[PAR_OUTPUT_VARIABLES]]

    return anon_inputs, anon_outputs, assumptions, guarantees


def _run(is_moore,
         anon_inputs, anon_outputs,
         sync_automaton:Automaton, global_automatae_pairs,
         bounds,
         solver, logic,
         smt_files_prefix:str,
         dot_files_prefix,
         logger):

    logger.info('# of global automatae %i', len(global_automatae_pairs))

    for glob_automaton, cutoff in global_automatae_pairs:
        logger.info('global automaton %s', glob_automaton.name)
        logger.info('corresponding cutoff=%i', cutoff)
        logger.info('nof_nodes=%i', len(glob_automaton.nodes))

    if sync_automaton:
        logger.info('local automaton %s', sync_automaton.name)
        logger.info('nof_nodes=%i', len(sync_automaton.nodes))
    else:
        logger.info('no local automaton')

    model_searcher = par_model_searcher.ParModelSearcher()
    models = model_searcher.search(logic,
        is_moore,
        global_automatae_pairs,
        sync_automaton,
        anon_inputs, anon_outputs,
        bounds,
        solver,
        smt_files_prefix,
        BaseNames(SCHED_ID_PREFIX, ACTIVE_NAME, SENDS_NAME, SENDS_PREV_NAME, HAS_TOK_NAME))

    logger.info('model%s found', ['', ' not'][models is None])

    if dot_files_prefix is not None and models is not None:
        for i, lts in enumerate(models):
            with open(dot_files_prefix + str(i) + '.dot', mode='w') as out:
                if is_moore:
                    dot = moore_to_dot(lts)
                else:
                    dot = to_dot(lts, [SENDS_NAME, HAS_TOK_NAME])
                out.write(dot)


def join_properties(properties:Iterable):
    properties = list(properties)
    all_ass = list(chain(p.assumptions for p in properties))
    all_gua = list(chain(p.guarantees for p in properties))
    return SpecProperty(all_ass, all_gua)


def _strengthen_many(properties:list, ltl2ucw_converter) -> (list, list):
    pseudo_safety_properties, pseudo_liveness_properties = [], []
    for p in properties:
        safety_props, liveness_props = strengthen(p, ltl2ucw_converter)
        pseudo_safety_properties += safety_props
        pseudo_liveness_properties += liveness_props

    return pseudo_safety_properties, pseudo_liveness_properties


def main(spec_text,
         optimization,
         is_moore,
         smt_files_prefix, dot_files_prefix,
         bounds,
         cutoff,
         ltl2ucw_converter:Ltl2UCW,
         z3solver, logic,
         logger):
    #TODO: check which optimizations are used
    #TODO: async_hub left, modular is always enabled

    anon_inputs, anon_outputs, assumptions, guarantees = _get_spec(spec_text, logger)

    archi = TokRingArchitecture()
    archi_properties = [SpecProperty(assumptions, [g]) for g in archi.guarantees()]
    spec_properties = [SpecProperty(assumptions+archi.implications(), [g]) for g in guarantees]
    properties = archi_properties + spec_properties

    scheduler = InterleavingScheduler()
    properties = [SpecProperty(p.assumptions + scheduler.assumptions, p.guarantees)
                  for p in properties]

    if OPTS[optimization] >= OPTS[STRENGTH]:
        logger.info('strengthening properties..')
        pseudo_safety_properties, pseudo_liveness_properties = _strengthen_many(properties, ltl2ucw_converter)
    else:
        pseudo_safety_properties = []
        pseudo_liveness_properties = properties

    print('-'*80)
    print('original property')
    print('\n'.join(map(str, properties)))
    print()

    print('-'*80)
    print('after strengthening')
    print('\nsafety-----------')
    print('\n'.join(map(str, pseudo_safety_properties)))
    print('\nliveness---------')
    print('\n'.join(map(str, pseudo_liveness_properties)))
    print('-----------')
    print()
    #TODO: add support of strength option disabling
    properties = [localize(p) if OPTS[optimization] >= OPTS[STRENGTH]
                  else p
                  for p in pseudo_liveness_properties + pseudo_safety_properties]

    print('-'*80)
    print('after localization')
    for p in properties:
        print(p)
    print()
    print('-'*80)

    prop_real_cutoff_pairs = [(p, archi.get_cutoff(p)) for p in properties]

    par_local_properties = [p for (p,c) in prop_real_cutoff_pairs if c == 2]
    par_global_property_pairs = [(p,c) for (p,c) in prop_real_cutoff_pairs if p not in par_local_properties]

    if optimization == ASYNC_HUB: #TODO: sync hub -- should also add
        async_hub_assumptions = archi.get_async_hub_assumptions(HAS_TOK_NAME, SENDS_PREV_NAME)
        par_local_properties2 = par_local_properties
        par_local_properties = []
        for p in par_local_properties2:
            assert p.assumptions == [Bool(True)]
            p_updated_with_sync_hub = localize(SpecProperty(async_hub_assumptions, p.guarantees))
            par_local_properties.append(p_updated_with_sync_hub)

    global_property_pairs = []
    for (p,c) in par_global_property_pairs:
        inst_c = min(c, cutoff)
        inst_p = inst_property(p, inst_c)
        opt_inst_p = apply_log_bit_scheduler_optimization(inst_p, scheduler, SCHED_ID_PREFIX, inst_c)

        global_property_pairs.append((opt_inst_p, inst_c))

    local_properties = []
    for p in par_local_properties:
        inst_p = inst_property(p, 2)
        opt_inst_p = apply_log_bit_scheduler_optimization(inst_p, scheduler, SCHED_ID_PREFIX, 2)

        local_properties.append(opt_inst_p)

    print('-'*80)
    print('local properties', local_properties)
    print('-'*10)
    print('global properties', global_property_pairs)

    local_automaton = None
    if len(local_properties) > 0:
        local_property = and_properties(local_properties)
        local_automaton = ltl2ucw_converter.convert(expr_from_property(local_property))

    glob_automatae_pairs = []
    if len(global_property_pairs) > 0:
        glob_automatae_pairs = [(ltl2ucw_converter.convert(expr_from_property(p)), c)
                                for p,c in global_property_pairs]

    if OPTS[optimization] < OPTS[SYNC_HUB] and local_automaton:
        if optimization == ASYNC_HUB:
            glob_automatae_pairs += [(local_automaton, 1)]
        else:
            glob_automatae_pairs += [(local_automaton, 2)]

    sync_automaton = None
    if optimization >= SYNC_HUB:
        sync_automaton = local_automaton

    print('SYNC_AUTOMATON', sync_automaton.name if sync_automaton else 'None')
    print()
    for a,c in glob_automatae_pairs:
        print('{0}\n{1}\n'.format(a.name, c))


    _run(is_moore,
        anon_inputs, anon_outputs,
        sync_automaton, glob_automatae_pairs,
        bounds,
        z3solver,
        logic,
        smt_files_prefix, dot_files_prefix, logger)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Parametrized Synthesis Tool for token rings architecture')
    parser.add_argument('ltl', metavar='ltl', type=FileType(),
        help='LTL file with parameterized specification')
    parser.add_argument('--moore', action='store_true', required=False, default=False,
        help='treat the spec as Moore and produce Moore machine')
    parser.add_argument('--dot', metavar='dot', type=str, required=False,
        help='writes the output into a dot graph files prefixed with this prefix')
    parser.add_argument('--bound', metavar='bound', type=int, default=2, required=False,
        help='upper bound on the size of local process (default: %(default)i)')
    parser.add_argument('--size', metavar='size', type=int, default=None, required=False,
        help='exact size of the process implementation(default: %(default)i)')
    parser.add_argument('--cutoff', metavar='cutoff', type=int, default=sys.maxsize, required=True,
        help='force specified cutoff size')
    parser.add_argument('-v', '--verbose', action='count', default=0)

    parser.add_argument('--opt', choices=tuple(OPTS.keys()), required=False, default=NO)

    args = parser.parse_args(sys.argv[1:])

    logger = setup_logging(args.verbose)

    logger.debug(args)

    ltl2ucw_converter, z3solver = create_spec_converter_z3()

    bounds = list(range(2, args.bound + 1) if args.size is None else range(args.size, args.size + 1))

    logic = UFLIA(None)

    with tempfile.NamedTemporaryFile(delete=False, dir='./') as smt_file:
        smt_files_prefix = smt_file.name

    logger.info('temp file prefix used is %s', smt_files_prefix)

    main(args.ltl.read(),
        args.opt,
        args.moore,
        smt_files_prefix,
        args.dot,
        bounds,
        args.cutoff,
        ltl2ucw_converter, z3solver,
        logic,
        logger)


#    main()

#    profile_file_name = 'profile_data'
#
#    cProfile.run('tmp()', filename=profile_file_name)
#    p = pstats.Stats(profile_file_name)
#
#    p.sort_stats('cumulative').print_stats(15)






#def main_with_sync_hub(smt_file_name, logic, spec_type, is_moore, dot_files_prefix, bounds, cutoff, automaton_converter, solver, logger):
#    logger.info('sync hub')
#
#    #TODO: check two cases: when on SMT level and when here
##    hub_par_assumption = 'G((!{tok}i) -> F{prev}i) && G({tok}i -> !{prev}i)'.format(
##        tok = HAS_TOK_NAME,
##        prev = SENDS_PREV_NAME)
##
##    loc_property = '(({orig_loc_assumption} && {hub}) -> ({orig_loc_guarantee} && {tok_ring_guarantee}))'.format(
##        orig_loc_assumption = orig_loc_assumption,
##        orig_loc_guarantee = orig_loc_guarantee,
##        hub=hub_par_assumption,
##        tok_ring_guarantee = get_tok_rings_liveness_par_props()[0])
#
#
#    anon_inputs, anon_outputs,\
#    safety_loc_assumption, liveness_loc_assumption,\
#    safety_loc_guarantee, liveness_loc_guarantee,\
#    orig_glob_property = _get_spec(spec_type)
#
#    par_hub_safety_ass = 'G({tok}i -> !{prev}i)'.format(
#        tok = HAS_TOK_NAME,
#        prev = SENDS_PREV_NAME)
#
#    loc_safety_part = '(({loc_safety_ass}) && ({loc_hub_safety_ass})) -> ({loc_safety_gua})'.format(
#        loc_safety_ass = safety_loc_assumption,
#        loc_safety_gua = safety_loc_guarantee,
#        loc_hub_safety_ass = par_hub_safety_ass
#    )
#
#    par_hub_liveness_ass = 'G((!{tok}i) -> F({prev}i && {active}i))'.format(
#        tok = HAS_TOK_NAME,
#        prev = SENDS_PREV_NAME,
#        active = ACTIVE_NAME)
#
#    loc_liveness_part = '(({loc_safety_ass}) && ({loc_liveness_ass}) && ({hub_safety_ass}) && ({hub_liveness_ass})) -> (({loc_spec_liveness_gua}) && ({loc_tok_ring_liveness_gua}))'.format(
#        loc_safety_ass = safety_loc_assumption,
#        loc_liveness_ass = liveness_loc_assumption,
#        loc_spec_liveness_gua = liveness_loc_guarantee,
#        hub_safety_ass = par_hub_safety_ass,
#        hub_liveness_ass = par_hub_liveness_ass,
#        loc_tok_ring_liveness_gua = get_tok_rings_liveness_par_props()[0]
#    )
#
#    loc_property = '({loc_liveness_part}) && ({loc_safety_part})'.format(
#        loc_liveness_part = loc_liveness_part,
#        loc_safety_part = loc_safety_part
#    )
#
#    loc_property = anonymize_property(loc_property, anon_inputs+anon_outputs+list(chain(*get_tok_ring_par_io())))
#    loc_property = loc_property.replace(ACTIVE_NAME+'i', 'true') #hack: no need for active_i in sync_hub version
#
#    glob_property = '({loc_safety_ass}) -> ({glob})'.format( #hack: i know that glob is a safety property
#        loc_safety_ass = instantiate_formula(safety_loc_assumption, 1),
#        glob = instantiate_formula(orig_glob_property, cutoff)
#    )
#
#    loc_automaton = automaton_converter.convert(loc_property)
#    global_automaton = automaton_converter.convert(glob_property)
#
#    global_automatae_pairs = [(global_automaton, cutoff)]
#
#    _run(logger,
#        is_moore,
#        logic,
#        global_automatae_pairs,
#        loc_automaton,
#        anon_inputs, anon_outputs,
#        bounds,
#        solver,
#        smt_file_name, dot_files_prefix)
#
#
#def main_with_async_hub(smt_file_prefix,
#                        logic,
#                        spec_type,is_moore,
#                        dot_files_prefix,
#                        bounds,
#                        cutoff,
#                        automaton_converter,
#                        solver,
#                        logger):
#    logger.info('async_hub')
#
#    anon_inputs, anon_outputs,\
#    safety_loc_assumption, liveness_loc_assumption,\
#    safety_loc_guarantee, liveness_loc_guarantee,\
#    orig_glob_property = _get_spec(spec_type)
#
#    loc_safety_assumption = '{loc_safety_ass}'.format(
#        loc_safety_ass = instantiate_formula(safety_loc_assumption, 1)
#    )
#
#    loc_safety_guarantee = '{loc_safety_gua}'.format(
#        loc_safety_gua = instantiate_formula(safety_loc_guarantee, 1)
#    )
#
#    par_hub_safety_ass = 'G({tok}i -> !{prev}i)'.format(
#        tok = HAS_TOK_NAME,
#        prev = SENDS_PREV_NAME)
#
#    loc_safety_part = '(({loc_safety_ass}) && ({loc_hub_safety_ass})) -> ({loc_safety_gua})'.format(
#        loc_safety_ass = loc_safety_assumption,
#        loc_safety_gua = loc_safety_guarantee,
#        loc_hub_safety_ass = instantiate_formula(par_hub_safety_ass, 1)
#    )
#
#    par_hub_liveness_ass = 'G((!{tok}i) -> F({prev}i && {active}i))'.format(
#        tok = HAS_TOK_NAME,
#        prev = SENDS_PREV_NAME,
#        active = ACTIVE_NAME)
#
#    loc_liveness_part = '(({fair_sched}) && ({loc_safety_ass}) && ({loc_liveness_ass}) && ({hub_safety_ass}) && ({hub_liveness_ass})) -> (({loc_spec_liveness_gua}) && ({loc_tok_ring_liveness_gua}))'.format(
#        fair_sched = get_inf_sched_prop(0, 1, SCHED_ID_PREFIX),
#        loc_safety_ass = loc_safety_assumption,
#        loc_liveness_ass = instantiate_formula(liveness_loc_assumption, 1),
#        loc_spec_liveness_gua = instantiate_formula(liveness_loc_guarantee, 1),
#        hub_safety_ass = instantiate_formula(par_hub_safety_ass, 1),
#        hub_liveness_ass = instantiate_formula(par_hub_liveness_ass, 1),
#        loc_tok_ring_liveness_gua = instantiate_formula(get_tok_rings_liveness_par_props()[0], 1)
#    )
#
#    loc_property = '({loc_liveness_part}) && ({loc_safety_part})'.format(
#        loc_liveness_part = loc_liveness_part,
#        loc_safety_part = loc_safety_part
#    )
#
#    glob_property = '({loc_safety_ass}) -> ({glob})'.format( #hack: i know that glob is a safety property
#        loc_safety_ass = loc_safety_assumption,
#        glob = instantiate_formula(orig_glob_property, cutoff)
#    )
#
#    ring_with_hub_automaton = automaton_converter.convert(loc_property)
#    global_automaton = automaton_converter.convert(glob_property)
#
#    global_automatae_pairs = [(global_automaton, cutoff), (ring_with_hub_automaton, 1)]
#
#    _run(logger,
#        is_moore,
#        logic,
#        global_automatae_pairs,
#        None,
#        anon_inputs, anon_outputs,
#        bounds,
#        solver,
#        smt_file_prefix, dot_files_prefix)



#def _build_archi_property(archi:TokRingArchitecture, loc_assumptions):
#    # Safety properties of token rings architecture are added on SMT level
#    # they are conjuncted to the original spec
#    assert archi.spec_rank == 1, 'unsupported: architecture spec is _not 1-indexed'
#
#    loc_assumptions = list(loc_assumptions)
#
#    s_ass_list = [a for a in loc_assumptions if is_safety(a)]
#    l_ass_list = [a for a in loc_assumptions if a not in s_ass_list]
#
#    inst_s_ass = instantiate_formula(and_properties(s_ass_list), 1)
#    inst_l_ass = instantiate_formula(and_properties(l_ass_list), 1)
#
#    inst_archi_ass = archi.inst_ass(1)
#    inst_archi_gua = archi.inst_gua(1)
#
#    values_map = {
#        'inst_s_ass':inst_s_ass,
#        'inst_l_ass':inst_l_ass,
#        'inst_archi_ass':inst_archi_ass,
#        'inst_archi_gua':inst_archi_gua
#    }
#
#    archi_tok_released = '(({inst_archi_ass}) && ({inst_s_ass}) && ({inst_l_ass})) -> ({inst_archi_gua})'.format_map(
#        values_map
#    )#def _build_archi_property(archi:TokRingArchitecture, loc_assumptions):
#    # Safety properties of token rings architecture are added on SMT level
#    # they are conjuncted to the original spec
#    assert archi.spec_rank == 1, 'unsupported: architecture spec is _not 1-indexed'
#
#    loc_assumptions = list(loc_assumptions)
#
#    s_ass_list = [a for a in loc_assumptions if is_safety(a)]
#    l_ass_list = [a for a in loc_assumptions if a not in s_ass_list]
#
#    inst_s_ass = instantiate_formula(and_properties(s_ass_list), 1)
#    inst_l_ass = instantiate_formula(and_properties(l_ass_list), 1)
#
#    inst_archi_ass = archi.inst_ass(1)
#    inst_archi_gua = archi.inst_gua(1)
#
#    values_map = {
#        'inst_s_ass':inst_s_ass,
#        'inst_l_ass':inst_l_ass,
#        'inst_archi_ass':inst_archi_ass,
#        'inst_archi_gua':inst_archi_gua
#    }
#
#    archi_tok_released = '(({inst_archi_ass}) && ({inst_s_ass}) && ({inst_l_ass})) -> ({inst_archi_gua})'.format_map(
#        values_map
#    )
#
#    return archi_tok_released

#
#    return archi_tok_released


#def _build_loc_property_with_archi(loc_property:SpecProperty,
#                                   archi,
#                                   logger:Logger):
#    #TODO: i don't like raw applications of '&&'
#    assert loc_property.rank == 1, 'local'
#    assert archi.spec_rank == 1, 'unsupported architecture'
#    assert not is_safety(archi.inst_ass(1)), 'architectures with safety assumptions are not supported'
#
#    s_ass_list = [a for a in loc_property.assumptions if is_safety(a)]
#    s_gua_list = [g for g in loc_property.guarantees if is_safety(g)]
#
#    l_ass_list = [a for a in loc_property.assumptions if a not in s_ass_list]
#    l_gua_list = [g for g in loc_property.guarantees if g not in s_gua_list]
#
#    logger.debug('safety assumptions are: {0}', s_ass_list)
#    logger.debug('safety guarantees are: {0}', s_gua_list)
#    logger.debug('liveness assumptions are: {0}', l_ass_list)
#    logger.debug('liveness guarantees are: {0}', l_gua_list)
#
#    inst_s_ass = instantiate_formula(and_properties(s_ass_list), 1)
#    inst_s_gua = instantiate_formula(and_properties(s_gua_list), 1)
#
#    inst_l_ass = instantiate_formula(and_properties(l_ass_list), 1)
#    inst_l_gua = instantiate_formula(and_properties(l_gua_list), 1)
#
#    values_map = {
#        'inst_s_ass':inst_s_ass,
#        'inst_s_gua':inst_s_gua,
#        'inst_l_ass':inst_l_ass,
#        'inst_l_gua':inst_l_gua,
#        'inst_archi_ass':archi.inst_ass(1)
#        }
#
#    inst_s_part = '(({inst_s_ass}) -> ({inst_s_gua})'.format_map(values_map)
#    inst_l_part = '(({archi_ass}) && ({inst_s_ass}) && ({inst_l_ass})) -> ({inst_l_gua})'.format_map(values_map)
#
#    updated_property = '({inst_l_part}) && ({inst_s_part})'.format(
#        inst_l_part = inst_l_part,
#        loc_safety_part = inst_s_part
#    )
#
#    return updated_property






#
#def main_compo(smt_file_prefix, logic, spec_type, is_moore, dot_files_prefix, bounds, cutoff, automaton_converter, solver, logger):
#    logger.info('compositional approach')
#
#    anon_inputs, anon_outputs,\
#    safety_loc_assumption, liveness_loc_assumption,\
#    safety_loc_guarantee, liveness_loc_guarantee,\
#    orig_glob_property = _get_spec(spec_type)
#
#    loc_safety_assumption = '{loc_safety_ass}'.format(
#        loc_safety_ass = instantiate_formula(safety_loc_assumption, 1)
#    )
#
#    loc_safety_guarantee = '{loc_safety_gua}'.format(
#        loc_safety_gua = instantiate_formula(safety_loc_guarantee, 1)
#    )
#
#    loc_safety_part = '({loc_safety_ass}) -> ({loc_safety_gua})'.format(
#        loc_safety_ass = loc_safety_assumption,
#        loc_safety_gua = loc_safety_guarantee
#    )
#
#    par_fair_token = 'GF({tok}i)'.format(
#        tok=HAS_TOK_NAME,
#        prev=SENDS_PREV_NAME)
#
#    loc_tok_ring_liveness_part = '(({fair_sched}) && ({loc_safety_ass}) && ({loc_liveness_ass})) -> ({loc_tok_ring_liveness_gua})'.format(
#        fair_sched = get_inf_sched_prop(0, 2, SCHED_ID_PREFIX),
#        loc_safety_ass = loc_safety_assumption,
#        loc_liveness_ass = instantiate_formula(liveness_loc_assumption, 1),
#        loc_tok_ring_liveness_gua = instantiate_formula(get_tok_rings_liveness_par_props()[0], 1)
#    )
#
#    loc_spec_liveness_part = '(({fair_sched}) && ({fair_tok}) && ({loc_safety_ass}) && ({loc_liveness_ass})) -> ({loc_spec_liveness_gua})'.format(
#        fair_sched = get_inf_sched_prop(0, 2, SCHED_ID_PREFIX),
#        fair_tok = instantiate_formula(par_fair_token, 1),
#        loc_safety_ass = loc_safety_assumption,
#        loc_liveness_ass = instantiate_formula(liveness_loc_assumption, 1),
#        loc_spec_liveness_gua = instantiate_formula(liveness_loc_guarantee, 1)
#    )
#
#    loc_liveness_part = '({loc_spec_liveness_part}) && ({loc_tok_ring_liveness_part})'.format(
#        loc_spec_liveness_part = loc_spec_liveness_part,
#        loc_tok_ring_liveness_part = loc_tok_ring_liveness_part
#    )
#
#    loc_property = '({loc_liveness_part}) && ({loc_safety_part})'.format(
#        loc_liveness_part = loc_liveness_part ,
#        loc_safety_part = loc_safety_part
#    )
#
#    glob_property = '({loc_safety_ass}) -> ({glob})'.format( #hack: i know that glob is a safety property
#        loc_safety_ass = loc_safety_assumption,
#        glob = instantiate_formula(orig_glob_property, cutoff)
#    )
#
#    loc_automaton = automaton_converter.convert(loc_property)
#    global_automaton = automaton_converter.convert(glob_property)
#
#    automatae = [(loc_automaton, 2), (global_automaton, cutoff)]
#
#    _run(logger,
#        is_moore,
#        logic, automatae, None, anon_inputs, anon_outputs,
#        bounds,
#        solver,
#        smt_file_prefix, dot_files_prefix)


#def main_strengthening(smt_file_name, logic, spec_type, is_moore, dot_files_prefix, bounds, cutoff, automaton_converter, solver, logger):
#    logger.info('strengthening approach')
#
#    anon_inputs, anon_outputs,\
#    safety_loc_assumption, liveness_loc_assumption,\
#    safety_loc_guarantee, liveness_loc_guarantee,\
#    orig_glob_property = _get_spec(spec_type)
#
#    loc_safety_assumption = '{loc_safety_ass}'.format(
#        loc_safety_ass = instantiate_formula(safety_loc_assumption, 1)
#    )
#
#    loc_safety_guarantee = '{loc_safety_gua}'.format(
#        loc_safety_gua = instantiate_formula(safety_loc_guarantee, 1)
#    )
#
#    loc_safety_part = '({loc_safety_ass}) -> ({loc_safety_gua})'.format(
#        loc_safety_ass = loc_safety_assumption,
#        loc_safety_gua = loc_safety_guarantee
#    )
#
#    par_fair_token = 'GF({tok}i)'.format(
#        tok=HAS_TOK_NAME,
#        prev=SENDS_PREV_NAME)
#
#    loc_tok_ring_liveness_part = '(({fair_sched}) && ({loc_safety_ass}) && ({loc_liveness_ass})) -> ({loc_tok_ring_liveness_gua})'.format(
#        fair_sched = get_inf_sched_prop(0, cutoff, SCHED_ID_PREFIX),
#        loc_safety_ass = loc_safety_assumption,
#        loc_liveness_ass = instantiate_formula(liveness_loc_assumption, 1),
#        loc_tok_ring_liveness_gua = instantiate_formula(get_tok_rings_liveness_par_props()[0], 1)
#    )
#
#    loc_spec_liveness_part = '(({fair_sched}) && ({fair_tok}) && ({loc_safety_ass}) && ({loc_liveness_ass})) -> ({loc_spec_liveness_gua})'.format(
#        fair_sched = get_inf_sched_prop(0, cutoff, SCHED_ID_PREFIX),
#        fair_tok = instantiate_formula(par_fair_token, 1),
#        loc_safety_ass = loc_safety_assumption,
#        loc_liveness_ass = instantiate_formula(liveness_loc_assumption, 1),
#        loc_spec_liveness_gua = instantiate_formula(liveness_loc_guarantee, 1)
#    )
#
#    loc_liveness_part = '({loc_spec_liveness_part}) && ({loc_tok_ring_liveness_part})'.format(
#        loc_spec_liveness_part = loc_spec_liveness_part,
#        loc_tok_ring_liveness_part = loc_tok_ring_liveness_part
#    )
#
#    loc_part = '({loc_liveness_part}) && ({loc_safety_part})'.format(
#        loc_liveness_part = loc_liveness_part,
#        loc_safety_part = loc_safety_part
#    )
#
#    glob_part = '({loc_safety_ass}) -> ({glob})'.format( #hack: i know that glob is a safety property
#        loc_safety_ass = loc_safety_assumption,
#        glob = instantiate_formula(orig_glob_property, cutoff)
#    )
#
#    glob_property = '({loc_part}) && ({glob_part})'.format(
#        glob_part = glob_part,
#        loc_part = loc_part)
#
#    automaton = automaton_converter.convert(glob_property)
#
#    automaton_size_pairs = [(automaton, cutoff)]
#
#    _run(logger,
#        is_moore,
#        logic, automaton_size_pairs,
#        None,
#        anon_inputs, anon_outputs,
#        bounds,
#        solver,
#        smt_file_name, dot_files_prefix)


#def main_bottomup(smt_file_name, logic, spec_type,is_moore, dot_files_prefix, bounds, cutoff, automaton_converter, solver, logger):
#    logger.info('bottom-up approach')
#
#    anon_inputs, anon_outputs, \
#    safety_loc_assumption, liveness_loc_assumption,\
#    safety_loc_guarantee, liveness_loc_guarantee,\
#    orig_glob_property = _get_spec(spec_type)
#
#    ass = '({fair_sched}) && ({safety_ass}) && ({liveness_ass})'.format(
#        fair_sched = get_fair_sched_prop(cutoff, SCHED_ID_PREFIX),
#        safety_ass = instantiate_formula(safety_loc_assumption, cutoff),
#        liveness_ass = instantiate_formula(liveness_loc_assumption, cutoff)
#    )
#
#    gua = '({safety_loc_gua}) && ({liveness_loc_gua}) && ({glob}) && ({tok_ring_gua})'.format(
#        safety_loc_gua = instantiate_formula(safety_loc_guarantee, 1), #1 - due to isomorphism
#        liveness_loc_gua = instantiate_formula(liveness_loc_guarantee, 1),
#        glob = instantiate_formula(orig_glob_property, cutoff),
#        tok_ring_gua = instantiate_formula(get_tok_rings_liveness_par_props()[0], 1)
#    )
#
#    glob_property = '({ass}) -> ({gua})'.format(ass = ass, gua = gua)
#
#    automaton = automaton_converter.convert(glob_property)
#
#    automaton_size_pairs = [(automaton, cutoff)]
#
#    _run(logger,
#        is_moore,
#        logic, automaton_size_pairs,
#        None,
#        anon_inputs, anon_outputs,
#        bounds,
#        solver,
#        smt_file_name, dot_files_prefix)


#_OPT_TO_MAIN = {'sync_hub':main_with_sync_hub,
#                'async_hub':main_with_async_hub,
#                'compo':main_compo,
#                'strength':main_strengthening,
#                'bottomup':main_bottomup}

