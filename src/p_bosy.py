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
OPTS = {NO: 0, STRENGTH: 1, ASYNC_HUB: 2, SYNC_HUB: 3}


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
                logger.info('{type} model is written to {file}'.format(
                    type=['Mealy', 'Moore'][is_moore],
                    file=out.name))


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
    spec_properties = [SpecProperty(assumptions + archi.implications(), [g]) for g in guarantees]
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

    print('-' * 80)
    print('original property')
    print('\n'.join(map(str, properties)))
    print()

    print('-' * 80)
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

    print('-' * 80)
    print('after localization')
    for p in properties:
        print(p)
    print()
    print('-' * 80)

    prop_real_cutoff_pairs = [(p, archi.get_cutoff(p)) for p in properties]

    par_local_properties = [p for (p, c) in prop_real_cutoff_pairs if c == 2]
    par_global_property_pairs = [(p, c) for (p, c) in prop_real_cutoff_pairs if p not in par_local_properties]

    if optimization == ASYNC_HUB: #TODO: sync hub -- should also add
        async_hub_assumptions = archi.get_async_hub_assumptions(HAS_TOK_NAME, SENDS_PREV_NAME)
        par_local_properties2 = par_local_properties
        par_local_properties = []
        for p in par_local_properties2:
            assert p.assumptions == [Bool(True)]
            p_updated_with_sync_hub = localize(SpecProperty(async_hub_assumptions, p.guarantees))
            par_local_properties.append(p_updated_with_sync_hub)

    global_property_pairs = []
    for (p, c) in par_global_property_pairs:
        inst_c = min(c, cutoff)
        inst_p = inst_property(p, inst_c)
        opt_inst_p = apply_log_bit_scheduler_optimization(inst_p, scheduler, SCHED_ID_PREFIX, inst_c)

        global_property_pairs.append((opt_inst_p, inst_c))

    local_properties = []
    for p in par_local_properties:
        inst_p = inst_property(p, 2)
        opt_inst_p = apply_log_bit_scheduler_optimization(inst_p, scheduler, SCHED_ID_PREFIX, 2)

        local_properties.append(opt_inst_p)

    print('-' * 80)
    print('local properties', local_properties)
    print('-' * 10)
    print('global properties', global_property_pairs)

    local_automaton = None
    if len(local_properties) > 0:
        local_property = and_properties(local_properties)
        local_automaton = ltl2ucw_converter.convert(expr_from_property(local_property))

    glob_automatae_pairs = []
    if len(global_property_pairs) > 0:
        glob_automatae_pairs = [(ltl2ucw_converter.convert(expr_from_property(p)), c)
                                for p, c in global_property_pairs]

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
    for a, c in glob_automatae_pairs:
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
                        help='output Moore machine')
    parser.add_argument('--dot', metavar='dot', type=str, required=False,
                        help='prefix of dot-graph files for output model')
    parser.add_argument('--bound', metavar='bound', type=int, default=2, required=False,
                        help='upper bound on the size of local process (default: %(default)i)')
    parser.add_argument('--size', metavar='size', type=int, default=0, required=False,
                        help='exact size of the process implementation(default: %(default)i)')
    parser.add_argument('--cutoff', metavar='cutoff', type=int, default=sys.maxsize, required=True,
                        help='force specified cutoff size')
    parser.add_argument('-v', '--verbose', action='count', default=0)

    parser.add_argument('--opt', choices=sorted(list(OPTS.keys()), key=lambda v: OPTS[v]), required=False, default=NO,
                        help='apply optimizations (default: %(default)s)')

    args = parser.parse_args(sys.argv[1:])

    logger = setup_logging(args.verbose)

    logger.debug(args)

    ltl2ucw_converter, z3solver = create_spec_converter_z3(logger)
    if not ltl2ucw_converter or not z3solver:
        exit(0)

    bounds = list(range(2, args.bound + 1) if args.size == 0 else range(args.size, args.size + 1))

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
