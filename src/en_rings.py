import argparse
import logging
import sys
from helpers.main_helper import setup_logging, create_spec_converter_z3
from interfaces.spec import Spec
from module_generation.dot import to_dot
from parsing.en_rings_parser import is_parametrized, get_cutoff_size, get_fair_scheduler_property, SCHED_ID_PREFIX, concretize_property, SENDS_NAME, get_tok_ring_par_io, get_tok_ring_concr_properties, ACTIVE_NAME_PREFIX
from parsing.parser import parse_ltl
from synthesis.par_model_searcher import search


def update_spec_w_en_rings(raw_ltl_spec):
    nof_processes = get_cutoff_size(raw_ltl_spec.property)

    fair_sched_prop = get_fair_scheduler_property(nof_processes, SCHED_ID_PREFIX, SENDS_NAME)

    print()
    print(fair_sched_prop)
    print()

    concr_safety_tok_ring_prop, concrt_liveness_tok_ring_prop = get_tok_ring_concr_properties(nof_processes)
    print()
    print(concr_safety_tok_ring_prop)
    print(concrt_liveness_tok_ring_prop)
    print()

    concr_original_prop = concretize_property(raw_ltl_spec.property, nof_processes)
    full_concr_prop = '{ring} && (({sched}) -> (({original}) && ({live_tok_ring})))'.format_map(
            {'ring': concr_safety_tok_ring_prop,
             'sched': fair_sched_prop,
             'original': concr_original_prop,
             'live_tok_ring': concrt_liveness_tok_ring_prop})

    print()
    print('modified original', full_concr_prop)
    print()
    par_tok_ring_inputs, par_tok_ring_outputs = get_tok_ring_par_io()

    par_inputs = raw_ltl_spec.inputs + par_tok_ring_inputs
    par_outputs = raw_ltl_spec.outputs + par_tok_ring_outputs

    return par_inputs, par_outputs, full_concr_prop, nof_processes


def main(ltl_file, dot_file, bounds, automaton_converter, solver, logger):
    raw_ltl_spec = parse_ltl(ltl_file.read())

    assert is_parametrized(raw_ltl_spec)

    par_inputs, par_outputs, full_concr_prop, nof_processes = update_spec_w_en_rings(raw_ltl_spec)

    automaton = automaton_converter.convert(Spec(par_inputs, par_outputs, full_concr_prop))

    model = search(automaton, par_inputs, par_outputs,
        nof_processes,
        bounds,
        solver, SCHED_ID_PREFIX, ACTIVE_NAME_PREFIX, SENDS_NAME)


    if dot_file is not None and model is not None:
        dot = to_dot(model)
        dot_file.write(dot)


#    is_par_spec = is_parametrized(raw_ltl_spec.property)
#
#    automaton = ltl2ucw.convert(ltl_spec)
#    inputs = raw_ltl_spec.inputs
#    outputs = raw_ltl_spec.outputs
#
#    logger.info('spec automaton has {0} states'.format(len(automaton.nodes)))
#
#    model = search_parametrized(architecture,
#        automaton,
#        inputs, outputs, nof_processes,
#        bounds,
#        z3solver, logic)
#
#    if model is None:
#        logger.info('The specification is unrealizable with input conditions.')
#    return
#
#    output = str(model)
#    if verilog_file is not None:
#        verilog_module = to_verilog(model)
#        output = _verilog_to_str(verilog_module)
#        verilog_file.write(output)
#

#
#    logger.info('-'*80)
#    logger.info(output)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Parametrized SynthesIs Tool')
    parser.add_argument('ltl', metavar='ltl', type=argparse.FileType(),
        help='loads the LTL formula from the given input file')
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

    main(args.ltl, args.dot, bounds, ltl2ucw_converter, z3solver, logging.getLogger(__name__))

    args.ltl.close()

    if args.dot:
        args.dot.close()
