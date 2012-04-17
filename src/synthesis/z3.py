from helpers.shell import execute_shell


class Z3:
    SAT = 0
    UNSAT = 1
    UNKNOWN = 2
    UNDEFINIED = 3


    def __init__(self, path, flag='-'):
        self._cmd = path + ' {0}smt2 {0}in'.format(flag)
        self._current_state = self.UNDEFINIED
        self._modelStr = None

    def getState(self):
        return self._current_state

    def getModel(self): #TODO: better to return an instance of SmtModel class?
        return self._modelStr
    
    def solve(self, smtstr):
        rc, output, err = execute_shell(self._cmd, smtstr)
        if err:
            print("\nWARNING(Z3 err is not empty)\nZ3: returned:{0}\noutput: '{1}'\nerror:'{2}'\n".format(rc, output, err))

        #parse results
        self._current_state = Z3.UNKNOWN
        output_lines = [x.strip() for x in output.split('\n')]

        if 'unsat' in output_lines:
            self._current_state= Z3.UNSAT
        elif 'sat' in output_lines:
            self._current_state= Z3.SAT

            #parse model
            parse= False
            self._modelStr = ''
            for line in output_lines:
                if line == ')':
                    parse = False         
                if parse is True:
                    self._modelStr+=line+"\n"
                if line == '(model':
                    parse = True
        else:
            assert False, 'unknown Z3 state: ' + output
