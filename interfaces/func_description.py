from helpers.python_ext import lmap


class InlinePredDesc:
    def __init__(self, body:str):
        """
        :param body: should be in the python string format (like (= {arg1} {arg2}) )
        NOTE: we assume arguments are in the global naming format
        """
        self._body = body

    def call_func(self, val_by_arg:dict):
        return self._body.format_map(val_by_arg)

    def __str__(self):
        return self._body

    __repr__ = __str__

    def __eq__(self, other):
        if not isinstance(other, InlinePredDesc):
            return False
        return str(other) == str(self)

    def __hash__(self):
        return hash(str(self))


class FuncDesc:
    def __init__(self, func_name,
                 type_by_arg:dict,
                 output_ty,
                 body=None):
        self._name = func_name
        self._output = output_ty
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
                                                key=lambda t_a: str(t_a[0]))

    @property
    def name(self):
        return self._name

    @property
    def inputs(self):
        """ Return: ordered input_type pairs """
        return self._ordered_input_type_pairs

    @property
    def output_ty(self):
        return self._output

    @property
    def definition(self):
        if self._body is None:
            return None

        inputs = ['({name} {type})'.format(name=input_type[0], type=input_type[1])
                  for input_type in self._ordered_input_type_pairs]

        return ('(define-fun {name} ({inputs}) {output} \n' +
                '{body}\n' +
                ')').format(name=self._name,
                            inputs=' '.join(inputs),
                            output=self._output,
                            body=self._body)

    def _get_args_list(self, value_by_argname:dict) -> list:
        my_args = set([p[0] for p in self._ordered_input_type_pairs])
        given_args = set(value_by_argname.keys())
        assert my_args.issubset(given_args), \
            self.name + ': given values for \n{0}\n, but I need for \n{1}'\
                        .format(given_args, my_args)

        ordered_values = []
        for (signal, ty) in self._ordered_input_type_pairs:
            value = value_by_argname[signal]
            ordered_values.append(value)

        return ordered_values

    def get_args_dict(self, values) -> dict:
        value_by_arg = dict()
        for i, v in enumerate(values):
            arg, ty = self._ordered_input_type_pairs[i]
            value_by_arg[arg] = v

        return value_by_arg

    def call_func(self, func_args_dict:dict) -> str:
        smt_func_args_dict = dict()
        for (var,val) in func_args_dict.items():
            if val is True:
                val = "true"
            elif val is False:
                val = "false"
            smt_func_args_dict[var] = val

        func_args_dict = smt_func_args_dict

        args = self._get_args_list(func_args_dict)

        smt_str = '(' + self.name + ' '
        for arg in args:
            smt_str += str(arg) + ' '
        if len(args):
            smt_str = smt_str[:-1]
        smt_str += ')'

        return smt_str

    def declare_fun(self) -> str:
        input_types = lmap(lambda i_t: i_t[1], self.inputs)
        smt_str = '(declare-fun '
        smt_str += self.name + ' ('

        for var in input_types:
            smt_str += var + ' '
        if len(input_types):
            smt_str = smt_str[:-1]

        smt_str += ') ' + str(self.output_ty) + ')\n'
        return smt_str

    def __str__(self):
        return '<name: {name}, inputs: {inputs}, output: {output}, definition: \n{definition}>'.format(
            name=self._name,
            inputs=str(self._ordered_input_type_pairs),
            output=self._output,
            definition=self.definition
        )

    def __eq__(self, other):
        if not isinstance(other, FuncDesc):
            return False

        return str(other) == str(self)

    def __hash__(self):
        return hash(str(self))

    __repr__ = __str__
