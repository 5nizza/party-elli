from itertools import combinations


def and_(*args):
    return '&&'.join('(%s)' % s for s in args)

def inst_i(prop_i:str, nof:int):
    return '&&'.join('(%s)'%prop_i.format(i=n)
                     for n in range(nof))


def inst_i_j(prop_i_j:str, nof:int):
    return '&&'.join('(%s)'%prop_i_j.format(i=n1,j=n2)
                     for (n1,n2) in combinations(range(nof), 2))  # symmetric property, so we use 'combinations'
