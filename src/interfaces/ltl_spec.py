class LtlSpec:
    def __init__(self, inputs, outputs, properties):
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
    def propertis(self):
        return self._properties

    def __str__(self):
        return 'inputs:{0}, outputs:{1}, properties:{2}'.format(self._inputs, self._outputs, self._properties)
