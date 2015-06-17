#!/usr/bin/env python3
import argparse
import importlib
from itertools import product
import os
import sys
import tempfile
import benchmarks   # have to import benchmarks can use other modules in benchmarks package

from nose.tools import assert_equal

from automata_translations.goal_converter import GoalConverter
import config
from helpers import automata_helper
from helpers.console_helpers import print_red
from helpers.console_helpers import print_green
from helpers.labels_map import LabelsMap
from helpers.main_helper import setup_logging, create_spec_converter_z3, remove_files_prefixed
from interfaces.automata import Automaton, all_stimuli_that_satisfy, LABEL_TRUE, get_next_states, Label, is_satisfied
from interfaces.lts import LTS
from interfaces.parser_expr import Signal
from module_generation.dot import lts_to_dot
from synthesis import original_model_searcher
from synthesis.full_info_encoder import assert_deterministic_transition, FullInfoEncoder
from synthesis.full_info_symbolic_forall_encoder import FullInfoSymbolicForallEncoder
from synthesis.model_searcher import search
from synthesis.bfsj_encoder import BFSJEncoder
from synthesis.bfsj_symbolic_encoder import BFSJSymbolicEncoder
from synthesis.bfsj_symbolic_forall_encoder import BFSJSymbolicForallEncoder
from synthesis.full_info_symbolic_encoder import FullInfoSymbolicEncoder
from synthesis.funcs_args_types_names import ARG_S_a_STATE, ARG_S_g_STATE, ARG_L_a_STATE, ARG_L_g_STATE, \
    ARG_MODEL_STATE
from synthesis.smt_logic import UFLIA
from automata_translations.ltl2automaton import LTL3BA


BFSJ = 'bfsj'
BFSJ_SYMBOLIC = 'bfsj_symbolic'
BFSJ_SYMBOLIC_FORALL = 'bfsj_symbolic_forall'

ALL = 'all'
ALL_SYMBOLIC = 'all_symbolic'
ALL_SYMBOLIC_FORALL = 'all_symbolic_forall'

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

def _log_automata4(S_a, S_g, L_a, L_g):
    logger.debug('search: S_a (dot) is:\n' + automata_helper.to_dot(S_a))
    logger.debug(S_a)

    logger.debug('search: S_g (dot) is:\n' + automata_helper.to_dot(S_g))
    logger.debug(S_g)

    logger.debug('search: L_a (dot) is:\n' + automata_helper.to_dot(L_a))
    logger.debug(L_a)

    logger.debug('search: L_g (dot) is:\n' + automata_helper.to_dot(L_g))
    logger.debug(L_g)


def _get_tau_transition_label(s_a, s_g, l_a, l_g, m, i:Label):
    lbl = Label({ARG_S_a_STATE:s_a,
                 ARG_S_g_STATE:s_g,
                 ARG_L_a_STATE:l_a,
                 ARG_L_g_STATE:l_g,
                 ARG_MODEL_STATE:m})
    lbl.update(i)

    return lbl


