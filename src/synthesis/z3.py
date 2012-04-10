import os
import tempfile
from subprocess import Popen, PIPE, STDOUT


class z3():
    '''
    classdocs
    '''     
    SAT = 0
    UNSAT = 1
    UNKNOWN = 2
    UNDEFINIED = 3
    
    current_state = UNDEFINIED 
    modelStr = None
        
    def getState(self):
        return self.current_state
    
    def getModel(self):
        return self.modelStr
    
    def solve(self, smtstr):
        filename=None
        
        #write temp input file for z3
        f = tempfile.NamedTemporaryFile(delete=False)
        try:
            f.write(smtstr)  
            filename = f.name       
        finally:
            f.close()

        #call z3
        cmd = 'lib/z3/bin/z3 -smt2 -m '+filename
        p = Popen(cmd, shell=True, stdin=PIPE, stdout=PIPE, stderr=PIPE, close_fds=True)
        exit_code = os.waitpid(p.pid, 0) #wait for process termination, before reading
        output = p.stdout.read()
        #error = p.stderr.read()

        #parse results
        self.current_state = z3.UNKNOWN
        for line in output.strip().split('\n'):
            if line == 'sat':
                self.current_state= z3.SAT
                break
            if line == 'unsat':
                self.current_state= z3.UNSAT
                break
            
        #parse model if present
        if (self.current_state == z3.SAT):
            parse= False
            self.modelStr = ''
            for line in output.strip().split('\n'):
                if line == ')':
                    parse = False         
                if parse == True:
                    self.modelStr+=line+"\n"     
                if line == '(model ':
                    parse = True
    
        #delete temp file
        os.unlink(filename)    