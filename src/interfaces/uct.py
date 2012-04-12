#All Just dummy Code for testing, forget everything
class UCT:
        
    def __init__(self):
        self._initial_states = [0]
        self._rejecting_states = [1]
        self._states = [UCTNode(0), UCTNode(1)] 
    
    @property
    def states(self):
        return self._states       
    
    @property
    def initial_states(self):
        return self._initial_states
   
    @property
    def rejecting_states(self):
        return self._rejecting_states
 
    @property
    def num_states(self):
        return len(self._states)    
    

class UCTNode:
    def __init__(self, tmp):

        if (tmp==0):
            
            label0={'R':'*','G':'*'}
            label1={'R':False,'G':True}
            label2={'R':True,'G':False}
            self._transition=[[0, [label0]],[1, [label1, label2]]]
            
        if (tmp==1):
            label0={'R':'*','G':'*'}         
            self._transition=[[1, [label0]]]

    @property
    def transitions(self):
        """ returns list of pairs (label, destination UCTNode)"""
        return self._transition
