# There is a tableay-based approach:
# http://staffhome.ecm.uwa.edu.au/~00054620/research/Online/quicktab/
# http://staffhome.ecm.uwa.edu.au/~00054620/research/Online/startab/results.html
# This is formula 14 from that list
# (AG(p>EXr)&AG(r>EXp))>(p>EG(Fp&Fr))


from helpers.spec_helper import *
from interfaces.spec import Spec

is1, i1 = sig_prop('i1')
is2, i2 = sig_prop('i2')
ps, p = sig_prop('p')
rs, r = sig_prop('r')

# (AG(p>EXr)&AG(r>EXp))>(p>EG(Fp&Fr))
formula = ~((AG(p >> EX(r)) & AG(r >> EX(p))) >> (p >> EG(F(p) & F(r))))

inputs = [is1, is2]
outputs = [ps, rs]

spec = Spec(inputs, outputs, formula)
