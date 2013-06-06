#!/usr/bin/env python3
import argparse
import logging
import sys
import tempfile

from helpers.main_helper import setup_logging, create_spec_converter_z3, remove_files_prefixed
from interfaces.parser_expr import BinOp, and_expressions, UnaryOp
from interfaces.spec import SpecProperty, to_expr, and_properties
from module_generation.dot import to_dot, moore_to_dot
from module_generation.nusmv import to_boolean_nusmv
from parsing import acacia_parser
from spec_optimizer.optimizations import strengthen
from synthesis import generic_smt_encoder
from synthesis.solitary_model_searcher import search
from synthesis.smt_logic import UFLIA


converter = None

NO, STRENGTH = 'no', 'strength'
OPTS = {NO: 0, STRENGTH: 1}


#TODO: implement safety-liveness separation
def _weak_until(guarantee, not_assumption):
    return BinOp('+',
                 BinOp('U', guarantee, not_assumption),
                 UnaryOp('G', guarantee))


def _get_acacia_spec(ltl_text:str, part_text:str, use_until:bool, logger:logging.Logger) -> (list, list, SpecProperty):
    """
    :param use_until: a, g treated as g W !a, rather than a->g:
        - case G(a) -> G(g) is clear -- should become: g W !a
        - other cases? canonic safety property is of the form: G(past_formula), if we could get such a canonic formula..
    """
    input_signals, output_signals, data_by_name = acacia_parser.parse(ltl_text, part_text, logger)

    if data_by_name is None:
        return None, None, None

    spec_properties = []
    for (unit_name, unit_data) in data_by_name.items():
        assumptions = unit_data[0]
        guarantees = unit_data[1]

        print('---------------- assumptions')
        for a in assumptions:
            print(a)

        print()
        print('---------------- guarantees')
        for g in guarantees:
            print(g)
        print()
        global converter

        if use_until:
            guarantee = _weak_until(
                and_expressions(guarantees),
                UnaryOp('!', and_expressions(assumptions)))
        else:
            # guarantee = BinOp('->',
            #                   UnaryOp('G', and_expressions(assumptions)),
            #                   UnaryOp('G', and_expressions(guarantees)))
            logger.info('using default ->')
            guarantee = BinOp('->',
                              and_expressions(assumptions),
                              and_expressions(guarantees))

        print()
        print(guarantee)
        print()

        automaton = converter.convert(to_expr(SpecProperty([], [guarantee])))
        logger.info('spec automaton has {0} states'.format(len(automaton.nodes)))

        # exit(0)
        #
        if not use_until:
            spec_properties.append(SpecProperty(assumptions, guarantees))
        else:

            spec_properties.append(SpecProperty(assumptions, guarantees))

    spec_property = and_properties(spec_properties)

    return input_signals, output_signals, spec_property


def _write_out(model, is_moore, file_type, file_name, logger):
    with open(file_name + '.' + file_type, 'w') as out:
        out.write(model)

        logger.info('{model_type} model is written to {file}'.format(
            model_type=['Mealy', 'Moore'][is_moore],
            file=out.name))


def _strengthen(spec_property, ltl2ucw_converter):
    logger.info('strengthening properties..')

    pseudo_safety_properties, pseudo_liveness_properties = strengthen(spec_property, ltl2ucw_converter)

    assert len(pseudo_liveness_properties) <= 1, str(pseudo_liveness_properties)
    assert len(pseudo_safety_properties) <= 1, str(pseudo_safety_properties)

    logger.info('strengthening resulted in pseudo_safety_properties (a_s -> g_s):\n"%s"\n',
                '\n'.join(map(str, pseudo_safety_properties)))
    logger.info('..and in pseudo_liveness_properties (a_s&a_l -> g_l):\n"%s"\n',
                '\n'.join(map(str, pseudo_liveness_properties)))

    spec_property = and_properties(pseudo_safety_properties + pseudo_liveness_properties)
    return spec_property


def main(ltl_text:str, part_text:str, is_moore, dot_file_name, nusmv_file_name, bounds,
         use_until,
         ltl2ucw_converter, underlying_solver,
         optimization,
         logger):
    """:return: is realizable? """
    global converter
    converter = ltl2ucw_converter
    input_signals, output_signals, spec_property = _get_acacia_spec(ltl_text, part_text, use_until, logger)

    if OPTS[optimization] >= OPTS[STRENGTH]:
        spec_property = _strengthen(spec_property, ltl2ucw_converter)

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

    parser.add_argument('-u', '--until',
                        action='store_true', default=False,
                        help='treat assume-guarantee with weak Until operator rather than an implication (g W !a)')

    parser.add_argument('--opt', choices=sorted(list(OPTS.keys()), key=lambda v: OPTS[v]), required=False,
                        default=STRENGTH,
                        help='apply an optimization (choose one) (default: %(default)s)')

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

    part_file_name = '.'.join(args.ltl.name.split('.')[:-1]) + '.part'
    with open(part_file_name) as part_file:
        part_text = part_file.read()

    generic_smt_encoder.ENCODE_INCREMENTALLY = args.incr

    is_realizable = main(ltl_text, part_text, args.moore, args.dot, args.nusmv, bounds,
                         args.until,
                         ltl2ucw_converter,
                         solver_factory.create(),
                         args.opt,
                         logger)

    args.ltl.close()

    if not args.tmp:
        remove_files_prefixed(smt_files_prefix.split('/')[-1])

    exit(0 if is_realizable else 1)
