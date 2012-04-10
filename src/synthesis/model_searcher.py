from interfaces.smt_model import SmtModel
from smtEncoder import encodeUct
from synthesis.z3 import z3


def search(uct, bound):
    print "searching smt model..."
    
    model = None 
    solver = z3()
    
    for cbound in range(2,bound):   
        smtstr = encodeUct(uct, cbound) 
        solver.solve(smtstr)
               
        if (solver.getState() == z3.SAT):
            print "  ...model found!"
            model = SmtModel(solver.getModel())
            #print model.getModel()
            break    

    del solver
    return model