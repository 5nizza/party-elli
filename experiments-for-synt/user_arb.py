from helpers.spec_helper import *
from interfaces.spec import Spec

us, u = sig_prop('u')
rs, r = sig_prop('r')
gs, g = sig_prop('g')

####################################################################

two_only_is_possible = EGF(r&~g & X(~r&g & X(g & AX(~g))))
three_only_is_possible = EGF(r&~g & X(~r&g & X(~r&g & X(g & AX(~g)))))
four_only_is_possible = EGF(r&~g & X(~r&g & X(~r&g & X(~r&g & X(g & AX(~g))))))

always_grant_is_possible = EFAG(g)
always_not_grant_is_possible = EFAG(~g)

every_req_is_granted_possible = EG(r >> (u&F(g))) & EG(r >> (~u&F(g)))

formula = ~g & two_only_is_possible & \
          three_only_is_possible & \
          four_only_is_possible & \
          always_grant_is_possible & \
          always_not_grant_is_possible

#formula = EGF(r&X(~r&g&X(~r&g&X(g)))) & \
#          EGF(~r&X(~r&~g)) & \
#          AG(r >> F(g&X(F(g) & F(~g)))) & \
#          AG(EFG(r&g) >> X(EFG(~r&~g))) &\
#          AG(FG(g&X(~g)) >> E(g&X(g & X(~g))))

inputs = [rs, us]
outputs = [gs]

spec = Spec(inputs, outputs, formula)
