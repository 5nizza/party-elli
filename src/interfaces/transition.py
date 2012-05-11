class StateTransition:
    def __init__(self, state, input, new_state):
        self.state = []
        self.input = []
        self.new_state = []
        for i in range(len(state)):
            self.state.append(state[i])
            self.input.append(input[i])
            self.new_state.append(new_state[i])


class OutputTransition:
    def __init__(self, type, state, result):
        self.state = []
        self.type = []
        self.result = []
        for i in range(len(state)):
            self.state.append(state[i])
            self.type.append(type[i])
            self.result.append(result[i])

