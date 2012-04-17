from interfaces.smt_model import SmtModel
from synthesis.smtEncoder import Encoder
from synthesis.z3 import Z3

#TODO: should it depend on solver and not on z3solver?
def search(uct, inputs, outputs, bound, z3solver):
    print("searching the model of size <=", bound)
    
    model = None 
    encoder = Encoder(uct, inputs, outputs)
    for cbound in range(1, bound+1):
        print('-- model_size = {0}'.format(cbound))

        smtstr = encoder.encodeUct(cbound)
        z3solver.solve(smtstr)

        if z3solver.getState() == Z3.UNSAT:
            print('unsat..')
        if z3solver.getState() == Z3.SAT:
            model = SmtModel(z3solver.getModel())
            print('sat! The model: \n', model.getModel())
            break

    return model
