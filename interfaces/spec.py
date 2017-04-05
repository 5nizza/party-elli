from typing import Iterable
from typing import Set

from interfaces.expr import Signal, Expr


class Spec:
    def __init__(self,
                 inputs:Iterable[Signal],
                 outputs:Iterable[Signal],
                 formula:Expr):
        self.inputs = set(inputs)    # type: Set[Signal]
        self.outputs = set(outputs)  # type: Set[Signal]
        self.formula = formula       # type: Expr

    def __str__(self):
        return "inputs: '%s', outputs: '%s', formula: '%s''" % \
               (str(self.inputs), str(self.outputs), str(self.formula))
