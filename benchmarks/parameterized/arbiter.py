# just an idea
import par_spec #definition of indices i,j,..etc

r, r_burst, cancel = InputSignals('r, r_burst, cancel')
g, g_burst, cancelled = OutputSignals('g, g_burst, cancelled')

prop1 = Forall(r-i, g-i) (GF(r-i and g-i or r-i) |U| !X())

properties = [prop1, prop2, prop3]

model=synthesize(inputs, outputs, properties)
model.print()

model=synthesize(inputs, outputs, properties, cutoff=3)
model.dot('file.dot')
model.verilog('file.verilog')


