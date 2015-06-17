from itertools import chain
from benchmarks.spec_helper import and_, inst_i, inst_i_j

NOF_CLIENTS = 2  # change at your will

##################################################
# parameterized

inputs_i = ['r{i}']
outputs_i = ['g{i}']

# assumptions
S_a_init_i = '!r{i}'
S_a_trans_i = and_('r{i} && !g{i} -> X r{i}',
                   '!r{i} && g{i} -> X !r{i}')

L_a_i = 'G F (!r{i} || !g{i})'  # hm, strange: should it be 'G F !r{i}'?

# guarantees
S_g_init_i = '!g{i}'
S_g_trans_i = and_('!r{i} && !g{i} -> X !g{i}',
                   ' r{i} && g{i}  -> X g{i} ')

S_g_trans_i_j = '!(g{i} && g{j})'

L_g_i = 'G F (r{i} && g{i}  ||  !r{i} && !g{i})'

##################################################
# now the spec instantiated

inputs = list(chain(*[[sig.format(i=n) for n in range(NOF_CLIENTS)]
                      for sig in inputs_i]))
outputs = list(chain(*[[sig.format(i=n) for n in range(NOF_CLIENTS)]
                       for sig in outputs_i]))

S_a_init = inst_i(S_a_init_i, NOF_CLIENTS)
S_g_init = inst_i(S_g_init_i, NOF_CLIENTS)

S_a_trans = inst_i(S_a_trans_i, NOF_CLIENTS)
S_g_trans = '%s && %s' % (inst_i(S_g_trans_i, NOF_CLIENTS), inst_i_j(S_g_trans_i_j, NOF_CLIENTS))

L_a_property = inst_i(L_a_i, NOF_CLIENTS)
L_g_property = inst_i(L_g_i, NOF_CLIENTS)
