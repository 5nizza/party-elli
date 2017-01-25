from helpers.spec_helper import *
from interfaces.spec import Spec

is1, i1 = sig_prop('i1')
is2, i2 = sig_prop('i2')

os1, o1 = sig_prop('o1')
os2, o2 = sig_prop('o2')

inputs = [is1,is2]
outputs = [os1,os2]

# spec5:
# diff: just like spec 3,
# but in the SMT query the sender has only one state (should be enough)
formula = AG((i1&i2) >> F(o1 & o2)) & \
          AG((i1&i2&o1&o2) >> X(o1&o2)) & \
          AG(EF(o1&~o2) & \
             EF(~o1&o2) & \
             EF(~o1&~o2) & \
             EF(o1&o2))

# spec4:
# diff: it requires both modules to be Moore,
# thus we need X(X(..)) rather than X(..)
# formula = AG((i1&i2) >> F(o1 & o2)) & \
#           AG((i1&i2&o1&o2) >> X(X(o1&o2))) & \
#           AG(EF(o1&~o2) & \
#              EF(~o1&o2) & \
#              EF(~o1&~o2) & \
#              EF(o1&o2))

# spec3:
# diff: it has AGEF instead of E(GF..GF..)
# formula = AG((i1&i2) >> F(o1 & o2)) & \
#           AG((i1&i2&o1&o2) >> X(o1&o2)) & \
#           AG(EF(o1&~o2) & \
#              EF(~o1&o2) & \
#              EF(~o1&~o2) & \
#              EF(o1&o2))

# spec2:
# it says that a single path should raise all combinations of o1 o2
# (rather than allowing different paths to do so)
# formula = AG((i1&i2) >> F(o1 & o2)) & \
#           AG((i1&i2&o1&o2) >> X(o1&o2)) & \
#           E(GF(o1&~o2) & \
#             GF(~o1&o2) & \
#             GF(~o1&~o2) & \
#             GF(o1&o2))

# spec1 (it has model 1)
# formula = AG((i1&i2) >> F(o1 & o2)) & \
#           AG((i1&i2&o1&o2) >> X(o1&o2)) & \
#           EGF(o1&~o2) & \
#           EGF(~o1&o2) & \
#           EGF(~o1&~o2) & \
#           EGF(o1&o2)

spec = Spec(inputs, outputs, formula)
