from itertools import chain, combinations

NOF_CLIENTS = 2  # change at your will

##################################################
# parameterized
def and_(*args):
    return '&&'.join('(%s)' % s for s in args)


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
# some helpers

def inst_i(prop_i:str):
    return '&&'.join('(%s)'%prop_i.format(i=n)
                     for n in range(NOF_CLIENTS))


def inst_i_j(prop_i_j:str):
    return '&&'.join('(%s)'%prop_i_j.format(i=n1,j=n2)
                     for (n1,n2) in combinations(range(NOF_CLIENTS), 2))  # symmetric property, so we use 'combinations'


##################################################
# now the spec instantiated

inputs = list(chain(*[[sig.format(i=n) for n in range(NOF_CLIENTS)]
                      for sig in inputs_i]))
outputs = list(chain(*[[sig.format(i=n) for n in range(NOF_CLIENTS)]
                       for sig in outputs_i]))

S_a_init = inst_i(S_a_init_i)
S_g_init = inst_i(S_g_init_i)

S_a_trans = inst_i(S_a_trans_i)
S_g_trans = '%s && %s' % (inst_i(S_g_trans_i), inst_i_j(S_g_trans_i_j))

L_a_property = inst_i(L_a_i)
L_g_property = inst_i(L_g_i)
