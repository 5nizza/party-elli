from helpers.shell import execute_shell
from interfaces.transition import StateTransition
from interfaces.transition import OutputTransition

class Z3:
    SAT = 0
    UNSAT = 1
    UNKNOWN = 2
    UNDEFINIED = 3
    
    tau = None
    states = None
    fo = None


    def __init__(self, path, flag='-'):
        self._cmd = path + ' {0}smt2 {0}in'.format(flag)
        self._current_state = self.UNDEFINIED
        self._model_str = None

    def get_state(self):
        return self._current_state

    def get_model(self):
        for i in self.states:
            i=i.replace("(","")
            i=i.replace(")","")
            parts=i.split(" ")
            for j in range(len(self.fo)):
                self.fo[j]=self.fo[j].replace(parts[1], parts[0] )
            for j in range(len(self.tau)):
                self.tau[j]=self.tau[j].replace(parts[1], parts[0] )
        state = []
        input = []
        newState = []
        for i in self.tau:
            i=i.replace("(","")
            i=i.replace(")","")
            i=i.replace("tau ","")
            parts=i.split(" ")
            print(parts)
            parts[0]=parts[0].replace("t_","")
            parts[2]=parts[2].replace("t_","")
            state.append(parts[0])
            input.append(parts[1])
            newState.append(parts[2])
        tau = StateTransition(state,input,newState)

        state = []
        result = []
        type = []
        for i in self.fo:
            i=i.replace("(","")
            i=i.replace(")","")
            parts=i.split(" ")
            parts[1]=parts[1].replace("t_","")
            type.append(parts[0])
            state.append(parts[1])
            result.append(parts[2])

        lo = OutputTransition(type, state, result)

        return [tau,lo]

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
            self.states=[]
            self.tau = []
            self.fo=[]
            for line in output_lines:
                if 'tau' in line:
                    self.tau.append(line)
                elif 'fo' in line:
                    self.fo.append(line)
                elif '(' in line:
                    self.states.append(line)
        else:
            assert False, 'unknown Z3 state: ' + output
