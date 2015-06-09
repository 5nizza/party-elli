# This file is dynamically imported by the tool,
# so keep the python syntax
# and variable names-types:
# inputs, outputs,
# ...

inputs = ['r1', 'r2']
outputs = ['g1', 'g2']



######## In the ltl3ba format #######
# for the format, see for example:
# http://www.lsv.ens-cachan.fr/~gastin/ltl2ba/index.php

# Safety part
S_a_trans = '!(r1 && r2)'
S_g_trans = '!(g1 && g2) && (r1 -> X g1) && (r2 -> X g2)'

# Liveness part
L_a_property = '(G F r1) &&  (G F !r1) && (G F r2) && (G F !r2)'
L_g_property = '(G F g1) &&  (G F !g1) && (G F g2) && (G F !g2)'
