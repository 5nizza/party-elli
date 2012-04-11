import itertools

class Encoder:

    CHECK_SAT = "(check-sat)\n"
    GET_MODEL = "(get-model)\n"
    EXIT_CALL = "(exit)\n"
    
    def __init__ (self, uct, inputs, outputs):
        self.uct=uct        
        self.inputs=inputs
        self.outputs=outputs
        self.upsilon = Upsilon(self.inputs)

    def Func(self, function, args):
        
        smtStr='('+function+' '
        for arg in args:
            smtStr += arg+' '
        if len(args):
            smtStr = smtStr[:-1]         
        smtStr += ')'
        return smtStr      
    
    def Assert(self, formula):
        smtStr = '(assert '+formula+')\n'
        return smtStr
    
    def Comment(self, comment):
        smtStr = '; '+comment+'\n'
        return smtStr
    
    def Declare_fun(self, name, vars, type):
        smtStr = '(declare-fun '
        smtStr += name+' ('
        
        for var in vars:
            smtStr+=var+' '
        if len(vars):
            smtStr = smtStr[:-1] 
        
        smtStr += ') '+type+')\n'
        return smtStr
    
    def Declare_sort(self, name, numParam):
        smtStr = '(declare-sort '
        smtStr += name+' '+str(numParam)+')\n'
        return smtStr
    
    def Implies(self, arg1, arg2):
        smtStr = '(=> ' + arg1 +' '+arg2+')'
        return smtStr
    
    def Eq(self, arg1, arg2): #is equal to
        smtStr = '(= ' + arg1 +' '+arg2+')'
        return smtStr   
    
    def Gt(self, arg1, arg2): #is greater than
        smtStr = '(> ' + arg1 +' '+arg2+')'
        return smtStr
    
    def Ge(self, arg1, arg2): #is greater than or equal to
        smtStr = '(>= ' + arg1 +' '+arg2+')'
        return smtStr
    
    def Lt(self, arg1, arg2): #is less than
        smtStr = '(< ' + arg1 +' '+arg2+')'
        return smtStr
    
    def Le(self, arg1, arg2):#is less than or equal to
        smtStr = '(<= ' + arg1 +' '+arg2+')'
        return smtStr

    def Not(self, argument):
        smtStr = '(not '+argument+')'   
        return smtStr
   
    def And(self, arguments):
        smtStr = '(and '  
        smtStr+=self.makeAndOrXorBody(arguments)+')'    
        return smtStr
    
    def Or(self, arguments):
        smtStr = '(or '  
        smtStr+=self.makeAndOrXorBody(arguments)+')'     
        return smtStr
    
    def Xor(self, arguments):
        smtStr = '(xor '  
        smtStr+=self.makeAndOrXorBody(arguments)+')'     
        return smtStr
    
    def makeAndOrXorBody(self, arguments):
        smtStr=''
        for arg in arguments:
            smtStr += arg + ' '
        if len(arguments):
            smtStr = smtStr[:-1] 
        return smtStr
    
    
    def Forall(self, paramList, expression):
        smtStr = '(forall ('
        for pairs in paramList:             #name-sort pair
            smtStr += '('+ pairs[0] +' ' + pairs[1]+')'
        smtStr += ')'+ expression + ')'
        return smtStr
    
    
    def makeStateDeclarations(self, state_names, sort_name):
        lowername = sort_name.lower()

        smtStr=self.Comment("define a new type "+sort_name+":")
        smtStr+=self.Declare_sort(sort_name,0)
        smtStr+=self.Comment("constants of type "+sort_name+":")

        for n in state_names:
            smtStr+=self.Declare_fun(lowername+"_"+ n, [], sort_name)

        smtStr+=self.Comment("cardinality constraints:")

        expList = []
        for n in state_names:
            expList.append(self.Eq(lowername,lowername+"_"+ n))
        expression =  " " + self.Or(expList)

        smtStr+= self.Assert(self.Forall([[lowername,sort_name]],expression))
        smtStr+='\n'

        return smtStr
    
    def makeInputDeclarations(self):
        
        smtStr = self.Comment("define a new type Upsilon for the input letters:")
        smtStr += self.Declare_sort("Upsilon", 0)    
        smtStr += self.Comment("constants of type Upsilon:") 
        
        for i in range (0, self.upsilon.getNumElement()):
            smtStr += self.Declare_fun(self.upsilon.getElementStr(i),[],"Upsilon")      
        
        smtStr +='\n'
        return smtStr
    
        
    def makeOtherDeclarations(self):
        
        smtStr = self.Comment("Declarations for transition relation, output function and annotation")
        smtStr += self.Declare_fun("tau", ["T","Upsilon"], "T")
        
        #declare output functions
        for input in self.inputs:
            smtStr += self.Declare_fun("fo_"+input,["T"],"Bool") 
        for output in self.outputs:
            smtStr += self.Declare_fun("fo_"+output,["T"],"Bool") 
            
        #declare annotations
        smtStr += self.Declare_fun("lambda_B", ["Q","T"], "Bool")
        smtStr += self.Declare_fun("lambda_sharp", ["Q","T"], "Int")
        smtStr += '\n'
        
           
        return smtStr
    
    def makeRootCondition(self):
        
        smtStr = self.Comment("the root node of the run graph is labelled by a natural number:")
        
        elements = []
        for state in self.uct.initial_states:
            elements.append(self.Func("lambda_B", ["q_"+state.name,"t_0"]))
            
        if len(elements)>1:
            smtStr += self.Assert(self.And(elements))
        else:
            smtStr += self.Assert(elements[0])
        
        return smtStr
    
    def makeInputPreservation(self, numImplStates):
        smtStr = self.Comment("input preserving:")
        elements = []
        for input in self.inputs:
            for v in range(0, self.upsilon.getNumElement()):
                for t in range(0, numImplStates):
                    tmpStr = self.Func("fo_"+input, [self.Func("tau", ["t_"+str(t), self.upsilon.getElementStr(v)])])                   
                    
                    if self.upsilon.isInputSet(v, input) is False:
                        tmpStr = self.Not(tmpStr)
                    elements.append(tmpStr)
        
        smtStr+=self.Assert(self.And(elements))
    
        return smtStr
    
    
    def makeTransCondition(self, q, qn, t):
        smtStr=''
        varList = self.inputs + self.outputs
        state = q
        transition = state.transitions
        for trans in transition:
            if qn==trans[0]:
                labels = trans[1]               
                orArgs = []
                andArgs = []
                for var in varList:  #for all inputs and outputs
                    if var in labels and labels[var] is True:
                        andArgs.append(self.Func("fo_"+var, ["t_"+str(t)]))
                    elif var in labels and labels[var] is False:
                        andArgs.append(self.Not(self.Func("fo_"+var, ["t_"+str(t)])))
                    elif var not in labels:
                        pass
                    else:
                        assert False, "Error!!!!!! Variable in label has wrong value: " + labels[var]
                if len(andArgs)>1:
                    orArgs.append(self.And(andArgs))
                elif len(andArgs)==1:
                    orArgs.append(andArgs[0])

                if len(orArgs)>1:
                    smtStr = self.Or(orArgs)
                elif len(orArgs)==1:
                    smtStr = orArgs[0]
                            
        return smtStr 
    
    def makeMainAssertions(self, numImplStates):
        smtStr=self.Comment("main assertions")
        for q in self.uct.states:
            for trans in q.transitions: #number of next nodes
                qn = trans[0]
                for v in range (0, self.upsilon.getNumElement()):
                    for t in range (0, numImplStates):
                        smtStr+=self.Comment('q=q_'+q.name+" (q',v)=(q_"+qn.name+","+self.upsilon.getElementStr(v)+"), t=t_"+str(t))
                        
                        implL1 = self.Func("lambda_B", ["q_"+q.name, "t_"+str(t)])
                        implL2 = self.makeTransCondition(q, qn, t)
                        if len(implL2)>0:
                            implL = self.And([implL1, implL2])
                        else:
                            implL = implL1

                        arg = self.Func("tau", ["t_"+str(t), self.upsilon.getElementStr(v)])
                        implR1 = self.Func("lambda_B", ["q_"+qn.name, arg])

                        gt1 = self.Func("lambda_sharp", ["q_"+qn.name, arg])
                        gt2 = self.Func("lambda_sharp", ["q_"+q.name, "t_"+str(t)])


                        if not qn.is_rejecting: #next state is not a rejecting state
                            implR2 = self.Ge(gt1, gt2)
                        else:
                            implR2 = self.Gt(gt1, gt2)    
                        
                        implR = self.And([implR1, implR2])
                        
                        smtStr += self.Assert(self.Implies(implL, implR))

        return smtStr
    
    def encodeUct(self, numImplStates):
        """ outputs: list of strings """
        
        print ("smt file")
        print ("================================")

        smtStr = self.makeHeaders()

        smtStr += self.makeSetLogic('UFLIA')
        smtStr += self.makeStateDeclarations([x.name for x in self.uct.states], "Q")
        smtStr += self.makeStateDeclarations([str(x) for x in range(0, numImplStates)], "T")
        smtStr += self.makeInputDeclarations()
        smtStr += self.makeOtherDeclarations()
        
        smtStr += self.makeMainAssertions(numImplStates)

        smtStr += self.makeRootCondition()
        smtStr += self.makeInputPreservation(numImplStates)
        smtStr += "\n"
        smtStr += self.CHECK_SAT
        smtStr += self.GET_MODEL
        smtStr += self.EXIT_CALL
          
        print (smtStr)
        print ("================================")    
                        
        return smtStr

    def makeSetLogic(self, logic):
        return '(set-logic {0})\n'.format(logic)
    def makeHeaders(self):
        return '(set-option :ematching false)\n(set-option :produce-models true)\n'

class Upsilon:   
    m = []
    inputs = None
    
    def __init__(self, inputs):
        self.inputs = inputs
        self.m = list(itertools.product([False, True], repeat=len(inputs)))
        
    def getElementStr (self, num):
        
        line = 'i'
        
        lineLen = len(self.inputs)
        
        for i in range (0,lineLen):
            value = self.m[num][i]
            name = self.inputs[i]
            if value is True:
                line+= "_"+name    
            else:
                line+= "_not_"+name
        
        return line 
        
    def getNumElement(self):
        return len(self.m)
        
    def isInputSet(self, num, input):       
        pos = self.inputs.index(input)      
        return self.m[num][pos]