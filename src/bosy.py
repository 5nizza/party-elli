import argparse
import logging
import sys
import tempfile

from helpers.main_helper import setup_logging, create_spec_converter_z3
from module_generation.dot import to_dot, moore_to_dot
import parsing.anzu_parser as anzu_parser
from parsing.anzu_parser_desc import ANZU_INPUT_VARIABLES, ANZU_ENV_FAIRNESS, ANZU_ENV_INITIAL,ANZU_ENV_TRANSITIONS, ANZU_OUTPUT_VARIABLES, ANZU_SYS_TRANSITIONS, ANZU_SYS_FAIRNESS, ANZU_SYS_INITIAL
from parsing.helpers import convert_asts_to_ltl3ba_format
from synthesis.solitary_model_searcher import search
from synthesis.smt_logic import UFLIA


def get_asts(data_from_section_name):
    inputs = data_from_section_name[ANZU_INPUT_VARIABLES]
    outputs = data_from_section_name[ANZU_OUTPUT_VARIABLES]

    env_initials_asts = data_from_section_name[ANZU_ENV_INITIAL]
    sys_initials_asts = data_from_section_name[ANZU_SYS_INITIAL]

    env_transitions_asts = data_from_section_name[ANZU_ENV_TRANSITIONS]
    sys_transitions_asts = data_from_section_name[ANZU_SYS_TRANSITIONS]

    env_fairness_asts = data_from_section_name[ANZU_ENV_FAIRNESS]
    sys_fairness_asts = data_from_section_name[ANZU_SYS_FAIRNESS]

    return inputs, outputs, env_initials_asts, sys_initials_asts, env_transitions_asts, sys_transitions_asts, env_fairness_asts, sys_fairness_asts


def main(ltl_text, is_moore, dot_file, bounds, ltl2ucw_converter, z3solver, logger):
    data_by_section = anzu_parser.parse_ltl(ltl_text, logger)
    if data_by_section is None:
        return

    input_signals, output_signals, \
    env_initials_asts, sys_initials_asts, \
    env_transitions_asts, sys_transitions_asts, \
    env_fairness_asts, sys_fairness_asts = get_asts(data_by_section)

    #TODO: hidden dependence: ltl3ba treats upper letters wrongly
    inputs = [i.name.lower() for i in input_signals]
    outputs = [o.name.lower() for o in output_signals]

    vars = {'Ie':convert_asts_to_ltl3ba_format(env_initials_asts),
            'Is':convert_asts_to_ltl3ba_format(sys_initials_asts),
            'Se':convert_asts_to_ltl3ba_format(env_transitions_asts),
            'Ss':convert_asts_to_ltl3ba_format(sys_transitions_asts),
            'Le':convert_asts_to_ltl3ba_format(env_fairness_asts),
            'Ls':convert_asts_to_ltl3ba_format(sys_fairness_asts)}

    ass = '(({Ie}) && ({Se}) && ({Le}))'.format_map(vars)
    gua = '(({Is}) && ({Ss}) && ({Ls}))'.format_map(vars)

    spec_property = '({ass}) -> ({gua})'.format(ass = ass, gua = gua)
    logger.info('the specification property (in ltl3ba format) is: ' + spec_property)

    automaton = ltl2ucw_converter.convert(spec_property)
    logger.info('spec automaton has {0} states'.format(len(automaton.nodes)))

    with tempfile.NamedTemporaryFile(delete=False, dir='./') as smt_file:
        smt_file_prefix = smt_file.name

    models = search(automaton, not is_moore, inputs, outputs, bounds, z3solver, UFLIA(None), smt_file_prefix)
    assert models is None or len(models) == 1

    logger.info('model %s found', ['', 'not'][models is None])

    if dot_file is not None and models is not None:
        for lts in models:
            if is_moore:
                dot = moore_to_dot(lts)
            else:
                dot = to_dot(lts)
            dot_file.write(dot)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='BOunded SYnthesis Tool')
    parser.add_argument('ltl', metavar='ltl', type=argparse.FileType(),
        help='loads the LTL formula from the given input file')
    parser.add_argument('--moore', action='store_true', required=False, default=False,
        help='treat the spec as Moore and produce Moore machine')
    parser.add_argument('--dot', metavar='dot', type=argparse.FileType('w'), required=False,
        help='writes the output into a dot graph file')
    parser.add_argument('--bound', metavar='bound', type=int, default=2, required=False,
        help='upper bound on the size of local process (default: %(default)i)')
    parser.add_argument('--size', metavar='size', type=int, default=None, required=False,
        help='exact size of the process implementation(default: %(default)i)')
    parser.add_argument('-v', '--verbose', action='count', default=0)


    args = parser.parse_args(sys.argv[1:])

    setup_logging(args.verbose)

    ltl2ucw_converter, z3solver = create_spec_converter_z3(False)

    bounds = list(range(1, args.bound + 1) if args.size is None else range(args.size, args.size + 1))

    main(args.ltl.read(), args.moore, args.dot, bounds, ltl2ucw_converter, z3solver, logging.getLogger(__name__))

    args.ltl.close()

    if args.dot:
        args.dot.close()
