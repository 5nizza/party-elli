from collections import Iterable

class Spec:
    def __init__(self, inputs, outputs, properties):
        assert properties
        assert not isinstance(properties, str)

        self._inputs = inputs
        self._outputs = outputs
        self._properties = properties

    @property
    def inputs(self):
        return self._inputs

    @property
    def outputs(self):
        return self._outputs

    @property
    def properties(self):
        return self._properties

    def __str__(self):
        return 'inputs:{0}, outputs:{1}, properties:{2}'.format(self._inputs, self._outputs, '\n'.join(self._properties))


#TODO: clarify connection with class Spec
class SpecProperty:
    def __init__(self, assumptions:list, guarantees:list):
        self.assumptions = assumptions
        self.guarantees = guarantees

    def __str__(self):
        return '  (SpecProperty: assumptions={ass}, guarantees={gua})  '.format(
            ass = str(self.assumptions),
            gua = str(self.guarantees))

    __repr__ = __str__