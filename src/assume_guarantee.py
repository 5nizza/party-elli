import argparse
import tempfile
import sys
from helpers.main_helper import setup_logging, create_spec_converter_z3
from module_generation.dot import to_dot
from parsing import anzu_parser
from parsing.anzu_parser_desc import ANZU_ENV_TRANSITIONS, ANZU_ENV_INITIAL, ANZU_SYS_INITIAL, ANZU_SYS_TRANSITIONS, ANZU_INPUT_VARIABLES, ANZU_OUTPUT_VARIABLES, ANZU_ENV_FAIRNESS, ANZU_SYS_FAIRNESS
from parsing.helpers import convert_ast_to_ltl3ba_format
from synthesis.assume_guarantee import assume_guarantee_searcher
from synthesis.smt_logic import UFLIA


def _get_liveness_property_automaton(data_from_section_name, automaton_converter):
    env_fairness_asts = data_from_section_name['ENV_FAIRNESS']
    sys_fairness_asts = data_from_section_name['SYS_FAIRNESS']

    env_fairness_ltl2ba_property = ' && '.join(['({0})'.format(convert_ast_to_ltl3ba_format(a))
                                                for a in env_fairness_asts])
    sys_fairness_ltl2ba_property = ' && '.join(['({0})'.format(convert_ast_to_ltl3ba_format(a))
                                                for a in sys_fairness_asts])

    liveness_property_ltl3ba_format = '({env}) -> ({sys})'.format(env = env_fairness_ltl2ba_property,
        sys = sys_fairness_ltl2ba_property)

    liveness_property_automaton = automaton_converter.convert(liveness_property_ltl3ba_format)

    return liveness_property_automaton

def _convert_asts_to_automaton(asts, automaton_converter):
    property = _convert_asts_to_ltl3ba_format(asts)
    automaton = automaton_converter.convert(property)
    return automaton


def assume_guarantee_case(anzu_ltl_spec, smt_files_prefix, dot_file, bounds, automaton_converter, z3solver, logger):
    data_from_section_name = anzu_parser.parse_ltl(anzu_ltl_spec)

    #ltl3ba treats upper letters wrongly
    inputs = [n.name.lower() for n in data_from_section_name[ANZU_INPUT_VARIABLES]]
    outputs = [n.name.lower() for n in data_from_section_name[ANZU_OUTPUT_VARIABLES]]

    env_initials_asts = data_from_section_name[ANZU_ENV_INITIAL]
    env_transitions_asts = data_from_section_name[ANZU_ENV_TRANSITIONS]
    env_fairness_asts = data_from_section_name[ANZU_ENV_FAIRNESS]

    sys_initials_asts = data_from_section_name[ANZU_SYS_INITIAL]
    sys_transitions_asts = data_from_section_name[ANZU_SYS_TRANSITIONS]
    sys_fairness_asts = data_from_section_name[ANZU_SYS_FAIRNESS]

    #temporarily: remove me!
    vars = {'Ie':_convert_asts_to_ltl3ba_format(env_initials_asts),
            'Is':_convert_asts_to_ltl3ba_format(sys_initials_asts),
            'Se':_convert_asts_to_ltl3ba_format(env_transitions_asts, True),
            'Ss':_convert_asts_to_ltl3ba_format(sys_transitions_asts, True),
            'Le':_convert_asts_to_ltl3ba_format(env_fairness_asts),
            'Ls':_convert_asts_to_ltl3ba_format(sys_fairness_asts)}

    logger.info('compositional approach to automata construction')
    guarantees = list(map(convert_ast_to_ltl3ba_format, sys_initials_asts + sys_transitions_asts + sys_fairness_asts))

    ass = '(({Ie}) && (G({Se})) && ({Le}))'.format_map(vars)

    for i, gua in enumerate(guarantees):
        print('{0}/{1}: {2}'.format(str(i), str(len(guarantees)), gua))
        property = '({0}) -> ({1})'.format(ass, gua)
        automaton = automaton_converter.convert(property)
        logger.info('#original_automaton = %i', len(automaton.nodes))

    assert 0

    original_gr1_property = '(({Ie}) && (G({Se})) && ({Le})) -> (({Is}) && (G({Ss})) && ({Ls}))'.format_map(vars)
    corrected_gr1_property = '(({Ie}) -> ({Is})) && (({Ie}) -> (!F(({Se}) U !({Ss})))) && ((({Ie}) && G({Se})) -> (({Le}) -> ({Ls})))'.format_map(vars)

    original_automaton = automaton_converter.convert(original_gr1_property)
    logger.info('#original_automaton = %i', len(original_automaton.nodes))

    corrected_automaton = automaton_converter.convert(corrected_gr1_property)
    logger.info('#corrected_automaton = %i', len(corrected_automaton.nodes))

    assert 0

    # Se and Le -> Ss and Ls
    # Se -> (Le -> (Ss and Ls))
    ass_safety_property = _convert_asts_to_ltl3ba_format(env_initials_asts + env_transitions_asts)
