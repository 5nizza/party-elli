from helpers.spec_helper import *
from interfaces.spec import Spec

us, u = sig_prop('u')

rs, r = sig_prop('r')
gs, g = sig_prop('g')

####################################################################

# some strange realizable spec

formula = ~g & \
          AGF(~g) & \
          A(r >> F(g)) & \
          E(r & X(g)) & \
          E(r & X(~g)) & \
          E(r & X(g & X(g))) & \
          E(~r & X(~g & X(~g)))

inputs = [rs, us]
outputs = [gs]

spec = Spec(inputs, outputs, formula)
