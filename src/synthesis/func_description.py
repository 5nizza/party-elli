from helpers.python_ext import index_of

class FuncDescription:
    def __init__(self, func_name,
                 type_by_arg,
                 output,
                 body):
        self._name = func_name
        self._output = output
        self._body = body
        self._ordered_input_type_pairs = list(type_by_arg.items())


    @property
    def name(self):
        return self._name

#    @property
#    def architecture_inputs(self):
#        return self._architecture_inputs

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


    def get_args_list(self, value_by_argname:dict):
        assert set([p[0] for p in self._ordered_input_type_pairs]).issubset(set(value_by_argname.keys()))

        value_by_arg = dict()
        for arg, value in value_by_argname.items():
            index = index_of(lambda in_ty_pair: in_ty_pair[0]==arg, self._ordered_input_type_pairs)
            if index is None:
                continue

            value_by_arg[index] = value

        args_list = sorted(list(value_by_arg.items()), key=lambda i_a: i_a[0])
        ordered_values = list(map(lambda i_a: i_a[1], args_list))
        return ordered_values


    def get_args_dict(self, values) -> dict:
        value_by_arg = dict()
        for i, v in enumerate(values):
            arg, type = self._ordered_input_type_pairs[i]
            value_by_arg[arg] = v

        return value_by_arg


    def __str__(self):
        return '<name: {name}, inputs: {inputs}, output: {output}, definition: \n{definition}>'.format(
            name=self._name,
            inputs = str(self._ordered_input_type_pairs),
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