def combine_model(S_a:Automaton, S_g:Automaton, L_a:Automaton, L_g:Automaton,
                  lts:LTS,
                  inputs) -> LTS:
    """
    Combines model LTS, automata into one LTS. State of the LTS is (s_a,...,l_g,m).
    As a side, the new LTS contains reachable states only.
    The outputs are copied literally from the original LTS.
    """

    processed_states = set()
    init_states = set(product(S_a.initial_nodes,
                              S_g.initial_nodes,
                              L_a.initial_nodes,
                              L_g.initial_nodes,
                              lts.init_states))
    new_states = set(init_states)

    # the difference with the original table is that
    # this new table as output contains (s_a,s_g,l_a,l_g,m)
    # while the original one contained only m
    tau_new_table = dict()  # inputs,states (excl outputs) -> new state

    while len(new_states):
        s_a,s_g,l_a,l_g,m = new_states.pop()
        processed_states.add((s_a,s_g,l_a,l_g,m))

        for i_lbl in all_stimuli_that_satisfy(LABEL_TRUE, inputs):
            val_by_out = lts.get_outputs(_get_tau_transition_label(s_a,s_g,l_a,l_g,m,i_lbl))
            word_lbl = Label(i_lbl)  # copy
            word_lbl.update(val_by_out)

            for label, dst_set_list in s_a.transitions.items():
                if not is_satisfied(label, word_lbl):
                    continue

                # assumes determinism
                assert_deterministic_transition(s_a,s_g,l_a,l_g,word_lbl)

                s_a_n = tuple(map(lambda node_flag: node_flag[0], dst_set_list[0]))[0]
                s_g_n = tuple(get_next_states(s_g, word_lbl))[0]
                l_a_n = tuple(get_next_states(l_a, word_lbl))[0]
                l_g_n = tuple(get_next_states(l_g, word_lbl))[0]

                tau_trans_label = _get_tau_transition_label(s_a,s_g,l_a,l_g,m,i_lbl)
                m_next = lts.tau_model[tau_trans_label]

                next_state = (s_a_n, s_g_n, l_a_n, l_g_n, m_next)

                tau_new_table[tau_trans_label] = next_state

                if next_state not in processed_states:
                    new_states.add(next_state)

    return LTS(init_states, lts.model_by_name, LabelsMap(tau_new_table),
               None,    # TODO: remove all together?
               lts.input_signals, lts.output_signals)


