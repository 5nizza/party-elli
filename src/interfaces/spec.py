from typing import Iterable, Set

from interfaces.expr import Signal, Expr


class Spec:
    def __init__(self,
                 inputs:Iterable[Signal],
                 outputs:Iterable[Signal],
                 formula:Expr):
        self.inputs = set(inputs)
        self.outputs = set(outputs)
        self.formula = formula

    def __str__(self):
        return "inputs: '%s', outputs: '%s', formula: '%s''" % \
               (str(self.inputs), str(self.outputs), str(self.formula))
