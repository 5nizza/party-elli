from functools import reduce

from helpers.spec_helper import *
from interfaces.expr import Bool
from interfaces.spec import Spec


n = 3

rs_array, r_array = [], []
gs_array, g_array = [], []
rm_s, rm = sig_prop('rm')
gm_s, gm = sig_prop('gm')

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
                   reduce(lambda x,y: x|y, g_array[i+1:], Bool(False)) |
                   gm))
mut_excl &= G(gm >> ~reduce(lambda x,y: x|y, g_array))

#
req_is_granted = reduce(lambda x,y: x&y,
                        [G(r_array[i] >> F(g_array[i])) for i in range(n)],
                        Bool(True))
req_is_granted &= G(rm >> F(gm))

#
master_priority = G(rm >> X(U(reduce(lambda x,y: x&y, [~g for g in g_array]), gm)))

#
resettability = AG(EFG(~reduce(lambda x,y: x|y, g_array + [gm])))

formula = A(GF(~rm) >> (mut_excl & req_is_granted & master_priority)) & resettability

inputs = rs_array + [rm_s]
outputs = gs_array + [gm_s]

spec = Spec(inputs, outputs, formula)
























