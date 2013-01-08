import math
from helpers.python_ext import bin_fixed_list
from interfaces.parser_expr import Bool, Signal, BinOp, UnaryOp, and_expressions, ForallExpr, QuantifiedSignal, Number


SCHED_ID_PREFIX = 'sch'
ACTIVE_NAME_MY = 'active' #TODO: check in searcher, that everything is OK(??)


class InterleavingScheduler:
    """ The only process is active. """

    _FAIR_SCHED_NAME = 'fair_scheduling'

#    def _get_inf_sched_prop(self, proc_index, nof_processes, sched_id_prefix):
#        assert nof_processes > 0
#        assert proc_index <= nof_processes - 1
#
#        nof_sched_bits = int(max(1, math.ceil(math.log(nof_processes, 2))))
#        bits = bin_fixed_list(proc_index, nof_sched_bits)
#
#        conjuncts = [BinOp('=', Signal(sched_id_prefix+str(bit_index)),
#                                Bool(bit_value))
#                    for bit_index, bit_value in enumerate(bits)]
#
#        conjunction = and_expressions(conjuncts)
#        res = UnaryOp('G', UnaryOp('F', conjunction))
#        return res
#
#
#    def _get_fair_sched_prop(self, nof_processes, sched_id_prefix):
#        sched_constraints = [self._get_inf_sched_prop(i, nof_processes, sched_id_prefix)
#                             for i in range(nof_processes)]
#        return and_expressions(sched_constraints)

    @property
    def assumptions(self):
        return [ForallExpr(['i'],
            UnaryOp('G', UnaryOp('F',
                                 BinOp('=',
                                        QuantifiedSignal(self._FAIR_SCHED_NAME, 'i'),
                                        Number(1)))))]


    def is_scheduler_signal(self, signal:QuantifiedSignal) -> bool:
        return signal.name == self._FAIR_SCHED_NAME