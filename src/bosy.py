#!/usr/bin/env python3
import argparse
import logging
import sys
import tempfile

from helpers.main_helper import setup_logging, create_spec_converter_z3, remove_files_prefixed
from interfaces.parser_expr import BinOp, and_expressions, UnaryOp, ForallExpr, Expr
from interfaces.spec import SpecProperty, to_expr, and_properties
from module_generation.dot import to_dot, moore_to_dot
from module_generation.nusmv import to_boolean_nusmv
from parsing import acacia_parser, anzu_parser
from parsing.anzu_lexer_desc import ANZU_OUTPUT_VARIABLES, ANZU_INPUT_VARIABLES, ANZU_ENV_INITIAL, ANZU_SYS_INITIAL, ANZU_SYS_TRANSITIONS, ANZU_SYS_FAIRNESS, ANZU_ENV_FAIRNESS, ANZU_ENV_TRANSITIONS
from spec_optimizer.optimizations import strengthen_many
from synthesis import generic_smt_encoder
from synthesis.solitary_model_searcher import search
from synthesis.smt_logic import UFLIA
from translation2uct.ltl2automaton import Ltl2UCW


converter = None

NO, STRENGTH = 'no', 'strength'
OPTS = {NO: 0, STRENGTH: 1}

SPEC_TYPES = ANZU, ACACIA = 'anzu', 'acacia'


#TODO: implement safety-liveness separation
def _weak_until(guarantee, not_assumption):
    return BinOp('+',
                 BinOp('U', guarantee, not_assumption),
                 UnaryOp('G', guarantee))


def _get_acacia_spec(ltl_text:str, part_text:str, weak_until:bool, logger:logging.Logger) -> (list, list, list):
    """
    :return: inputs, outputs, spec_properties

    :param weak_until: ...TBD...
    """

    input_signals, output_signals, data_by_name = acacia_parser.parse(ltl_text, part_text, logger)

    if data_by_name is None:
        return [], [], []

    spec_properties = []
    for (unit_name, unit_data) in data_by_name.items():
        assumptions = unit_data[0]
        guarantees = unit_data[1]

        if weak_until:
            assert False, 'not supported'
            # guarantee = _weak_until(
            #     and_expressions(guarantees),
            #     _neg(and_expressions(assumptions)))
            #
            # spec_properties.append(SpecProperty([], [guarantee]))
        else:
            spec_properties.append(SpecProperty(assumptions, guarantees))

    return input_signals, output_signals, spec_properties


def _write_out(model, is_moore, file_type, file_name, logger):
    with open(file_name + '.' + file_type, 'w') as out:
        out.write(model)

        logger.info('{model_type} model is written to {file}'.format(
            model_type=['Mealy', 'Moore'][is_moore],
            file=out.name))


def _empty_quantify(spec_property:SpecProperty):
    quantified_assumptions = [ForallExpr([], e) for e in spec_property.assumptions]
    quantified_quantifiers = [ForallExpr([], e) for e in spec_property.guarantees]

    return SpecProperty(quantified_assumptions, quantified_quantifiers)


def _analyze_props(name:str, class_name:str, props, ltl2ucw):
    logger.info('analyzing %s', name)

    for p in props:
        #: :type: SpecProperty
        p = p

        logger.info('looking at %s property: %s', class_name, str(p))

        logger.info('number of assumptions is %s', str(len(p.assumptions)))

        for a in p.assumptions:
            logger.info('looking at assumption %s', str(a))

            automaton = ltl2ucw.convert(a)
            logger.info('the automaton has %s nodes', str(len(automaton.nodes)))
            logger.info('the automaton name is %s', automaton.name)

            assert len(automaton.initial_sets_list) == 1
            assert len(automaton.initial_sets_list[0]) == 1
            print()

        for g in p.guarantees:
            logger.info('looking at guarantee %s', str(g))

            automaton = ltl2ucw.convert(g)
            logger.info('the automaton has %s nodes', str(len(automaton.nodes)))
            logger.info('the automaton name is %s', automaton.name)

            assert len(automaton.initial_sets_list) == 1
            assert len(automaton.initial_sets_list[0]) == 1
            print()
            #: :type: Node
            # node = list(automaton.initial_sets_list[0])[0]
            # print(node.transitions)
        logger.info('\n' * 5)


