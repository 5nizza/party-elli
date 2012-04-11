#All Just dummy Code for testing, forget everything
class UCT:
        
    def __init__(self):
        self._initial_states = [0]
        self._rejecting_states = [1]
        self._states = [UCTNode(0), UCTNode(1)] 
    
    def states(self):
        return self._states       

    def initial_states(self):
        return self._initial_states
   
    def rejecting_states(self):
        return self._rejecting_states
 
    def num_states(self):
        return len(self._states)    

    

class UCTNode:
    def __init__(self, tmp):
        if (tmp==0):
            label0=  [[True ,True],[False,True],[False ,True],[False,False]]
            label1 = [[True ,False],[False,True]]
            self._transition=[[0, label0],[1, label1]]
        if (tmp==1):
            label0=  [[True ,True],[False,True],[False ,True],[False,False]]           
            self._transition=[[1, label0]]

    def transitions(self):
        """ returns list of pairs (label, destination UCTNode)"""
        return self._transition
