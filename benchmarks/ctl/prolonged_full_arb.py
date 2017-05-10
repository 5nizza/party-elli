# expensive!
# takes > 1h and produces 7 states Moore system
# (with direct encoding)

from helpers.spec_helper import *
from interfaces.spec import Spec

rs0, r0 = sig_prop('r0')
gs0, g0 = sig_prop('g0')

rs1, r1 = sig_prop('r1')
gs1, g1 = sig_prop('g1')

#############################################

no_spurious_grants_on_start = \
  ~EU(~r0 & ~g0, ~r0 & g0) & \
  ~EU(~r1 & ~g1, ~r1 & g1)

no_spurious_grants = \
  ~EF(g0 & X(~r0 & ~g0) & X(U(~r0 & ~g0, g0 & ~r0) )) & \
  ~EF(g1 & X(~r1 & ~g1) & X(U(~r1 & ~g1, g1 & ~r1) ))

grants_go_down = \
  AG( (~r0 & g0) >> F(r0 & g0 | ~g0) ) & \
  AG( (~r1 & g1) >> F(r1 & g1 | ~g1) )

req_are_granted = \
  AG( r0 >> F(g0) ) & \
  AG( r1 >> F(g1) )

mut_excl = AG(~(g0 & g1))

longer_grant = \
  EGF(A(~r0 >> (g0 & X(g0)))) & \
  EGF(A(~r1 >> (g1 & X(g1))))

#############################################

formula = no_spurious_grants_on_start & \
          no_spurious_grants & \
          req_are_granted & \
          grants_go_down & \
          longer_grant & \
          mut_excl

inputs = [rs0,rs1]
outputs = [gs0,gs1]

spec = Spec(inputs, outputs, formula)
