import argparse
import logging
import sys
import tempfile

from helpers.main_helper import setup_logging, create_spec_converter_z3
from interfaces.parser_expr import and_expressions, QuantifiedSignal
from interfaces.spec import SpecProperty, to_expr
from module_generation.dot import to_dot, moore_to_dot
import parsing.anzu_parser as anzu_parser
from parsing.anzu_parser_desc import ANZU_INPUT_VARIABLES, ANZU_ENV_FAIRNESS, ANZU_ENV_INITIAL,ANZU_ENV_TRANSITIONS, ANZU_OUTPUT_VARIABLES, ANZU_SYS_TRANSITIONS, ANZU_SYS_FAIRNESS, ANZU_SYS_INITIAL
from synthesis.solitary_model_searcher import search
from synthesis.smt_logic import UFLIA


def _get_spec(spec_text:str, logger:logging.Logger) -> (list, list, SpecProperty):
    #TODO: add strengthening option?
    #TODO: use real semantics of GR1(with past operators), it may be more efficient
    data_by_section = anzu_parser.parse_ltl(spec_text, logger)
    if data_by_section is None:
        return None, None, None

    init_assumptions, s_assumptions, l_assumptions = data_by_section[ANZU_ENV_INITIAL], \
                                                     data_by_section[ANZU_ENV_TRANSITIONS], \
                                                     data_by_section[ANZU_ENV_FAIRNESS]
    init_guarantees, s_guarantees, l_guarantees = data_by_section[ANZU_SYS_INITIAL], \
                                                  data_by_section[ANZU_SYS_TRANSITIONS], \
                                                  data_by_section[ANZU_SYS_FAIRNESS]

    ass = and_expressions([and_expressions(init_assumptions),
                           and_expressions(s_assumptions),
                           and_expressions(l_assumptions)])

    gua = and_expressions([and_expressions(init_guarantees),
                           and_expressions(s_guarantees),
                           and_expressions(l_guarantees)])

    spec_property = SpecProperty([ass], [gua])

    input_signals = [QuantifiedSignal(s.name, 0) for s in data_by_section[ANZU_INPUT_VARIABLES]]
    output_signals = [QuantifiedSignal(s.name, 0) for s in data_by_section[ANZU_OUTPUT_VARIABLES]]

    return input_signals, output_signals, spec_property


def main(ltl_text, is_moore, dot_file, bounds, ltl2ucw_converter, z3solver, logger):
    input_signals, output_signals, spec_property = _get_spec(ltl_text, logger)
    if not input_signals:
        return None


    automaton = ltl2ucw_converter.convert(to_expr(spec_property))
    logger.info('spec automaton has {0} states'.format(len(automaton.nodes)))

    with tempfile.NamedTemporaryFile(delete=False, dir='./') as smt_file:
        smt_file_prefix = smt_file.name

    models = search(automaton, not is_moore, input_signals, output_signals, bounds, z3solver, UFLIA(None), smt_file_prefix)
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

    ltl2ucw_converter, z3solver = create_spec_converter_z3()

    bounds = list(range(1, args.bound + 1) if args.size is None else range(args.size, args.size + 1))

    main(args.ltl.read(), args.moore, args.dot, bounds, ltl2ucw_converter, z3solver, logging.getLogger(__name__))

    args.ltl.close()

    if args.dot:
        args.dot.close()
