import math

from helpers.python_ext import lmap, StrAwareList
from interfaces.expr import Signal
from interfaces.lts import LTS


def _label_to_verilog(label:dict) -> str:
    return '(%s)' % ' && '.join(map(lambda sig_val: '({sig}=={val})'.format(sig=sig_val[0],
                                                                            val='01'[sig_val[1]] if isinstance(sig_val[0], Signal)
                                                                                                 else sig_val[1]),
                                    label.items()))


def lts_to_verilog(lts:LTS) -> str:
    s = StrAwareList()

    s += 'module model(i_clk, \n{inputs}, \n{outputs});'.format(inputs=', '.join(map(lambda sig: sig.name,
                                                                                     lts.input_signals)),
                                                                outputs=', '.join(map(lambda sig: sig.name,
                                                                                      lts.output_signals)))
    s.newline()

    s += 'input i_clk;'
    s += '\n'.join(['input {sig};'.format(sig=sig.name) for sig in lts.input_signals])
    s.newline()

    s += '\n'.join(['output {sig};'.format(sig=sig.name) for sig in lts.output_signals])
    s.newline()

    nof_state_bits = math.ceil(math.log2(len(lts.states)))
    s += 'reg [{max_bit}:0] {state};'.format(max_bit=nof_state_bits-1, state=lts.state_name)
    s.newline()

    s += '\n'.join(['wire {out};'.format(out=sig.name) for sig in lts.output_signals])

    for out_sig, value_tuples in lts.output_models.items():
        labels_true = lmap(lambda x: x[0],
                           filter(lambda label_value: label_value[1],
                                  value_tuples.items()))
        assign = 'assign {sig} = {true_expr};'.format(sig=out_sig.name,
                                                      true_expr=' || '.join(map(_label_to_verilog,
                                                                                labels_true)))
        s += assign
    s.newline()

    s += 'initial begin'
    s += '{state} = 0;'.format(state=lts.state_name)
    s += 'end'
    s.newline()

    s += 'always@(posedge i_clk)'
    s += 'begin'

    tau_items = tuple(lts.tau_model.items())
    s += 'if ({expr}) {state} = {next_val};'.format(expr=_label_to_verilog(tau_items[0][0]),
                                                    state=lts.state_name,
                                                    next_val=tau_items[0][1])
    for lbl, val in tau_items[1:]:
        s += 'else if ({expr}) {state} = {next_val};'.format(expr=_label_to_verilog(lbl),
                                                             state=lts.state_name,
                                                             next_val=val)
    s += 'end'
    s += 'endmodule'
    return s.to_str()
