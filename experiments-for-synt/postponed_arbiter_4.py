from functools import reduce

from helpers.spec_helper import *
from interfaces.expr import Bool
from interfaces.spec import Spec


n = 4

#
rs_array, r_array = [], []
gs_array, g_array = [], []

for i in range(n):
    rs, r = sig_prop('r_'+str(i))
    gs, g = sig_prop('g_'+str(i))
    rs_array.append(rs)
    r_array.append(r)
    gs_array.append(gs)
    g_array.append(g)

#
mut_excl = Bool(True)
for i in range(n):
    mut_excl &= G(g_array[i] >>
                  ~(reduce(lambda x,y: x|y, g_array[:i], Bool(False)) |
                    reduce(lambda x,y: x|y, g_array[i+1:], Bool(False))))

#
req_is_granted = reduce(lambda x,y: x&y,
                        [G(r_array[i] >> F(g_array[i])) for i in range(n)])

#
no_init_grants = reduce(lambda x,y: x&y, [~g for g in g_array])

#
postponing = AG(reduce(lambda x,y: x&y,
                       [EF(~g_array[i] & r_array[i] & X(r_array[i] & ~g_array[i] & X(~g_array[i])))
                        for i in range(n)]))

#
formula = A(mut_excl & req_is_granted) & no_init_grants & postponing
inputs = rs_array
outputs = gs_array
spec = Spec(inputs, outputs, formula)