def main_sa_sg_la_lg(spec_file_name:str,
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

    # S_g = ltl2ucw_converter.convert_raw('!(%s)' % S_g_property, signal_by_name, 'sg_')
    # L_a = ltl2ucw_converter.convert_raw(L_a_property, signal_by_name, 'la_')
    # L_g = ltl2ucw_converter.convert_raw(L_g_property, signal_by_name, 'lg_')

    # TODO: GOAL does not look to produce efficient automata representations
    #       in particularly it does not squash transitions (?)

    S_a_spec = '(%s) && (G (%s))' % (S_a_init, S_a_trans)
    S_g_spec = '(%s) && (G (%s))' % (S_g_init, S_g_trans)

    goal_converter = GoalConverter(config.GOAL)
    S_a = goal_converter.convert_to_deterministic_maxacc(S_a_spec, signal_by_name, 'sa_')
    assert_equal(S_a.acc_nodes, S_a.nodes, 'all states must be accepting')

    # S_a = ltl2ucw_converter.convert_raw(S_a_spec, signal_by_name, 'sa_')
    # the ltl3ba seems to produce the same automaton
    # TODOopt: optimization: both tools produce several edges with the same (src,dst):
    #          hence, try to optimize several edges into into with a boolean expression over the label

    S_g = goal_converter.convert_to_deterministic_total_minacc('!(%s)' % S_g_spec, signal_by_name, 'sg_')
    L_a = goal_converter.convert_to_deterministic_total_minacc(L_a_property, signal_by_name, 'la_')
    L_g = goal_converter.convert_to_deterministic_total_minacc(L_g_property, signal_by_name, 'lg_')

    _log_automata4(S_a, S_g, L_a, L_g)

    # TODO: check others satisfy the pre of the encoder

    _log_automata4(S_a, S_g, L_a, L_g)

    encoder_class = {ALL:FullInfoEncoder,
                     ALL_SYMBOLIC:FullInfoSymbolicEncoder,
                     ALL_SYMBOLIC_FORALL:FullInfoSymbolicForallEncoder}\
                    [encoding]

    encoder = encoder_class(logic,
                            S_a, S_g,
                            L_a, L_g,
                            underlying_solver,
                            not is_moore,
                            input_signals,
                            output_signals,
                            0)

    model = search(bounds, encoder)

    is_realizable = model is not None

    logger.info(['unrealizable', 'realizable'][is_realizable])

    if is_realizable:
        combined_model = combine_model(S_a, S_g, L_a, L_g, model, input_signals)

        # TODO: bad -- need to propagate this order to everywhere!
        dot_combined_model = lts_to_dot(combined_model,
                                        [ARG_S_a_STATE, ARG_S_g_STATE, ARG_L_a_STATE, ARG_L_g_STATE, ARG_MODEL_STATE],
                                        not is_moore)

        if not dot_file_name:
            logger.info(dot_combined_model)
        else:
            _write_out(dot_combined_model, is_moore, 'dot', dot_file_name)

    return is_realizable

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


def assert_deterministic(L_a:Automaton):
    for n in L_a.nodes:
        for label, dst_set_list in n.transitions.items():
            assert_equal(len(dst_set_list), 1)
            dst_set = set(map(lambda node_flag: node_flag[0], dst_set_list[0]))
            assert_equal(len(dst_set), 1, str(n) + '\n' + str(label) + '\n' + str(dst_set))


def main_bfsj(spec_file_name:str,
              is_moore,
              dot_file_name,
              bounds,
              ltl2ucw_converter:LTL3BA,
              underlying_solver,
              encoding:str):
    """ :return: is realizable? """

    input_signals, \
    output_signals, \
    S_a_init, S_a_trans, L_a_property, \
    S_g_init, S_g_trans, L_g_property, \
        = _parse_spec(spec_file_name)

    assert input_signals or output_signals

    signal_by_name = dict((s.name,s) for s in input_signals + output_signals)

    template = '( ({S_a_init}) -> ({S_g_init}) )  &&  ' + \
               weak_until(S_g_trans, '!(%s)' % S_a_trans)
    safety_spec = template.format(S_a_init=S_a_init, S_g_init=S_g_init)

    logger.info('the safety spec is:\n' + safety_spec)

    safety_automaton = ltl2ucw_converter.convert_raw('!(%s)' % safety_spec, signal_by_name, 's_')
    L_a = ltl2ucw_converter.convert_raw(L_a_property, signal_by_name, 'la_')
    L_g = ltl2ucw_converter.convert_raw(L_g_property, signal_by_name, 'lg_')

    assert_deterministic(L_a)
    assert_deterministic(L_g)

    # goal_converter = GoalConverter(config.GOAL)
    # automaton = goal_converter.convert_to_nondeterministic('!(%s)' % spec, signal_by_name, 'spec_')

    _log_automata1(safety_automaton)
    _log_automata1(L_a)
    _log_automata1(L_g)

    # TODO: check others satisfy the pre of the encoder

    encoder_class = {BFSJ:BFSJEncoder,
                     BFSJ_SYMBOLIC:BFSJSymbolicEncoder,
                     BFSJ_SYMBOLIC_FORALL:BFSJSymbolicForallEncoder} \
                    [encoding]

    encoder = encoder_class(logic,
                            safety_automaton,
                            L_a, L_g,
                            underlying_solver,
                            not is_moore,
                            input_signals,
                            output_signals,
                            0)

    model = search(bounds, encoder)

    is_realizable = model is not None

    logger.info(['unrealizable', 'realizable'][is_realizable])

    if is_realizable:
        logger.warn('implement outputting the result')

    return is_realizable


def main_original(spec_file_name:str,
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

    parser.add_argument('-e', '--encoding', choices=['original',
                                                     ALL,
                                                     ALL_SYMBOLIC,
                                                     ALL_SYMBOLIC_FORALL,
                                                     BFSJ,
                                                     BFSJ_SYMBOLIC,
                                                     BFSJ_SYMBOLIC_FORALL,
                                                     ],
                        default='original',
                        help='chose the encoding')

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

    main_func = {'original':main_original,
                 ALL:main_sa_sg_la_lg,
                 ALL_SYMBOLIC:main_sa_sg_la_lg,
                 ALL_SYMBOLIC_FORALL:main_sa_sg_la_lg,
                 BFSJ:main_bfsj,
                 BFSJ_SYMBOLIC:main_bfsj,
                 BFSJ_SYMBOLIC_FORALL:main_bfsj,
                 }[args.encoding]

    is_realizable = main_func(args.ltl,
                              args.moore, args.dot, bounds,
                              ltl2ucw_converter,
                              solver_factory.create(),
                              args.encoding)

    if not args.tmp:
        remove_files_prefixed(smt_files_prefix.split('/')[-1])

    exit(0 if is_realizable else 1)
