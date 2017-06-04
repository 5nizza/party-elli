from itertools import chain
from typing import Iterable

from automata.automata_classifier import is_final_sink
from automata.helper import incoming_transitions
from helpers.python_ext import StrAwareList, lfilter
from interfaces.automaton import Automaton, Label
from interfaces.expr import Signal


def atm_to_verilog(atm:Automaton,
                   sys_inputs:Iterable[Signal],
                   sys_outputs:Iterable[Signal],
                   module_name:str,
                   bad_out_name:str) -> str:
    assert len(lfilter(lambda n: is_final_sink(n), atm.nodes)) == 1,\
        'for now I support only one bad state which must be a sink'
    sys_inputs = set(sys_inputs)
    sys_outputs = set(sys_outputs)

    verilog_by_sig = {s:'controllable_'+s.name for s in sys_outputs}
    verilog_by_sig.update({s:s.name for s in sys_inputs})

    verilog_by_node = {q:'__q' + q.name for q in atm.nodes}
    sink_q = lfilter(lambda n: is_final_sink(n), atm.nodes)[0]

    module_inputs = list(chain(map(lambda i: i.name, sys_inputs),
                               map(lambda o: 'controllable_' + o.name, sys_outputs)))

    s = StrAwareList()
    s += 'module {module_name}({inputs}, {output});'.format(
        module_name=module_name,
        inputs=', '.join(module_inputs),
        output=bad_out_name)
    s.newline()

    s += '\n'.join('input %s;' % i for i in module_inputs)
    s.newline()

    s += 'output %s;' % bad_out_name
    s.newline()

    s += '\n'.join('reg %s;' % vq
                   for vq in verilog_by_node.values())
    s.newline()

    s += 'wire %s;' % bad_out_name
    s += 'assign {bad} = {sink_q};'.format(bad=bad_out_name,
                                           sink_q=verilog_by_node[sink_q])
    s.newline()

    s += 'initial begin'
    s += '\n'.join('%s = 1;' % verilog_by_node[iq]
                   for iq in atm.init_nodes)
    s += '\n'.join('%s = 0;' % verilog_by_node[q]
                   for q in atm.nodes-atm.init_nodes)
    s += 'end'
    s.newline()

    s += 'always@($global_clock)'
    s += 'begin'

    def lbl_to_v(lbl:Label) -> str:
        return ' && '.join(('!%s','%s')[lbl[s]]%verilog_by_sig[s] for s in lbl) or '1'

    for q in atm.nodes:
        incoming_edges = incoming_transitions(q, atm)
        if not incoming_edges:
            update_expr = '0'
        else:
            update_expr = ' || '.join('{src} && {lbl}'.format(src=verilog_by_node[edge[0]],
                                                              lbl=lbl_to_v(edge[1]))
                                      for edge in incoming_edges)
        s += '  {q} <= {update_expr};'.format(q=verilog_by_node[q],
                                              update_expr=update_expr)
    s += 'end'
    s += 'endmodule'
    return s.to_str()