def analyze_properties(pseudo_safety_props, pseudo_liveness_props, ltl2ucw:Ltl2UCW):
    logger.info('\n' * 40)

    _analyze_props('pseudo safety properties', 'safety', pseudo_safety_props, ltl2ucw)
    logger.info('\n' * 10)
    _analyze_props('pseudo liveness properties', 'liveness', pseudo_liveness_props, ltl2ucw)


def _neg(expr):
    return UnaryOp('!', expr)


def _remove_G(safety_expressions:list) -> list:
    assert 0


def _get_anzu_spec(ltl_text:str, use_weak_until:bool, logger) -> (list, list, list):
    section_by_name = anzu_parser.parse_ltl(ltl_text, logger)

    input_signals, output_signals = section_by_name[ANZU_INPUT_VARIABLES], section_by_name[ANZU_OUTPUT_VARIABLES]

    live_assumptions = section_by_name[ANZU_ENV_FAIRNESS]
    safety_assumptions = section_by_name[ANZU_ENV_TRANSITIONS]
    init_assumptions = section_by_name[ANZU_ENV_INITIAL]

    live_guarantees = section_by_name[ANZU_SYS_FAIRNESS]
    safety_guarantees = section_by_name[ANZU_SYS_TRANSITIONS]
    init_guarantees = section_by_name[ANZU_SYS_INITIAL]

    if use_weak_until:
        init_part = _weak_until(and_expressions(init_guarantees),
                                _neg(and_expressions(init_assumptions)))

        wo_G_safety_assumptions = _remove_G(safety_assumptions)
        wo_G_safety_guarantees = _remove_G(safety_guarantees)

        safety_part = _weak_until(and_expressions(safety_guarantees),
                                  _neg(and_expressions(safety_assumptions)))

        liveness_part = BinOp('->',
                              and_expressions(live_assumptions),
                              and_expressions(live_guarantees))

        init_assumptions_expr = and_expressions(init_assumptions)
        safety_assumptions_expr = and_expressions(safety_assumptions)

        properties = [SpecProperty([], [init_part]),
                      SpecProperty([init_assumptions_expr],
                                   [safety_part]),
                      SpecProperty([safety_assumptions_expr, init_assumptions_expr],
                                   [liveness_part])]

    else:
        init_part = BinOp('->',
                          and_expressions(init_assumptions),
                          and_expressions(init_guarantees))

        safety_part = BinOp('->',
                            and_expressions(safety_assumptions),
                            and_expressions(safety_guarantees))

        liveness_part = BinOp('->',
                              and_expressions(live_assumptions),
                              and_expressions(live_guarantees))

        init_assumptions_expr = and_expressions(init_assumptions)
        safety_assumptions_expr = and_expressions(safety_assumptions)

        properties = [SpecProperty([], [init_part]),
                      SpecProperty([init_assumptions_expr],
                                   [safety_part]),
                      SpecProperty([safety_assumptions_expr, init_assumptions_expr],
                                   [liveness_part])]

    return input_signals, output_signals, properties


