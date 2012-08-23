class Logic:
    def counters_type(self):
        pass
    def smt_name(self):
        pass
    @property
    def gt(self):
        pass
    @property
    def ge(self):
        pass


class UFBV(Logic):
    def __init__(self, width):
        self._width = width

    def counters_type(self):
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

    def counters_type(self):
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
