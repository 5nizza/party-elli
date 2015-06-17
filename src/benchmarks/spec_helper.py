from itertools import combinations


def and_(*args):
    return '&&'.join('(%s)' % s for s in args)

def inst_i(prop_i:str, nof:int):
    return '&&'.join('(%s)'%prop_i.format(i=n)
                     for n in range(nof))


def inst_i_j(prop_i_j:str, nof:int):
    return '&&'.join('(%s)'%prop_i_j.format(i=n1,j=n2)
                     for (n1,n2) in combinations(range(nof), 2))  # symmetric property, so we use 'combinations'


def print_spec(cur_globals):
    attrs = ['S_a_init', 'S_a_trans', 'L_a_property', 'S_g_init', 'S_g_trans', 'L_g_property']
    print()
    for a in attrs:
        print(a + ':')
        print(cur_globals[a])
        print()


def pollute(cur_globals,
            inputs, outputs,
            S_a_init, S_a_trans, L_a_property,
            S_g_init, S_g_trans, L_g_property):
    vals = [inputs, outputs, S_a_init, S_a_trans, L_a_property, S_g_init, S_g_trans, L_g_property]
    keys = ['inputs', 'outputs', 'S_a_init', 'S_a_trans', 'L_a_property', 'S_g_init', 'S_g_trans', 'L_g_property']
    cur_globals.update(dict(zip(keys,vals)))

