from interfaces.parser_expr import and_expressions, BinOp, Bool, Expr


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
        return 'inputs:{0}, outputs:{1}, properties:{2}'.format(self._inputs, self._outputs,
                                                                '\n'.join(self._properties))


#TODO: clarify connection with class Spec
class SpecProperty:
    def __init__(self, assumptions:list, guarantees:list):
        self.assumptions = assumptions
        self.guarantees = guarantees

    def __str__(self):
        return '  (SpecProperty: \n\tassumptions={ass}, \n\t  guarantees={gua})  '.format(
            ass=str(self.assumptions),
            gua=str(self.guarantees))

    __repr__ = __str__


################################################################
#helpers

def to_expr(spec_property:SpecProperty) -> Expr:
    return BinOp('->', and_expressions(spec_property.assumptions),
                 and_expressions(spec_property.guarantees))


def and_properties(properties) -> SpecProperty:
    property_expressions = [BinOp('->',
                                  and_expressions(p.assumptions),
                                  and_expressions(p.guarantees))
                            for p in properties]

    return SpecProperty([Bool(True)], [and_expressions(property_expressions)])


def expr_from_property(property:SpecProperty) -> Expr:
    return BinOp('->', and_expressions(property.assumptions),
                 and_expressions(property.guarantees))






