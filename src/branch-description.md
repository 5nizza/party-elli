This branch tries to implement the encoding according to GR1 semantics.

GR1 semantics is:

    Ass_init -> Gua_init & 
    Ass_init -> gua(i,o,i',o') W ~ass(i,o,i') & 
    Ass_init & G(ass(i,o,i')) LivenessAss -> LivenessGua

## General case

In general case of ass=ass(i,o,i') we do:

    for each s,q:
      for each two edges of the UCW q -> q' -> q'' (with i,o,i',o') (without env assumptions):
        laB(s,q) & ass(i, o(s), i') & laB(tau(s,i), q') -> laB(tau(tau(s,i),i'), q'') & ..
                                                           laC(tau(tau(s,i),i'), q'') >< laC(s',q')
__TODO__: check

In the case of GR1 safety guarantees, of the form gua(i,o,i',o'):

    for each state:
      for each inputs i,i':
        ass(i, o(s), i') -> gua(i, o(s), i', tau(s,i), o(s'))


## Special case of `ass=ass(i)`: we optimize it
For UCW properties:

    for each s,q:
      for each edge of the UCW (without env assumptions):
        laB(s,q) & ass(edge_inputs) & outputs -> laB(tau(s,i),q') & 
                                                 laC(tau(s,i),q') >< laC(s,q)

(in other words to each transition of the UCW except dead-ends we add ass)

For GR1 safety guarantees we do: 

    for each state:
      for each inputs i,i' that satisfy ass(i) and ass(i'):
        gua(i, o(s), i', o(tau(s,i)))
 

-----------------
The way of handling env assumptions of the form G(crt) and G(crt, next) is:
if the function does not contain the next operator, the func arguments do not contain next input.




