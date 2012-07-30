class Spec:
    def __init__(self, inputs, outputs, property):
        self._inputs = inputs
        self._outputs = outputs
        self._property = property

    @property
    def inputs(self):
        return self._inputs

    @property
    def outputs(self):
        return self._outputs

    @property
    def property(self):
        return self._property

    def __str__(self):
        return 'inputs:{0}, outputs:{1}, property:{2}'.format(self._inputs, self._outputs, self._property)
