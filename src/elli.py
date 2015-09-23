#!/usr/bin/env python3
import argparse
from functools import lru_cache
import tempfile

from parsing import acacia_parser
from helpers import automaton2dot
from helpers.automata_classifier import is_safety_automaton
from helpers.gr1helpers import build_almost_gr1_formula
from helpers.main_helper import setup_logging, create_spec_converter_z3
from helpers.python_ext import readfile
from interfaces.expr import Expr, and_expressions, Bool
from module_generation.dot import lts_to_dot
from synthesis import model_searcher
from synthesis.encoder_builder import create_encoder
from synthesis.funcs_args_types_names import ARG_MODEL_STATE
from synthesis.smt_logic import UFLIA
from automata_translations.ltl2automaton import LTL3BA


def write_out(model, is_moore, file_type, file_name):
    with open(file_name + '.' + file_type, 'w') as out:
        out.write(model)

        logger.info('{model_type} model is written to {file}'.format(
            model_type=['Mealy', 'Moore'][is_moore],
            file=out.name))


@lru_cache()
def is_safety_ltl(expr:Expr, ltl2automaton_converter) -> bool:
    automaton = ltl2automaton_converter.convert(~expr)  # !(safety ltl) has safety automaton
    res = is_safety_automaton(automaton)
    return res


def _split_safety_liveness(formulas, ltl2automaton_converter):
    formulas = set(formulas)

    safety = set(filter(lambda f: is_safety_ltl(f, ltl2automaton_converter), formulas))
    liveness = formulas - safety

    return safety, liveness


def _get_acacia_spec(ltl_text:str, part_text:str, ltl2automaton_converter, logger) -> (list, list, Expr):
    input_signals, output_signals, data_by_name = acacia_parser.parse(ltl_text, part_text, logger)

    if data_by_name is None:
        return None, None, None

    ltl_properties = []
    for (unit_name, unit_data) in data_by_name.items():
        assumptions = unit_data[0]
        guarantees = unit_data[1]

        a_safety, a_liveness = (and_expressions(p)
                                for p in _split_safety_liveness(assumptions, ltl2automaton_converter))
        g_safety, g_liveness = (and_expressions(p)
                                for p in _split_safety_liveness(guarantees, ltl2automaton_converter))

        ltl_property = build_almost_gr1_formula(Bool(True), Bool(True),
                                                a_safety, g_safety,
                                                a_liveness, g_liveness)
        ltl_properties.append(ltl_property)

    return input_signals, output_signals, and_expressions(ltl_properties)


def parse_acacia_spec(spec_file_name:str, ltl2automaton_converter, logger):
    """ :return: (inputs_signals, output_signals, expr) """

    assert spec_file_name.endswith('.ltl'), spec_file_name
    ltl_file_str = readfile(spec_file_name)
    part_file_str = readfile(spec_file_name.replace('.ltl', '.part'))
    return _get_acacia_spec(ltl_file_str, part_file_str, ltl2automaton_converter, logger)


def parse_anzu_spec(spec_file_name:str):
    raise NotImplemented('the code is not yet taken from the original parameterized tool')


def main(spec_file_name,
         is_moore,
         dot_file_name,
         bounds,
         ltl2automaton_converter:LTL3BA,
         smt_solver,
         logger):
    parse_spec = { 'ltl': lambda f: parse_acacia_spec(f, ltl2automaton_converter, logger),
                  'cfg':parse_anzu_spec
                 }[spec_file_name.split('.')[-1]]

    input_signals, output_signals, ltl = parse_spec(spec_file_name)

    logger.info('LTL is:\n' + str(ltl))

    automaton = ltl2automaton_converter.convert(~ltl)

    logger.debug('automaton (dot) is:\n' + automaton2dot.to_dot(automaton))
    logger.debug(automaton)

    encoder = create_encoder(input_signals, output_signals,
                             is_moore,
                             automaton,
                             smt_solver, UFLIA(None))

    model = model_searcher.search(bounds, encoder)

    is_realizable = model is not None

    logger.info(['unrealizable', 'realizable'][is_realizable])

    if is_realizable:
        dot_model = lts_to_dot(model, ARG_MODEL_STATE, not is_moore)

        if not dot_file_name:
            logger.info(dot_model)
        else:
            write_out(dot_model, is_moore, 'dot', dot_file_name)

    return is_realizable


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Bounded Synthesis Tool')
    parser.add_argument('spec', metavar='spec', type=str,
                        help='the specification file (anzu, acacia+, or python format)')

    group = parser.add_mutually_exclusive_group()
    group.add_argument('--moore', action='store_true', required=False,
                       help='search a Moore machine')
    group.add_argument('--mealy', action='store_false', required=False,
                       help='search a Mealy machine')

    group = parser.add_mutually_exclusive_group()
    group.add_argument('--bound', metavar='bound', type=int, default=128, required=False,
                       help='upper bound on the size of the model (default: %(default)i)')
    group.add_argument('--size', metavar='size', type=int, default=0, required=False,
                       help='search the model of this size (default: %(default)i)')

    parser.add_argument('--incr', action='store_true', required=False, default=False,
                        help='use incremental solving')
    parser.add_argument('--tmp', action='store_true', required=False, default=False,
                        help='keep temporary smt2 files')
    parser.add_argument('--dot', metavar='dot', type=str, required=False,
                        help='writes the output into a dot graph file')
    parser.add_argument('--log', metavar='log', type=str, required=False,
                        default=None,
                        help='name of the log file')
    parser.add_argument('-v', '--verbose', action='count', default=0)

    args = parser.parse_args()

    logger = setup_logging(args.verbose, args.log)
    logger.info(args)

    if args.incr and args.tmp:
        logger.warn("--tmp --incr: incremental queries do not produce smt2 files, "
                    "so I won't save any temporal files.")

    with tempfile.NamedTemporaryFile(dir='./') as smt_file:
        smt_files_prefix = smt_file.name

    ltl2automaton_converter, solver_factory = create_spec_converter_z3(logger,
                                                                       UFLIA(None),
                                                                       args.incr,
                                                                       False,
                                                                       smt_files_prefix,
                                                                       not args.tmp)

    bounds = list(range(1, args.bound + 1)) if args.size == 0 \
        else (args.size,)

    solver = solver_factory.create()
    is_realizable = main(args.spec,
                         args.moore,
                         args.dot,
                         bounds,
                         ltl2automaton_converter,
                         solver,
                         logger)
    solver.die()

    exit(is_realizable)
