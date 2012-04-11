from helpers.shell import execute_shell


class z3:
    SAT = 0
    UNSAT = 1
    UNKNOWN = 2
    UNDEFINIED = 3
    
    current_state = UNDEFINIED 
    modelStr = None

    def __init__(self, path):
        self._path = path

    def getState(self):
        return self.current_state
    
    def getModel(self):
        return self.modelStr
    
    def solve(self, smtstr):
        #'/in' flag (Windows) causes Z3 to read stdin
        rc, output, err = execute_shell(self._path + ' /smt2 /in', smtstr)
        if err:
            print("\nWARNING(Z3 err is not empty)\nZ3: returned:{0}\noutput: '{1}'\nerror:'{2}'\n".format(rc, output, err))

        #parse results
        self.current_state = z3.UNKNOWN
        output_lines = [x.strip() for x in output.split('\n')]

        if 'unsat' in output_lines:
            self.current_state= z3.UNSAT
        elif 'sat' in output_lines:
            self.current_state= z3.SAT

            #parse model
            parse= False
            self.modelStr = ''
            for line in output_lines:
                if line == ')':
                    parse = False         
                if parse is True:
                    self.modelStr+=line+"\n"     
                if line == '(model':
                    parse = True
        else:
            assert False, 'unknown Z3 state: ' + output
