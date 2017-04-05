from typing import Dict


class FuncDesc:
    def __init__(self,
                 func_name:str,
                 type_by_arg:Dict[str, str],
                 output_ty:str):
        self.name = func_name
        self.output_ty = output_ty
        self.ordered_argname_type_pairs = sorted(list(type_by_arg.items()),
                                                 key=lambda t_a: str(t_a[0]))

    def __str__(self):
        return '<name: {name}, inputs: {inputs}, output: {output}>'.format(
            name=self.name,
            inputs=str(self.ordered_argname_type_pairs),
            output=self.output_ty
        )

    def __eq__(self, other):
        if not isinstance(other, FuncDesc):
            return False
        return str(other) == str(self)

    def __hash__(self):
        return hash(str(self))

    __repr__ = __str__
