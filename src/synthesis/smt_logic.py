from abc import ABCMeta


class Logic:
    __metaclass__ = ABCMeta

    def counters_type(self, max_counter_value):
        raise NotImplementedError()

    def smt_name(self):
        raise NotImplementedError()

    @property
    def gt(self):
        raise NotImplementedError()

    @property
    def ge(self):
        raise NotImplementedError()


class UFBV(Logic):  # TODO: 1. proper instantiation 2. use it or remove it
    def __init__(self, width):
        self._width = width

    def counters_type(self, max_counter_value):
        return '(_ BitVec {0})'.format(self._width)

    @property
    def smt_name(self):
        return 'UFBV'

    @property
    def gt(self):
        return 'bvugt'

    @property
    def ge(self):
        return 'bvuge'


class UFLIA(Logic):
    def __init__(self, upper_bound):
        self._upper_bound = upper_bound

    def counters_type(self, max_counter_value):
        return 'Int'

    @property
    def smt_name(self):
        return 'UFLIA'

    @property
    def gt(self):
        return '>'

    @property
    def ge(self):
        return '>='


class UFLRA(Logic):
    def counters_type(self, max_counter_value):
        return 'Real'

    @property
    def smt_name(self):
        return 'UFLRA'

    @property
    def gt(self):
        return '>'

    @property
    def ge(self):
        return '>='
