from collections import Iterable
from helpers.python_ext import add_dicts

from interfaces.solver_interface import SolverInterface
from synthesis.func_description import FuncDescription
from synthesis.smt_helper import forall_bool


## FOR ZERO PROCESS
ZERO_LOCKED_BURSTS_BUSREQ_READY = FuncDescription('prev0',
                                                  dict((s, 'Bool')
                                                       for s in ['_hready', '_hlock', '_hburst0', '_hburst1',
                                                                 '_hbusreq', '_noreq']),
                                                  'Bool',
                                                  "(and _hburst0 _hburst1 _hbusreq (=> _hbusreq _hlock) _hready)")

ZERO_LOCKED_BURSTS_READY = FuncDescription('prev0',
                                           dict((s, 'Bool')
                                                for s in ['_hready', '_hlock', '_hburst0', '_hburst1',
                                                          '_hbusreq', '_noreq']),
                                           'Bool',
                                           "(and _hburst0 _hburst1 _hready (=> _hbusreq _hlock))")

ZERO_ANY_BURSTS = FuncDescription('prev0',
                                  dict((s, 'Bool')
                                       for s in ['_hready', '_hlock', '_hburst0', '_hburst1',
                                                 '_hbusreq', '_noreq']),
                                  'Bool',
                                  "(and _hburst0 _hburst1)")

ZERO_LOCKED_BURSTS = FuncDescription('prev0',
                                     dict((s, 'Bool')
                                          for s in ['_hready', '_hlock', '_hburst0', '_hburst1',
                                                    '_hbusreq', '_noreq']),
                                     'Bool',
                                     "(and _hburst0 _hburst1 (=> _hbusreq _hlock))")

ZERO_LOCKED_BURSTS_NOSILENCE = FuncDescription('prev0',
                                               dict((s, 'Bool')
                                                    for s in ['_hready', '_hlock', '_hburst0', '_hburst1',
                                                              '_hbusreq', '_noreq']),
                                               'Bool',
                                               "(and _hburst0 _hburst1 (=> _hbusreq _hlock) (not _noreq))")

ZERO_ANY_BURSTS_NOSILENCE = FuncDescription('prev0',
                                            dict((s, 'Bool')
                                                 for s in ['_hready', '_hlock', '_hburst0', '_hburst1',
                                                           '_hbusreq', '_noreq']),
                                            'Bool',
                                            "(and _hburst0 _hburst1 (not _noreq))")

ZERO_ANY_BURSTS_ANY_INCR_NOSILENCE = FuncDescription('prev0',
                                                     dict((s, 'Bool')
                                                          for s in ['_hready', '_hlock', '_hburst0', '_hburst1',
                                                                    '_hbusreq', '_noreq']),
                                                     'Bool',
                                                     "(and ( or  (and _hburst0 _hburst1) (and (not _hburst0) _hburst1) ) (not _noreq))")

## FOR Ith PROCESS
# assumptions for the case of locked bursts
ASS_LOCKED_BURSTS = FuncDescription('prev0',
                                    dict((s, 'Bool')
                                         for s in ['_hready', '_hlock', '_hburst0', '_hburst1', '_hbusreq']),
                                    'Bool',
                                    "(and _hburst0 _hburst1 (=> _hbusreq _hlock))")

ASS_ANY_BURSTS = FuncDescription('prev0',
                                 dict((s, 'Bool')
                                      for s in ['_hready', '_hlock', '_hburst0', '_hburst1', '_hbusreq']),
                                 'Bool',
                                 "(and _hburst0 _hburst1)")

ASS_ANY_BURSTS_OR_LOCKED_INCR = FuncDescription('prev0',
                                                dict((s, 'Bool')
                                                     for s in
                                                     ['_hready', '_hlock', '_hburst0', '_hburst1', '_hbusreq']),
                                                'Bool',
                                                "(or (and _hburst0 _hburst1)"
                                                "    (and (not _hburst0) _hburst1 (=> _hbusreq _hlock)))")

ASS_TRUE = FuncDescription('prev0',
                           dict((s, 'Bool')
                                for s in ['_hready', '_hlock', '_hburst0', '_hburst1', '_hbusreq']),
                           'Bool',
                           "true")

ASS_BURST_OR_INCR = FuncDescription('prev0',
                                    dict((s, 'Bool')
                                         for s in ['_hready', '_hlock', '_hburst0', '_hburst1', '_hbusreq']),
                                    'Bool',
                                    "_hburst1")


def encode_equality_for_output(prev_out:FuncDescription, out:FuncDescription,
                               prev_states:Iterable,
                               solver:SolverInterface):
    conjuncts = []
    for ps in prev_states:
        args = {'state': ps}
        conjuncts.append(solver.op_eq(solver.call_func(prev_out, args),
                                      solver.call_func(out, args)))
    res = solver.op_and(conjuncts)
    solver.assert_(res)


def encode_equality_for_tau(prev_func:FuncDescription, func:FuncDescription,
                            prev_ass:FuncDescription,
                            prev_states:Iterable,
                            solver:SolverInterface):
    for ps in prev_states:
        all_inputs = set(sig_typ[0] for sig_typ in func.inputs)
        all_inputs.remove('state')

        args = add_dicts(dict((s, '?{0}'.format(s)) for s in all_inputs),  # dirty HACK (with names)
                         dict((s.name, '?{0}'.format(s)) for s in all_inputs),
                         dict(('_' + s.name, '?{0}'.format(s)) for s in all_inputs))  # weird names for prev0 function
        args['state'] = ps

        res = forall_bool(['?' + str(i) for i in all_inputs],
                          solver.op_implies(solver.call_func(prev_ass, args),
                                            solver.op_eq(solver.call_func(func, args),
                                                         solver.call_func(prev_func, args))))
        solver.assert_(res)
