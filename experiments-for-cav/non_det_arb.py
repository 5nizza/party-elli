from helpers.spec_helper import *
from interfaces.spec import Spec

us, u = sig_prop('u')

rs, r = sig_prop('r')
gs, g = sig_prop('g')

####################################################################

# formula = A(r >> F(g)) & \
#           E(~g & r & X(g & ~r & X(~g))) & \
#           E(~g & r & X(g & ~r & X(g)))
formula = A(r >> F(g)) & \
          AGF(~g) & \
          E(~g & E(r&X(~g)) & E(r&X(g)))


inputs = [rs, us]
outputs = [gs]

spec = Spec(inputs, outputs, formula)