def main(spec_type,
         ltl_text:str, part_text:str, is_moore, dot_file_name, nusmv_file_name, bounds,
         use_weak_until,
         ltl2ucw_converter, underlying_solver,
         optimization,
         logger):
    """:return: is realizable? """
    global converter
    converter = ltl2ucw_converter

    if spec_type == 'acacia':
        input_signals, output_signals, spec_properties = _get_acacia_spec(ltl_text, part_text, use_weak_until, logger)
    else:
        input_signals, output_signals, spec_properties = _get_anzu_spec(ltl_text, use_weak_until, logger)

    if not spec_properties:
        logger.info('No properties are given in the input file. Return unrealizable status.')
        return False

    if spec_type == ACACIA and OPTS[optimization] >= OPTS[STRENGTH]:
        logger.info('strengthening..')

        spec_properties = [_empty_quantify(p) for p in spec_properties]
        pseudo_safety_props, pseudo_liveness_props = strengthen_many(spec_properties, ltl2ucw_converter)

        analyze_properties(pseudo_safety_props, pseudo_liveness_props, ltl2ucw_converter)

        logger.info('-' * 80)
        logger.info('pseudo_safety_props %s\n', str(pseudo_safety_props))
        logger.info('-' * 40)
        logger.info('pseudo_liveness_props %s\n', str(pseudo_liveness_props))
        logger.info('-' * 80)

        spec_properties = pseudo_safety_props + pseudo_liveness_props
        #

    spec_property = and_properties(spec_properties)
    if not input_signals or not output_signals or not spec_property:
        return None

    automaton = ltl2ucw_converter.convert(to_expr(spec_property))
    logger.info('spec automaton has {0} states'.format(len(automaton.nodes)))

    models = search(automaton, not is_moore, input_signals, output_signals, bounds, underlying_solver, UFLIA(None))

    assert models is None or len(models) == 1

    model = models[0] if models else None
    is_realizable = model is not None

    logger.info(['unrealizable', 'realizable'][is_realizable])

    if is_realizable:
        dot_model = moore_to_dot(model) if is_moore else to_dot(model)

        if not dot_file_name:
            logger.info(dot_model)
        else:
            _write_out(dot_model, is_moore, 'dot', dot_file_name, logger)

        if nusmv_file_name:
            nusmv_model = to_boolean_nusmv(model, spec_property)
            _write_out(nusmv_model, is_moore, 'smv', nusmv_file_name, logger)

    return is_realizable


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Bounded Synthesis Tool')
    parser.add_argument('ltl', metavar='ltl', type=argparse.FileType(),
                        help='loads the LTL formula from the given input file, '
                             'also assumes existence of file with .part extension')

    group = parser.add_mutually_exclusive_group()
    group.add_argument('--moore', action='store_true', required=False,
                       help='treat the spec as Moore and produce Moore machine')
    group.add_argument('--mealy', action='store_false', required=False,
                       help='treat the spec as Mealy and produce Mealy machine')

    parser.add_argument('--dot', metavar='dot', type=str, required=False,
                        help='writes the output into a dot graph file')
    parser.add_argument('--nusmv', metavar='nusmv', type=str, required=False,
                        help='writes the output and the specification into NuSMV file')

    group_bound = parser.add_mutually_exclusive_group()
    group_bound.add_argument('--bound', metavar='bound', type=int, default=128, required=False,
                             help='upper bound on the size of local process (default: %(default)i)')
    group_bound.add_argument('--size', metavar='size', type=int, default=0, required=False,
                             help='exact size of the process implementation(default: %(default)i)')

    parser.add_argument('--tmp', action='store_true', required=False, default=False,
                        help='keep temporary smt2 files')
    parser.add_argument('--incr', action='store_true', required=False, default=False,
                        help='produce incremental queries')
    parser.add_argument('-v', '--verbose', action='count', default=0)

    parser.add_argument('-w', '--weak',
                        action='store_true', default=False,
                        help='treat assume-guarantee with weak Until operator rather than an implication (g W !a)')

    parser.add_argument('--opt', choices=sorted(list(OPTS.keys()), key=lambda v: OPTS[v]), required=False,
                        default=NO,
                        help='apply an optimization (choose one) (default: %(default)s)')

    parser.add_argument('--spec', choices=SPEC_TYPES, required=False,
                        default=ACACIA,
                        help='type of spec language')

    args = parser.parse_args(sys.argv[1:])

    logger = setup_logging(args.verbose)

    logger.info(args)

    with tempfile.NamedTemporaryFile(dir='./') as smt_file:
        smt_files_prefix = smt_file.name

    logic = UFLIA(None)
    ltl2ucw_converter, solver_factory = create_spec_converter_z3(logger, logic, args.incr, smt_files_prefix)
    if not ltl2ucw_converter or not solver_factory:
        exit(1)

    bounds = list(range(1, args.bound + 1) if args.size == 0 else range(args.size, args.size + 1))

    ltl_text = args.ltl.read()

    part_text = 'none'
    if args.spec == ACACIA:
        part_file_name = '.'.join(args.ltl.name.split('.')[:-1]) + '.part'
        with open(part_file_name) as part_file:
            part_text = part_file.read()

    generic_smt_encoder.ENCODE_INCREMENTALLY = args.incr

    is_realizable = main(args.spec,
                         ltl_text, part_text, args.moore, args.dot, args.nusmv, bounds,
                         args.weak,
                         ltl2ucw_converter,
                         solver_factory.create(),
                         args.opt,
                         logger)

    args.ltl.close()

    if not args.tmp:
        remove_files_prefixed(smt_files_prefix.split('/')[-1])

    exit(0 if is_realizable else 1)
