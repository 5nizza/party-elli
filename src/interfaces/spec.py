from interfaces.expr import and_expressions, BinOp, Bool


class Spec:   # TODO: not used?
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
        return 'inputs:{0}, outputs:{1}, properties:{2}'.format(self._inputs, self._outputs,
                                                                '\n'.join(self._properties))


class AssumptionsGuaranteesPair:
    def __init__(self, assumptions, guarantees):
        self.assumptions = assumptions
        self.guarantees = guarantees

    def __str__(self):
        return '  (assumptions={ass}, \nguarantees={gua})  '.format(
            ass=str(self.assumptions),
            gua=str(self.guarantees))

    __repr__ = __str__
