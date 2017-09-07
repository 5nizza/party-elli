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
resettability = AG(EFG(~reduce(lambda x,y: x|y, g_array)))

#
formula = A(mut_excl & req_is_granted) & resettability
inputs = rs_array
outputs = gs_array
spec = Spec(inputs, outputs, formula)
