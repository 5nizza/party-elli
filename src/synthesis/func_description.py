from helpers.python_ext import index_of

class FuncDescription:
    def __init__(self, func_name,
                 argname_to_type, architecture_inputs:"inputs that are managed by Impl?",
                 output,
                 body):
        self._name = func_name
        self._output = output
        self._body = body
        self._architecture_inputs = architecture_inputs
        self._ordered_input_type_pairs = list(argname_to_type.items())


    @property
    def name(self):
        return self._name

    @property
    def architecture_inputs(self):
        return self._architecture_inputs

    @property
    def inputs(self):
        """ Return: ordered input_type pairs """
        return self._ordered_input_type_pairs

    @property
    def output(self):
        return self._output

    @property
    def definition(self):
        if self._body is None:
            return None

        inputs = list(map(lambda input_type_pair: '({name} {type})'.format(
            name = input_type_pair[0],
            type = input_type_pair[1]), self.inputs))

        return """(define-fun {name} ({inputs}) {output}
        {body}
        )""".format(
            name = self._name,
            inputs = ' '.join(inputs),
            output = self._output,
            body = self._body
        )

    def get_args_list(self, argname_to_value):
        args = dict()
        for argname, value in argname_to_value.items():
            index = index_of(lambda in_ty_pair: in_ty_pair[0]==argname, self._ordered_input_type_pairs)
            assert index is not None, argname

            args[index] = value

        args_list = sorted(list(args.items()), key=lambda i_a: i_a[0])
        ordered_values = list(map(lambda i_a: i_a[1], args_list))
        return ordered_values

    def __str__(self):
        return 'name: {name}, inputs: {inputs} (archit. inputs: {archi_inputs}), output: {output}, definition: \n{definition}'.format(
            name=self._name,
            inputs = str(self._ordered_input_type_pairs),
            archi_inputs = str(self._architecture_inputs),
            output = self._output,
            definition = self.definition
        )

    def __eq__(self, other):
        if not isinstance(other, FuncDescription):
            return False

        return str(other) == str(self)

    def __hash__(self):
        return hash(str(self))

    __repr__ = __str__
