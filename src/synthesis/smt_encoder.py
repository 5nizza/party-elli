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

    def _func(self, function, args):
        
        smt_str = '(' + function + ' ' 
        for arg in args:
            smt_str += arg+' '
        if len(args):
            smt_str = smt_str[:-1]         
        smt_str += ')'
        return smt_str      
    
    def _assert(self, formula):
        smt_str = '(assert ' + formula + ')\n'
        return smt_str
    
    def _comment(self, comment):
        smt_str = '; ' + comment + '\n'
        return smt_str
    
    def _declare_fun(self, name, vars, type):
        smt_str = '(declare-fun '
        smt_str += name + ' ('
        
        for var in vars:
            smt_str += var + ' '
        if len(vars):
            smt_str = smt_str[:-1] 
        
        smt_str += ') ' + type + ')\n'
        return smt_str
    
    def _declare_sort(self, name, num_param):
        smt_str = '(declare-sort '
        smt_str += name + ' ' + str(num_param) + ')\n'
        return smt_str
    
    def _implies(self, arg1, arg2):
        smt_str = '(=> ' + arg1 + ' ' + arg2 + ')'
        return smt_str
    
    def _eq(self, arg1, arg2): #is equal to
        smt_str = '(= ' + arg1 + ' ' + arg2 + ')'
        return smt_str   
    
    def _gt(self, arg1, arg2): #is greater than
        smt_str = '(> ' + arg1 + ' ' + arg2 + ')'
        return smt_str
    
    def _ge(self, arg1, arg2): #is greater than or equal to
        smt_str = '(>= ' + arg1 + ' '+ arg2 + ')'
        return smt_str
    
    def _lt(self, arg1, arg2): #is less than
        smt_str = '(< ' + arg1 + ' ' + arg2 + ')'
        return smt_str
    
    def _le(self, arg1, arg2):#is less than or equal to
        smt_str = '(<= ' + arg1 + ' ' + arg2 + ')'
        return smt_str

    def _not(self, argument):
        smt_str = '(not ' + argument + ')'   
        return smt_str
   
    def _and(self, arguments):
        smt_str = '(and '  
        smt_str += self.make_and_or_xor_body(arguments) + ')'    
        return smt_str
    
    def _or(self, arguments):
        smt_str = '(or '  
        smt_str += self.make_and_or_xor_body(arguments) + ')'     
        return smt_str
    
    def _xor(self, arguments):
        smt_str = '(xor '  
        smt_str += self.make_and_or_xor_body(arguments) + ')'     
        return smt_str
    
    def make_and_or_xor_body(self, arguments):
        smt_str=''
        for arg in arguments:
            smt_str += arg + ' '
        if len(arguments):
            smt_str = smt_str[:-1] 
        return smt_str
    
    
    def _forall(self, param_list, expression):
        smt_str = '(forall ('
        for pairs in param_list:             #name-sort pair
            smt_str += '('+ pairs[0] + ' ' + pairs[1] + ')'
        smt_str += ')' + expression + ')'
        return smt_str
    
    
    def _make_state_declarations(self, state_names, sort_name):
        lowername = sort_name.lower()

        smt_str = self._comment("define a new type " + sort_name + ":")
        smt_str += self._declare_sort(sort_name,0)
        smt_str += self._comment("constants of type " + sort_name + ":")

        for name in state_names:
            smt_str += self._declare_fun(lowername + "_" + name, [], sort_name)

        smt_str += self._comment("cardinality constraints:")

        expList = []
        for name in state_names:
            expList.append(self._eq(lowername,lowername + "_" + name))
        expression =  " " + self._or(expList)

        smt_str += self._assert(self._forall([[lowername,sort_name]], expression))
        smt_str += '\n'

        return smt_str
    
    def _make_input_declarations(self):
        
        smt_str = self._comment("define a new type Upsilon for the input letters:")
        smt_str += self._declare_sort("Upsilon", 0)    
        smt_str += self._comment("constants of type Upsilon:") 
        
        for input_value in range (0, self.upsilon.get_num_element()):
            smt_str += self._declare_fun(self.upsilon.get_element_str(input_value),[],"Upsilon")      
        
        smt_str +='\n'
        return smt_str
    
        
    def _make_other_declarations(self):
        
        smt_str = self._comment("Declarations for transition relation, output function and annotation")
        smt_str += self._declare_fun("tau", ["T","Upsilon"], "T")
        
        #declare output functions
        for input in self.inputs:
            smt_str += self._declare_fun("fo_"+input,["T"],"Bool") 
        for output in self.outputs:
            smt_str += self._declare_fun("fo_"+output,["T"],"Bool") 
            
        #declare annotations
        smt_str += self._declare_fun("lambda_B", ["Q","T"], "Bool")
        smt_str += self._declare_fun("lambda_sharp", ["Q","T"], "Int")
        smt_str += '\n'
        
           
        return smt_str
    
    def _make_root_condition(self):
        
        smt_str = self._comment("the root node of the run graph is labelled by a natural number:")
        
        elements = []
        for state in self.uct.initial_states:
            elements.append(self._func("lambda_B", ["q_"+state.name,"t_0"]))
            
        if len(elements)>1:
            smt_str += self._assert(self._and(elements))
        else:
            smt_str += self._assert(elements[0])
        
        return smt_str
    
    def _make_input_preservation(self, num_impl_states):
        smt_str = self._comment("input preserving:")
        elements = []
        for input in self.inputs:
            for input_value in range(0, self.upsilon.get_num_element()):
                for impl_state in range(0, num_impl_states):
                    element = self._func("fo_" + input, [self._func("tau", ["t_" + str(impl_state), self.upsilon.get_element_str(input_value)])])                   
                    
                    if self.upsilon.is_input_set(input_value, input) is False:
                        element = self._not(element)
                    elements.append(element)
        
        smt_str += self._assert(self._and(elements))
    
        return smt_str
    
    
    def _make_trans_condition(self, uct_state, uct_state_next, trans, impl_state):
        smt_str=''
        input_output_list = self.inputs + self.outputs
        labels = trans[1]
        or_args = []
        and_args = []
        for var in input_output_list:  #for all inputs and outputs
            if (var in labels) and (labels[var] is True):
                and_args.append(self._func("fo_" + var, ["t_" + str(impl_state)]))
            elif (var in labels) and (labels[var] is False):
                and_args.append(self._not(self._func("fo_" + var, ["t_" + str(impl_state)])))
            elif var not in labels:
                pass
            else:
                assert False, "Error: Variable in label has wrong value: " + labels[var]
        if len(and_args)>1:
            or_args.append(self._and(and_args))
        elif len(and_args)==1:
            or_args.append(and_args[0])

        if len(or_args)>1:
            smt_str = self._or(or_args)
        elif len(or_args)==1:
            smt_str = or_args[0]
                            
        return smt_str 
    
    def _make_main_assertions(self, num_impl_states):
        smt_str=self._comment("main assertions")
        for uct_state in self.uct.states:
            for trans in uct_state.transitions: #number of next nodes
                uct_state_next = trans[0]
                for input_value in range (0, self.upsilon.get_num_element()):
                    for impl_state in range (0, num_impl_states):
                        smt_str+=self._comment('q=q_' + uct_state.name + " (q',v)=(q_" + uct_state_next.name + "," + self.upsilon.get_element_str(input_value) + "), t=t_" + str(impl_state))
                        
                        implication_left_1 = self._func("lambda_B", ["q_" + uct_state.name, "t_" + str(impl_state)])
                        implication_left_2 = self._make_trans_condition(uct_state, uct_state_next, trans, impl_state)

                        if len(implication_left_2)>0:
                            implication_left = self._and([implication_left_1, implication_left_2])
                        else:
                            implication_left = implication_left_1

                        arg = self._func("tau", ["t_" + str(impl_state), self.upsilon.get_element_str(input_value)])
                        implication_right_1 = self._func("lambda_B", ["q_" + uct_state_next.name, arg])

                        gt_arg_1 = self._func("lambda_sharp", ["q_" + uct_state_next.name, arg])
                        gt_arg_2 = self._func("lambda_sharp", ["q_" + uct_state.name, "t_" + str(impl_state)])

                        if not uct_state_next.is_rejecting: #next state is not a rejecting state
                            implication_right_2 = self._ge(gt_arg_1, gt_arg_2)
                        else:
                            implication_right_2 = self._gt(gt_arg_1, gt_arg_2)    
                        
                        implication_right = self._and([implication_right_1, implication_right_2])
                        
                        smt_str += self._assert(self._implies(implication_left, implication_right))

        return smt_str
    
    
    def _make_set_logic(self, logic):
        return '(set-logic {0})\n'.format(logic)
    
    def _make_headers(self):
        return '(set-option :ematching false)\n(set-option :produce-models true)\n'

    def encode_uct(self, num_impl_states):
        """ outputs: list of strings """
        
        print ("smt file")
        print ("================================")

        smt_str = self._make_headers()

        smt_str += self._make_set_logic('UFLIA')
        smt_str += self._make_state_declarations([uct_state.name for uct_state in self.uct.states], "Q")
        smt_str += self._make_state_declarations([str(impl_state) for impl_state in range(0, num_impl_states)], "T")
        smt_str += self._make_input_declarations()
        smt_str += self._make_other_declarations()
        
        smt_str += self._make_main_assertions(num_impl_states)

        smt_str += self._make_root_condition()
        smt_str += self._make_input_preservation(num_impl_states)
        smt_str += "\n"
        smt_str += self.CHECK_SAT
        smt_str += self.GET_MODEL
        smt_str += self.EXIT_CALL

#        print smt_str
        print ("================================")    
                        
        return smt_str


class Upsilon:   
    m = []
    inputs = None
    
    def __init__(self, inputs):
        self.inputs = inputs
        self.m = list(itertools.product([False, True], repeat=len(inputs)))
        
    def get_element_str (self, num):
        
        line = 'i'
        
        lineLen = len(self.inputs)
        
        for i in range (0,lineLen):
            value = self.m[num][i]
            name = self.inputs[i]
            if value is True:
                line+= "_" + name    
            else:
                line+= "_not_" + name
        
        return line 
        
    def get_num_element(self):
        return len(self.m)
        
    def is_input_set(self, num, input):       
        pos = self.inputs.index(input)      
        return self.m[num][pos]