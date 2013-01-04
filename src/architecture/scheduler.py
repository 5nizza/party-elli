import math
from helpers.python_ext import bin_fixed_list
from interfaces.parser_expr import Bool, Signal, BinOp, UnaryOp, and_expressions


SCHED_ID_PREFIX = 'sch'
ACTIVE_NAME_MY = 'active' #TODO: check in searcher, that everything is OK(??)


class InterleavingScheduler:
    """ The only process is active. """

    def _get_inf_sched_prop(self, proc_index, nof_processes, sched_id_prefix):
        assert nof_processes > 0
        assert proc_index <= nof_processes - 1

        nof_sched_bits = int(max(math.ceil(math.log(nof_processes, 2)), 1))

        bits = bin_fixed_list(proc_index, nof_sched_bits)


        conjuncts = [BinOp('=', Signal(sched_id_prefix+str(bit_index)),
                                Bool(bit_value))
                    for bit_index, bit_value in enumerate(bits)]

        conjunction = and_expressions(conjuncts)
        res = UnaryOp('G', UnaryOp('F', conjunction))
        return res
#        id_as_formula = ' && '.join(['({0}{1}{2})'.format(['!', ''][bit_value], sched_id_prefix, bit_index)
#                                     for bit_index, bit_value in enumerate(bits)])
#
#        return 'GF({0})'.format(id_as_formula)


    def _get_fair_sched_prop(self, nof_processes, sched_id_prefix):
        sched_constraints = [self._get_inf_sched_prop(i, nof_processes, sched_id_prefix)
                             for i in range(nof_processes)]
        return and_expressions(sched_constraints)


    def inst_ass(self, nof_processes):
        return self._get_fair_sched_prop(nof_processes, SCHED_ID_PREFIX)
