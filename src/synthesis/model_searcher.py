from interfaces.smt_model import SmtModel
from synthesis.smt_encoder import Encoder
from synthesis.z3 import Z3

def search(uct, inputs, outputs, bound, z3solver):
    
    assert bound > 0

    print("searching the model of size <=", bound)

    model = None
    encoder = Encoder(uct, inputs, outputs)
    for current_bound in range(1, bound+1):
        
        print('-- model_size = {0}'.format(current_bound))
        smt_str = encoder.encode_uct(current_bound)
        z3solver.solve(smt_str)

        if z3solver.get_state() == Z3.UNSAT:
            print('unsat..')
   
        if z3solver.get_state() == Z3.SAT:
            model = SmtModel(z3solver.get_model())
            break

    return model
