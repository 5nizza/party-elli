#!/usr/bin/env python3
import argparse
import importlib
from itertools import product
import os
import sys
import tempfile
from helpers import automata_helper
from helpers.console_helpers import print_green, print_red
from helpers.labels_map import LabelsMap

from helpers.main_helper import setup_logging, create_spec_converter_z3, remove_files_prefixed
from interfaces.automata import Automaton, all_stimuli_that_satisfy, LABEL_TRUE, get_next_states, Label, is_satisfied
from interfaces.lts import LTS
from interfaces.parser_expr import Signal
from module_generation.dot import lts_to_dot
from synthesis.assume_guarantee_encoder import assert_deterministic
from synthesis.assume_guarantee_model_searcher import search
from synthesis.funcs_args_types_names import smt_name_spec, TYPE_S_a_STATE, TYPE_S_g_STATE, TYPE_L_a_STATE, \
    TYPE_L_g_STATE, smt_name_m, smt_arg_name_signal, ARG_S_a_STATE, ARG_S_g_STATE, ARG_L_a_STATE, ARG_L_g_STATE, \
    ARG_MODEL_STATE
from synthesis.smt_logic import UFLIA
from automata_translations.ltl2automaton import LTL3BA


def _write_out(model, is_moore, file_type, file_name):
    with open(file_name + '.' + file_type, 'w') as out:
        out.write(model)

        logger.info('{model_type} model is written to {file}'.format(
            model_type=['Mealy', 'Moore'][is_moore],
            file=out.name))


def _parse_spec(spec_file_name:str):
    # TODO: do not allow upper letter in the spec
    code_dir = os.path.dirname(spec_file_name)
    code_file = os.path.basename(spec_file_name.strip('.py'))

    sys.path.append(code_dir)

    saved_path = sys.path  # to ensure we import the right file
                           # (imagine you want /tmp/spec.py but there is also ./spec.py,
                           # then python prioritizes to ./spec.py)
                           # To ensure the right version we change sys.path temporarily.
    sys.path = [code_dir]
    spec = importlib.import_module(code_file)
    sys.path = saved_path

    return [Signal(s) for s in spec.inputs], \
           [Signal(s) for s in spec.outputs], \
           spec.S_a_property, spec.S_g_property, \
           spec.L_a_property, spec.L_g_property


def _log_automata(S_a, S_g, L_a, L_g):
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
                assert_deterministic(s_a,s_g,l_a,l_g,word_lbl)

                s_a_n = set(map(lambda node_flag: node_flag[0], dst_set_list[0])).pop()
                s_g_n = get_next_states(s_g, word_lbl).pop()
                l_a_n = get_next_states(l_a, word_lbl).pop()
                l_g_n = get_next_states(l_g, word_lbl).pop()

                tau_trans_label = _get_tau_transition_label(s_a,s_g,l_a,l_g,m,i_lbl)
                m_next = lts.tau_model[tau_trans_label]

                next_state = (s_a_n, s_g_n, l_a_n, l_g_n, m_next)

                tau_new_table[tau_trans_label] = next_state

                if next_state not in processed_states:
                    new_states.add(next_state)

    return LTS(init_states, lts.model_by_name, LabelsMap(tau_new_table),
               None,    # TODO: remove all together?
               lts.input_signals, lts.output_signals)


def main(spec_file_name:str,
         is_moore,
         dot_file_name, nusmv_file_name,
         bounds,
         ltl2ucw_converter:LTL3BA,
         underlying_solver):
    """ :return: is realizable? """

    input_signals, \
    output_signals, \
    S_a_property, S_g_property, L_a_property, L_g_property \
        = _parse_spec(spec_file_name)

    assert input_signals or output_signals

    signal_by_name = dict((s.name,s) for s in input_signals + output_signals)

    S_a = ltl2ucw_converter.convert_raw(S_a_property, signal_by_name, 'sa_')
    S_g = ltl2ucw_converter.convert_raw('!(%s)' % S_g_property, signal_by_name, 'sg_')
    L_a = ltl2ucw_converter.convert_raw(L_a_property, signal_by_name, 'la_')
    L_g = ltl2ucw_converter.convert_raw(L_g_property, signal_by_name, 'lg_')

    _log_automata(S_a, S_g, L_a, L_g)

    model = search(S_a, S_g, L_a, L_g,
                   not is_moore,
                   input_signals, output_signals,
                   bounds,
                   underlying_solver, UFLIA(None))

    is_realizable = model is not None

    logger.info(['unrealizable', 'realizable'][is_realizable])

    if is_realizable:
        combined_model = combine_model(S_a, S_g, L_a, L_g, model, input_signals)

        dot_combined_model = lts_to_dot(combined_model, not is_moore)

        if not dot_file_name:
            logger.info(dot_combined_model)
        else:
            _write_out(dot_combined_model, is_moore, 'dot', dot_file_name)

        if nusmv_file_name:
            assert 0  # TODO: support in the release
            # nusmv_model = to_boolean_nusmv(model, spec_property)
            # _write_out(nusmv_model, is_moore, 'smv', nusmv_file_name, logger)

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
    parser.add_argument('--nusmv', metavar='nusmv', type=str, required=False,
                        help='writes the output and the specification into NuSMV file')

    group_bound = parser.add_mutually_exclusive_group()
    group_bound.add_argument('--bound', metavar='bound', type=int, default=128, required=False,
                             help='upper bound on the size of local process (default: %(default)i)')
    group_bound.add_argument('--size', metavar='size', type=int, default=0, required=False,
                             help='exact size of the process implementation(default: %(default)i)')

    parser.add_argument('--tmp', action='store_true', required=False, default=False,
                        help='keep temporary smt2 files')
    parser.add_argument('-v', '--verbose', action='count', default=0)

    args = parser.parse_args()

    logger = setup_logging(args.verbose)

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
                         args.moore, args.dot, args.nusmv, bounds,
                         ltl2ucw_converter,
                         solver_factory.create())

    if not args.tmp:
        remove_files_prefixed(smt_files_prefix.split('/')[-1])

    exit(0 if is_realizable else 1)
