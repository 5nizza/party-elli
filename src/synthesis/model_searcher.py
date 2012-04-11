from interfaces.smt_model import SmtModel
from synthesis.smtEncoder import Encoder
from synthesis.z3 import z3


def search(uct, inputs, outputs, bound, z3path):
    print("searching the model of size <=", bound)
    
    model = None 
    solver = z3(z3path)
    encoder = Encoder(uct, inputs, outputs)
    for cbound in range(1, bound+1):
        print('-- model_size = {0}'.format(cbound))

        smtstr = encoder.encodeUct(cbound)
        solver.solve(smtstr)

        if solver.getState() == z3.UNSAT:
            print('unsat..')
        if solver.getState() == z3.SAT:
            model = SmtModel(solver.getModel())
            print('sat! The model: \n', model.getModel())
            break

    return model