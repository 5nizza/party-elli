from interfaces.smt_model import SmtModel
from smtEncoder import Encoder
from synthesis.z3 import z3


def search(uct, inputs, outputs, bound):
    print "searching smt model..."
    
    model = None 
    solver = z3()
    encoder = Encoder(uct, inputs, outputs)
    for cbound in range(2,bound):   
        smtstr = encoder.encodeUct(cbound) 
        solver.solve(smtstr)
               
        if (solver.getState() == z3.SAT):
            print "  ...model found!"
            model = SmtModel(solver.getModel())
            #print model.getModel()
            break    

    del solver
    return model