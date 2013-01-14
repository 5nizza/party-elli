import argparse
import logging
import sys
import tempfile

from helpers.main_helper import setup_logging, create_spec_converter_z3
from interfaces.parser_expr import and_expressions, QuantifiedSignal
from interfaces.spec import SpecProperty, to_expr, and_properties
from module_generation.dot import to_dot, moore_to_dot
from parsing import acacia_parser
from parsing.anzu_parser_desc import ANZU_INPUT_VARIABLES, ANZU_ENV_FAIRNESS, ANZU_ENV_INITIAL,ANZU_ENV_TRANSITIONS, ANZU_OUTPUT_VARIABLES, ANZU_SYS_TRANSITIONS, ANZU_SYS_FAIRNESS, ANZU_SYS_INITIAL
from synthesis.solitary_model_searcher import search
from synthesis.smt_logic import UFLIA


#def _get_spec(spec_text:str, logger:logging.Logger) -> (list, list, SpecProperty):
#    #TODO: add strengthening option?
#    #TODO: use real semantics of GR1(with past operators), it may be more efficient
#    data_by_section = anzu_parser.parse_ltl(spec_text, logger)
#    if data_by_section is None:
#        return None, None, None
#
#    init_assumptions, s_assumptions, l_assumptions = data_by_section[ANZU_ENV_INITIAL], \
#                                                     data_by_section[ANZU_ENV_TRANSITIONS], \
#                                                     data_by_section[ANZU_ENV_FAIRNESS]
#    init_guarantees, s_guarantees, l_guarantees = data_by_section[ANZU_SYS_INITIAL], \
#                                                  data_by_section[ANZU_SYS_TRANSITIONS], \
#                                                  data_by_section[ANZU_SYS_FAIRNESS]
#
#    ass = and_expressions([and_expressions(init_assumptions),
#                           and_expressions(s_assumptions),
#                           and_expressions(l_assumptions)])
#
#    gua = and_expressions([and_expressions(init_guarantees),
#                           and_expressions(s_guarantees),
#                           and_expressions(l_guarantees)])
#
#    spec_property = SpecProperty([ass], [gua])
#
#    input_signals = [QuantifiedSignal(s.name, 0) for s in data_by_section[ANZU_INPUT_VARIABLES]]
#    output_signals = [QuantifiedSignal(s.name, 0) for s in data_by_section[ANZU_OUTPUT_VARIABLES]]
#
#    return input_signals, output_signals, spec_property


def _get_acacia_spec(ltl_text:str, part_text:str, logger:logging.Logger) -> (list, list, SpecProperty):
    input_signals, output_signals, data_by_name = acacia_parser.parse(ltl_text, part_text, logger)

    if data_by_name is None:
        return None, None, None

    spec_properties = []
    for (unit_name, unit_data) in data_by_name.items():
        assumptions = unit_data[0]
        guarantees = unit_data[1]
        spec_properties.append(SpecProperty(assumptions, guarantees))

    spec_property = and_properties(spec_properties)

    return input_signals, output_signals, spec_property


def main(ltl_text:str, part_text:str, is_moore, dot_file, bounds, ltl2ucw_converter, z3solver, logger):
    input_signals, output_signals, spec_property = _get_acacia_spec(ltl_text, part_text, logger)
    if not input_signals or not output_signals or not spec_property:
        return None

    automaton = ltl2ucw_converter.convert(to_expr(spec_property))
    logger.info('spec automaton has {0} states'.format(len(automaton.nodes)))

    with tempfile.NamedTemporaryFile(delete=False, dir='./') as smt_file:
        smt_file_prefix = smt_file.name

    models = search(automaton, not is_moore, input_signals, output_signals, bounds, z3solver, UFLIA(None), smt_file_prefix)
    assert models is None or len(models) == 1
    model = models[0] if models else None

    logger.info('model %s found', ['', 'not'][models is None])

    if dot_file is not None and model is not None:
        if is_moore:
            dot = moore_to_dot(model)
        else:
            dot = to_dot(model)

        dot_file.write(dot)
        logger.info('{type} model is written to {file}'.format(type=['Mealy','Moore'][is_moore], file=dot_file.name))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='BOunded SYnthesis Tool')
    parser.add_argument('ltl', metavar='ltl', type=argparse.FileType(),
        help='loads the LTL formula from the given input file, also assumes existence of file with .part extension')
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

    ltl2ucw_converter, z3solver = create_spec_converter_z3()

    bounds = list(range(1, args.bound + 1) if args.size is None else range(args.size, args.size + 1))

    ltl_text = args.ltl.read()

    part_file_name = '.'.join(args.ltl.name.split('.')[:-1]) + '.part'
    with open(part_file_name) as part_file:
        part_text = part_file.read()

    main(ltl_text, part_text, args.moore, args.dot, bounds, ltl2ucw_converter, z3solver, logging.getLogger(__name__))

    args.ltl.close()

    if args.dot:
        args.dot.close()
