from helpers.console_helpers import print_green, print_red
from helpers.python_ext import add_dicts, lmap
from interfaces.parser_expr import QuantifiedSignal
from interfaces.solver_interface import SolverInterface
from synthesis.func_description import FuncDescription


def _next(sig):
    return QuantifiedSignal(sig.name + 'Next', *sig.binding_indices)


def _build_args_for_gua(s, input_signals, output_descs, tau_desc, solver):
    """ crt_names,next_names -> crt and next values
        no state name
        to build next values for outputs we need to call output functions with current inputs
    """
    args_for_crt_outputs = dict()
    crt_input_args = dict((sig, '?{0}'.format(str(sig))) for sig in input_signals)
    args_for_crt_outputs.update(crt_input_args)
    args_for_crt_outputs['state'] = s

    crt_out_to_value = dict()
    for sig,desc in output_descs.items():
        out_value = solver.call_func(desc, args_for_crt_outputs)
        crt_out_to_value[sig] = out_value

    # done with crt inputs, outputs
    # now build dict nxt_names -> next values
    nxt_input_args = dict()
    for sig in input_signals:
        nxt_sig = _next(sig)
        nxt_value = '?{0}'.format(str(nxt_sig))
        nxt_input_args[nxt_sig] = nxt_value

    nxt_output_args = dict()  # nxt_name -> nxt_value
    args_for_nxt_output = dict()  # nxt_out(s,i), s' = tau(s,i)
    args_for_nxt_output['state'] = solver.call_func(tau_desc, add_dicts(crt_input_args, {'state':s}))
    for sig,desc in output_descs.items():
        nxt_output_args[_next(sig)] = solver.call_func(desc, args_for_nxt_output)

    return add_dicts(crt_out_to_value, crt_input_args, nxt_input_args, nxt_output_args)


def encode_gr1_transitions(env_ass_func:FuncDescription, sys_gua_func:FuncDescription,
                           tau_func_desc:FuncDescription,
                           outvar_desc_by_process,
                           states,
                           solver:SolverInterface):
    """
    for each state:
      for all inputs i,i':
        ass(i) & ass(i') -> gua(i, o(s), i', o(tau(s,i)))
    """
    input_signals = [sig_typ[0] for sig_typ in tau_func_desc.inputs if isinstance(sig_typ[0], QuantifiedSignal)]

    forall_vars = ['?{0}'.format(str(s)) for s in (input_signals + lmap(_next, input_signals))]

    expressions = []
    for s in states:
        args_for_ass = dict((sig, '?{0}'.format(str(sig))) for sig in input_signals)
        args_for_ass_next = dict((sig, '?{0}'.format(str(_next(sig))))
                                 for sig in input_signals)
        args_for_gua = _build_args_for_gua(s, input_signals, outvar_desc_by_process[0], tau_func_desc, solver)

        ass_expr = solver.op_and([solver.call_func(env_ass_func, args_for_ass),
                                  solver.call_func(env_ass_func, args_for_ass_next)])
        gua_expr = solver.call_func(sys_gua_func, args_for_gua)
        quantified_expr = solver.op_implies(ass_expr, gua_expr)
        expr = solver.forall_bool(forall_vars, quantified_expr)
        expressions.append(expr)

    for e in expressions:
        solver.assert_(e)

