import math


class VerilogModule:
    pass


def to_verilog(model):
    state_trans = model.get_model()[0]
    output_trans = model.get_model()[1]
    inputs=""
    for i in state_trans.input:
        i=i.replace(" == 0", "")
        i=i.replace(" == 1", "")
        if i not in inputs:
            inputs+=", " + i

    types=""
    for i in output_trans.type:
        if i not in types:
            types+=", " + i

    states=[]
    for i in state_trans.state:
        if i not in states:
            states.append(i)

    verilog = "module synth(clock " + str(inputs) + types + "); \n \n"

    verilog += "input clock; \n"
    for i in inputs.split(", "):
        if i != "":
            verilog += "input " + i + ";\n"

    for i in types.split(", "):
        if i != "":
            verilog += "output " + i + ";\n"

    verilog += "reg [" + str(int(math.ceil(math.log(len(states), 2)))+1) + ":0] state;\n"

    for i in types.split(", "):
        if i != "":
            verilog += "reg " + i + ";\n"

    verilog += "initial \n \tbegin \n \t\tstate = 1; \n"
    for i in types.split(", "):
        if i != "":
            verilog +=  " \t\t" + i + " = 1;\n"

    verilog += "\t end \n \n always @(posedge clock) \n \t begin \n"

    for i in range(len(state_trans.state)):
        verilog+= "\t\tif ((state == " + str(state_trans.state[i]) + ") && (" + str(state_trans.input[i]) + ")) \n"
        verilog+= "\t\t\t state = " + str(state_trans.new_state[i]) + ";\n"

    for j in states:
        verilog += "\t if (state == " + j + ") \n \t\t begin \n"
        for i in range(len(output_trans.type)):
            if output_trans.state[i]==j:
                verilog += "\t\t\t"+ output_trans.type[i] + " = " + str(output_trans.result[i])+"; \n"


    verilog += "\t end \n endmodule"

    return verilog