#    shifted_ass_safety_property = _shift_sys(ass_safety_property, outputs)
    ass_automaton = automaton_converter.convert(ass_safety_property)

    env_fairness_property = _convert_asts_to_ltl3ba_format(env_fairness_asts)

    sys_fairness_property = _convert_asts_to_ltl3ba_format(sys_fairness_asts)
    sys_safety_property = _convert_asts_to_ltl3ba_format(sys_transitions_asts + sys_initials_asts)
    #with strengthening
    gua_property = '({Ss}) && (({Le}) -> ({Ls}))'.format(
        Le = env_fairness_property,
        Ss = sys_safety_property,
        Ls = sys_fairness_property)

    gua_automaton = automaton_converter.convert(gua_property)

    print(ass_safety_property)
#    print()
#    print(gua_property)
#    print()
#    print(automata_helper.to_dot(ass_automaton))
#    print()
#    print(automata_helper.to_dot(gua_automaton))

#    print(to_dot(ass_automaton))
#    print()
#    print(to_dot(gua_automaton))

    logger.info('#ass_automaton = %i', len(ass_automaton.nodes))
    logger.info('#gua_automaton = %i', len(gua_automaton.nodes))

    models = assume_guarantee_searcher.search(ass_automaton, gua_automaton,
        inputs, outputs,
        bounds,
        z3solver,
        UFLIA(None),
        smt_files_prefix)

    if models:
        logger.info('model is found!')
        if dot_file is not None:
            for lts in models:
                dot = to_dot(lts)
                dot_file.write(dot)
    else:
        logger.info('unrealizable')


def main_anzu_case():
    parser = argparse.ArgumentParser(description='Parametrized Synthesis Tool for token rings architecture')

    parser.add_argument('ltl', metavar='ltl', type=str,
        help='type of LTL formula: acceptable are: pnueli, full, simple')
    parser.add_argument('--dot', metavar='dot', type=argparse.FileType('w'), required=False,
        help='writes the output into a dot graph file')
    parser.add_argument('--bound', metavar='bound', type=int, default=2, required=False,
        help='upper bound on the size of local process (default: %(default)i)')
    parser.add_argument('--size', metavar='size', type=int, default=None, required=False,
        help='exact size of the process implementation(default: %(default)i)')
    #    parser.add_argument('--cutoff', metavar='cutoff', type=int, default=None, required=True,
    #        help='force specified cutoff size')
    parser.add_argument('-v', '--verbose', action='count', default=0)

    #    parser.add_argument('--opt', choices=tuple(_OPT_TO_MAIN.keys()), required=True)

    args = parser.parse_args(sys.argv[1:])

    logger = setup_logging(args.verbose)
    logger.debug(args)

    with open(args.ltl) as input:
        anzu_ltl_spec = input.read()

    with tempfile.NamedTemporaryFile(delete=False, dir='./') as smt_file:
        smt_file_name = smt_file.name

    bounds = list(range(2, args.bound + 1) if args.size is None else range(args.size, args.size + 1))

    ltl2ucw_converter, z3solver = create_spec_converter_z3(False)

    assume_guarantee_case(anzu_ltl_spec, smt_file_name, args.dot, bounds, ltl2ucw_converter, z3solver, logger)


if __name__ == '__main__':
    main_anzu_case()