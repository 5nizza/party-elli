class Encoder:

    CHECK_SAT = "(check-sat)\n"
    GET_MODEL = "(get-model)\n"
    uct=None
    inputs=None
    outputs=None
    
    
    def __init__ (self, uct, inputs, outputs):
        self.uct=uct
        self.inputs=inputs
        self.outputs=outputs
        
    
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
    
    def And(self, arguments):
        smtStr = '(and '  
        smtStr+=self.makeAndOrXorBody(arguments)     
        return smtStr
    
    def Or(self, arguments):
        smtStr = '(or '  
        smtStr+=self.makeAndOrXorBody(arguments)     
        return smtStr
    
    def Xor(self, arguments):
        smtStr = '(xor '  
        smtStr+=self.makeAndOrXorBody(arguments)     
        return smtStr
    
    def makeAndOrXorBody(self, arguments):
        smtStr=''
        for arg in arguments:
            smtStr += arg + ' '
        if len(arguments):
            smtStr = smtStr[:-1] 
        smtStr += ')'
        return smtStr
    
    
    def Forall(self, paramList, expression):
        smtStr = '(forall ('
        for pairs in paramList:             #name-sort pair
            smtStr += '('+ pairs[0] +' ' + pairs[1]+')'
        smtStr += ')'+ expression + ')'
        return smtStr
    
    
    def makeStateDeclarations(self, numStates, name):
        
        lowername = name.lower()
        
        smtStr=self.Comment("define a new type "+name+":")
        smtStr+=self.Declare_sort(name,0)
        smtStr+=self.Comment("constants of type "+name+":") 
        
        for i in range(1,numStates+1): 
            smtStr+=self.Declare_fun(lowername+"_"+ str(i), [], name)
        
        smtStr+=self.Comment("cardinality constraints:")
        
        expList = []
        for i in range(1,numStates+1): 
            expList.append(self.Eq(lowername,lowername+"_"+ str(i)))   
        expression =  " " + self.Or(expList)
            
        smtStr+= self.Assert(self.Forall([[lowername,name]],expression))  
        smtStr+='\n'
        
        return smtStr
    
    def makeInputDeclarations(self):
        
        smtStr = self.Comment("define a new type Upsilon for the input letters:")
        smtStr += self.Declare_sort("Upsilon", 0)    
        smtStr += self.Comment("constants of type Upsilon:") 
        
        for i in self.inputs:
            smtStr += self.Declare_fun("i_"+i,[],"Upsilon")
            smtStr += self.Declare_fun("i_not_"+i,[],"Upsilon")        
        
        smtStr +='\n'
        return smtStr
    
        
    def makeOtherDeclarations(self):
        
        smtStr = self.Comment("Declarations for transition relation, output function and annotation")
        smtStr += self.Declare_fun("tau", ["T","Upsilon"], "T")
        
        #declare output functions
        for i in self.inputs:
            smtStr += self.Declare_fun("fo_"+i,["T"],"Bool") 
        for i in self.outputs:
            smtStr += self.Declare_fun("fo_"+i,["T"],"Bool") 
            
        #declare annotations
        smtStr += self.Declare_fun("lambda_B", ["Q","T"], "Bool")
        smtStr += self.Declare_fun("lambda_sharp", ["Q","T"], "Int")
        
           
        return smtStr
    
    def encodeUct(self, bound):
        """ outputs: list of strings """
        
        print ("smt file")
        print ("================================")
        
        smtStr =  self.makeStateDeclarations(2, "Q") #self.uct.states().size
        smtStr += self.makeStateDeclarations(bound, "T")
        smtStr += self.makeInputDeclarations()
        smtStr += self.makeOtherDeclarations()
        
         
        smtStr += "\n"
        smtStr += self.CHECK_SAT
        smtStr += self.GET_MODEL
        
    
        print (smtStr)
        print ("================================")    
        return smtStr
    
    """  
    
        declarations = []
        for o in outputs:
            declarations.append(declare_output(o))
    
        bound_asserts = ['; bounding', bound_assert(bound)]
    
        initial_asserts = ['; initial states']
        for s in uct.initial_state:
            initial.append(initial_assert(s))
    
        main_asserts = ['; main asserts']
        for s in uct.states:
            for label, dst in s.transitions:
                if is_rejecting(dst):
                    a = main_assert(s, inputs, label, dst, True)
                else:
                    a = main_assert(s, inputs, label, dst, False)
                main_asserts.append(a)
    
        smt = '\n'.join([head] + declarations + bound_asserts + initial_asserts + main_asserts + [tail])
        return smt
    
        smtStr = '(declare-const a Int)\n(declare-fun f (Int Bool) Int)\n(assert (> a 10))\n(assert (< (f a true) 100))\n(check-sat)\n(get-model)'"""
        
    #Just for testing      
        #smtStr = '(declare-sort Q 0)\n (declare-fun q_1 () Q)\n (declare-fun q_2 () Q)\n (assert (forall ((q Q)) (or (= q q_1) (= q q_2))))\n (declare-sort T 0)\n (declare-fun t_1 () T)\n (declare-fun t_2 () T)\n (assert (forall ((t T)) (or (= t t_1) (= t t_2))))\n (declare-sort Upsilon 0)\n (declare-fun i_R () Upsilon)\n (declare-fun i_not_R () Upsilon)\n (declare-fun tau (T Upsilon) T)\n (declare-fun fo_R (T) Bool)\n (declare-fun fo_G (T) Bool)\n (declare-fun lambda_B (Q T) Bool)\n (declare-fun lambda_sharp (Q T) Int)\n (assert (=> (lambda_B q_1 t_1) (and (lambda_B q_1 (tau t_1 i_R)) (>= (lambda_sharp q_1 (tau t_1 i_R)) (lambda_sharp q_1 t_1) ) )))\n (assert (=> (lambda_B q_1 t_2) (and (lambda_B q_1 (tau t_2 i_R)) (>= (lambda_sharp q_1 (tau t_2 i_R)) (lambda_sharp q_1 t_2) ) )))\n (assert (=> (lambda_B q_1 t_1) (and (lambda_B q_1 (tau t_1 i_not_R)) (>= (lambda_sharp q_1 (tau t_1 i_not_R)) (lambda_sharp q_1 t_1) ) )))\n (assert (=> (lambda_B q_1 t_2) (and (lambda_B q_1 (tau t_2 i_not_R)) (>= (lambda_sharp q_1 (tau t_2 i_not_R)) (lambda_sharp q_1 t_2) ) )))\n (assert (=> (and (lambda_B q_1 t_1) (or (and (fo_R t_1) (not (fo_G t_1) )) (and (not (fo_R t_1) ) (fo_G t_1)) )) (and (lambda_B q_2 (tau t_1 i_R)) (> (lambda_sharp q_2 (tau t_1 i_R)) (lambda_sharp q_1 t_1) ) )))\n (assert (=> (and (lambda_B q_1 t_2) (or (and (fo_R t_2) (not (fo_G t_2) )) (and (not (fo_R t_2) ) (fo_G t_2)) )) (and (lambda_B q_2 (tau t_2 i_R)) (> (lambda_sharp q_2 (tau t_2 i_R)) (lambda_sharp q_1 t_2) ) )))\n (assert (=> (and (lambda_B q_1 t_1) (or (and (fo_R t_1) (not (fo_G t_1) )) (and (not (fo_R t_1) ) (fo_G t_1)) )) (and (lambda_B q_2 (tau t_1 i_not_R)) (> (lambda_sharp q_2 (tau t_1 i_not_R)) (lambda_sharp q_1 t_1) ) )))\n (assert (=> (and (lambda_B q_1 t_2) (or (and (fo_R t_2) (not (fo_G t_2) )) (and (not (fo_R t_2) ) (fo_G t_2)) )) (and (lambda_B q_2 (tau t_2 i_not_R)) (> (lambda_sharp q_2 (tau t_2 i_not_R)) (lambda_sharp q_1 t_2) ) )))\n (assert (=> (lambda_B q_2 t_1) (and (lambda_B q_2 (tau t_1 i_R)) (> (lambda_sharp q_2 (tau t_1 i_R)) (lambda_sharp q_2 t_1) ) )))\n (assert (=> (lambda_B q_2 t_2) (and (lambda_B q_2 (tau t_2 i_R)) (> (lambda_sharp q_2 (tau t_2 i_R)) (lambda_sharp q_2 t_2) ) )))\n (assert (=> (lambda_B q_2 t_1) (and (lambda_B q_2 (tau t_1 i_not_R)) (> (lambda_sharp q_2 (tau t_1 i_not_R)) (lambda_sharp q_2 t_1) ) )))\n (assert (=> (lambda_B q_2 t_2) (and (lambda_B q_2 (tau t_2 i_not_R)) (> (lambda_sharp q_2 (tau t_2 i_not_R)) (lambda_sharp q_2 t_2) ) )))\n (assert (lambda_B q_1 t_1))\n (assert (and (fo_R (tau t_1 i_R)) (not (fo_R (tau t_1 i_not_R))) (fo_R (tau t_2 i_R)) (not (fo_R (tau t_2 i_not_R)))))\n (check-sat)\n (get-model)'

