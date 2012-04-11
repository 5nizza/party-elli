CHECK_SAT = "(check-sat)\n"
GET_MODEL = "(get-model)\n"

def Assert(formula):
    str = '(assert '+formula+')\n'
    return str

def Comment(comment):
    str = '; '+comment+'\n'
    return str

def Declare_func(name, vars, type):
    str = '(declare-fun '
    str += name+' ('
    
    for var in vars:
        str+=var+' '
    if len(vars):
        str = str[:-1] 
    
    str += ') '+type+')\n'
    return str

def Declare_sort(name, numParam):
    str = '(declare-sort '
    str += name+' '+numParam+')\n'
    return str

def Implies(arg1, arg2):
    str = '(=> ' + arg1 +' '+arg2+')'
    return str

def Eq(arg1, arg2): #is equal to
    str = '(= ' + arg1 +' '+arg2+')'
    return str   

def Gt(arg1, arg2): #is greater than
    str = '(> ' + arg1 +' '+arg2+')'
    return str

def Ge(arg1, arg2): #is greater than or equal to
    str = '(>= ' + arg1 +' '+arg2+')'
    return str

def Lt(arg1, arg2): #is less than
    str = '(< ' + arg1 +' '+arg2+')'
    return str

def Le(arg1, arg2):#is less than or equal to
    str = '(<= ' + arg1 +' '+arg2+')'
    return str

def And(arguments):
    str = '(and '  
    str+=makeAndOrXorBody(arguments)     
    return str

def Or(arguments):
    str = '(or '  
    str+=makeAndOrXorBody(arguments)     
    return str

def Xor(arguments):
    str = '(xor '  
    str+=makeAndOrXorBody(arguments)     
    return str

def makeAndOrXorBody(arguments):
    str=''
    for arg in arguments:
        str += arg + ' '
    if len(arguments):
        str = str[:-1] 
    str += ')'
    return str


def Forall(paramList, expression):
    str = '(forall ('
    for pairs in paramList:             #name-sort pair
        str += '('+ pairs[0] +' ' + pairs[1]+')'
    str += ')'+ expression + ')'
    return str


def makeDeclarations(numStates, name):
    
    lowername = name.lower()
    
    decl=''
    decl+=Comment("define a new type "+name+":")
    decl+=Declare_sort(name,"0")
    decl+=Comment("constants of type "+name+":") 
    
    for i in range(1,numStates+1): 
        decl+=Declare_func(lowername+"_"+ str(i), [], name)
    
    decl+=Comment("cardinality constraints:")
    
    expList = []
    for i in range(1,numStates+1): 
        expList.append(Eq(lowername,lowername+"_"+ str(i)))   
    expression =  " " + Or(expList)
        
    decl+= Assert(Forall([[lowername,name]],expression))
    
    
    return decl
    

def encodeUct(uct, inputs, outputs, bound):
    """ outputs: list of strings """
    
    print ("smt file")
    print ("================================")
    
    smtStr =  makeDeclarations(2, "Q") #uct.states().size
    smtStr += "\n"
    smtStr +=  makeDeclarations(bound, "T")
     
    smtStr += "\n"
    smtStr += CHECK_SAT
    smtStr += GET_MODEL
    

    print (smtStr)
    print ("================================")    
    return smtStr

"""    head = ''

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

