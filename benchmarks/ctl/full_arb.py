from helpers.spec_helper import *
from interfaces.spec import Spec

rs0, r0 = sig_prop('r0')
gs0, g0 = sig_prop('g0')

rs1, r1 = sig_prop('r1')
gs1, g1 = sig_prop('g1')

# (this is pure LTL)

#no spurious grants on start
no_spurious_grants_on_start = \
  ~EU(~r0 & ~g0, ~r0 & g0) & \
  ~EU(~r1 & ~g1, ~r1 & g1)

#no spurious grants
no_spurious_grants = \
  ~EF(g0 & X(~r0 & ~g0) & X(U(~r0 & ~g0, g0 & ~r0) )) & \
  ~EF(g1 & X(~r1 & ~g1) & X(U(~r1 & ~g1, g1 & ~r1) ))

#every grant is lowered unless request keeps staying high
grants_go_down = \
  AG( (~r0 & g0) >> F(r0 & g0 | ~g0) ) & \
  AG( (~r1 & g1) >> F(r1 & g1 | ~g1) )

#every request is granted
req_are_granted = \
  AG( r0 >> F(g0) ) & \
  AG( r1 >> F(g1) )

#mutual exclusion
mut_excl = AG(~(g0 & g1))

######################################################

formula = no_spurious_grants_on_start & \
          no_spurious_grants & \
          req_are_granted & \
          grants_go_down & \
          mut_excl

inputs, outputs = [rs0,rs1], [gs0,gs1]

spec = Spec(inputs, outputs, formula)
