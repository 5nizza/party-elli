#!/usr/bin/env python3
import argparse
import importlib
import os
import sys
import tempfile

from helpers import automata_helper
from helpers.main_helper import setup_logging, create_spec_converter_z3, remove_files_prefixed
from interfaces.automata import Automaton
from interfaces.parser_expr import Signal
from module_generation.dot import lts_to_dot
from synthesis import original_model_searcher
from synthesis.funcs_args_types_names import ARG_MODEL_STATE
from synthesis.smt_logic import UFLIA
from automata_translations.ltl2automaton import LTL3BA


def _write_out(model, is_moore, file_type, file_name):
    with open(file_name + '.' + file_type, 'w') as out:
        out.write(model)

        logger.info('{model_type} model is written to {file}'.format(
            model_type=['Mealy', 'Moore'][is_moore],
            file=out.name))


def _parse_spec(spec_file_name:str):
    # TODO: do not allow upper letters in the spec
    code_dir = os.path.dirname(spec_file_name)
    code_file = os.path.basename(spec_file_name.strip('.py'))

    sys.path.append(code_dir)

    saved_path = sys.path  # to ensure we import the right file
                           # (imagine you want /tmp/spec.py but there is also ./spec.py,
                           # then python prioritizes to ./spec.py)
                           # To force the right version we change sys.path temporarily.
    sys.path = [code_dir]
    spec = importlib.import_module(code_file)
    sys.path = saved_path

    return [Signal(s) for s in spec.inputs], \
           [Signal(s) for s in spec.outputs], \
           getattr(spec,'S_a_init', None),\
           getattr(spec,'S_a_trans', None),\
           getattr(spec,'L_a_property', None), \
           getattr(spec,'S_g_init', None), \
           getattr(spec,'S_g_trans', None), \
           getattr(spec,'L_g_property', None)


def _log_automata1(a:Automaton):
    logger.debug('automaton (dot) is:\n' + automata_helper.to_dot(a))
    logger.debug(a)


def weak_until(a, b):
    return '( (({a}) U ({b})) || (G !({b})) )'.format(a=a, b=b)


def convert_into_formula(S_a_init, S_g_init,
                         S_a_trans, S_g_trans,
                         L_a_property, L_g_property):
    template = '( ({S_a_init}) -> ({S_g_init}) )  &&  ' + \
               weak_until(S_g_trans, '!(%s)' % S_a_trans) + '  &&  ' \
               '( ({S_a_init}) && G ({S_a_trans}) && ({L_a_property})  ->  ({L_g_property}))'

    return template.format(S_a_init=S_a_init or 'true', S_g_init=S_g_init or 'true',
                           S_a_trans=S_a_trans or 'true', S_g_trans=S_g_trans or 'true',
                           L_a_property=L_a_property or 'true', L_g_property=L_g_property or 'true')


def main(spec_file_name:str,
         is_moore,
         dot_file_name,
         bounds,
         ltl2ucw_converter:LTL3BA,
         underlying_solver,
         encoding):
    """ :return: is realizable? """

    input_signals, \
    output_signals, \
    S_a_init, S_a_trans, L_a_property, \
    S_g_init, S_g_trans, L_g_property, \
        = _parse_spec(spec_file_name)

    assert input_signals or output_signals

    signal_by_name = dict((s.name,s) for s in input_signals + output_signals)

    spec = convert_into_formula(S_a_init, S_g_init,
                                S_a_trans, S_g_trans,
                                L_a_property, L_g_property)

    logger.info('the final spec is:\n' + spec)

    automaton = ltl2ucw_converter.convert_raw('!(%s)' % spec, signal_by_name, '')

    # goal_converter = GoalConverter(config.GOAL)
    # automaton = goal_converter.convert_to_nondeterministic('!(%s)' % spec, signal_by_name, 'spec_')

    _log_automata1(automaton)

    # TODO: check others satisfy the pre of the encoder

    # TODO: use model_searcher instead
    model = original_model_searcher.search(automaton,
                                           not is_moore,
                                           input_signals, output_signals,
                                           bounds,
                                           underlying_solver,
                                           UFLIA(None))

    is_realizable = model is not None

    logger.info(['unrealizable', 'realizable'][is_realizable])

    if is_realizable:
        # combined_model = combine_model(S_a, S_g, L_a, L_g, model, input_signals)

        dot_model = lts_to_dot(model, [ARG_MODEL_STATE], not is_moore)

        if not dot_file_name:
            logger.info(dot_model)
        else:
            _write_out(dot_model, is_moore, 'dot', dot_file_name)

    return is_realizable


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Bounded Synthesis Tool')
    parser.add_argument('ltl', metavar='ltl', type=str,
                        help='the specification file')

    group = parser.add_mutually_exclusive_group()
    group.add_argument('--moore', action='store_true', required=False,
                       help='treat the spec as Moore and produce Moore machine')
    group.add_argument('--mealy', action='store_false', required=False,
                       help='treat the spec as Mealy and produce Mealy machine')

    parser.add_argument('--dot', metavar='dot', type=str, required=False,
                        help='writes the output into a dot graph file')

    parser.add_argument('--log', metavar='log', type=str, required=False,
                        default=None,
                        help='name of the log file')

    group_bound = parser.add_mutually_exclusive_group()
    group_bound.add_argument('--bound', metavar='bound', type=int, default=128, required=False,
                             help='upper bound on the size of local process (default: %(default)i)')
    group_bound.add_argument('--size', metavar='size', type=int, default=0, required=False,
                             help='exact size of the process implementation(default: %(default)i)')

    parser.add_argument('--tmp', action='store_true', required=False, default=False,
                        help='keep temporary smt2 files')
    parser.add_argument('-v', '--verbose', action='count', default=0)

    args = parser.parse_args()

    logger = setup_logging(args.verbose, args.log)

    logger.info(args)

    with tempfile.NamedTemporaryFile(dir='./') as smt_file:
        smt_files_prefix = smt_file.name

    logic = UFLIA(None)
    ltl2ucw_converter, solver_factory = create_spec_converter_z3(logger, logic, False, smt_files_prefix)
    if not ltl2ucw_converter or not solver_factory:
        exit(1)

    bounds = list(range(1, args.bound + 1) if args.size == 0
                  else range(args.size, args.size + 1))

    is_realizable = main(args.ltl,
                         args.moore, args.dot, bounds,
                         ltl2ucw_converter,
                         solver_factory.create())

    if not args.tmp:
        remove_files_prefixed(smt_files_prefix.split('/')[-1])

    exit(0 if is_realizable else 1)
