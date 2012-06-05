from math import ceil, log


class Logic:
    def counters_type(self, max_counter_value):
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
    def counters_type(self, max_counter_value):
        width = int(ceil(log(max(max_counter_value, 2), 2)))
        return '(_ BitVec {0})'.format(width)

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
