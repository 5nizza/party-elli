class StateTransition:
    state = None
    input= None
    newState = None


    def __init__(self,state, input, newState):
        self.state=[]
        self.input=[]
        self.newState=[]
        for i in range(len(state)):
            self.state.append(state[i])
            self.input.append(input[i])
            self.newState.append(newState[i])


    def getModel(self):
        return self.model


class OutputTransition:
    state = None
    type= None
    result = None


    def __init__(self,type, state, result):
        self.state=[]
        self.type=[]
        self.result=[]
        for i in range(len(state)):
            self.state.append(state[i])
            self.type.append(type[i])
            self.result.append(result[i])


    def getModel(self):
        return self.model