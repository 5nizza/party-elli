from helpers.spec_helper import *
from interfaces.spec import Spec

rs1, r1 = sig_prop('r1')
gs1, g1 = sig_prop('g1')

# rs2, r2 = sig_prop('r2')
# gs2, g2 = sig_prop('g2')

inputs = [rs1]
outputs = [gs1]

formula = AGEF(~g1 & ~r1)

spec = Spec(inputs, outputs, formula)
