from interfaces.parser_expr import QuantifiedSignal


class FuncDescription:
    def __init__(self, func_name,
                 type_by_arg:dict,
                 output,
                 body):
        self._name = func_name
        self._output = output
        self._body = body

        #TODO: evil hack
        # Tau function of each process though isomorphic has slightly different signals
        # for example, tau_0 has signals indexed with 0 and tau_1 - signals indexed with 1
        #
        # This may lead to different order of arguments in different tau functions.
        # for example, tau0 has r0,sch0,proc0,prev0
        #          and tau1 has prev1,sch0,proc0,r1
        # The problem is that I call the same instance of tau function in the end.
        # Therefore the order of arguments should be the same.
        # To assure this, lets sort signals with respect to their str(s) implementation.

        self._ordered_input_type_pairs = sorted(list(type_by_arg.items()),
                                                key=lambda t_a: str(t_a[0]) if not isinstance(t_a[0], QuantifiedSignal)
                                                else str(t_a[0].name))  # sorting ignores indices

    @property
    def name(self):
        return self._name

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

        inputs = ['({name} {type})'.format(name=input_type[0], type=input_type[1])
                  for input_type in self._ordered_input_type_pairs]

        return """(define-fun {name} ({inputs}) {output}
        {body}
        )""".format(
            name=self._name,
            inputs=' '.join(inputs),
            output=self._output,
            body=self._body
        )

    def get_args_list(self, value_by_argname:dict) -> list:
        assert set([p[0] for p in self._ordered_input_type_pairs]).issubset(set(value_by_argname.keys())), \
            'requested \n{0}\n, but I have \n{1}'.format(value_by_argname, self._ordered_input_type_pairs)

        ordered_values = []
        for (signal, type) in self._ordered_input_type_pairs:
            value = value_by_argname[signal]
            ordered_values.append(value)

        return ordered_values

    def get_args_dict(self, values) -> dict:
        value_by_arg = dict()
        for i, v in enumerate(values):
            arg, ty = self._ordered_input_type_pairs[i]
            value_by_arg[arg] = v

        return value_by_arg

    def __str__(self):
        return '<name: {name}, inputs: {inputs}, output: {output}, definition: \n{definition}>'.format(
            name=self._name,
            inputs=str(self._ordered_input_type_pairs),
            output=self._output,
            definition=self.definition
        )

    def __eq__(self, other):
        if not isinstance(other, FuncDescription):
            return False

        return str(other) == str(self)

    def __hash__(self):
        return hash(str(self))

    __repr__ = __str__
