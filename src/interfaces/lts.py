class LTS:
    def __init__(self, init_state, state_to_outname_to_value, state_to_input_to_new_state):
        self._state_to_outname_to_value = state_to_outname_to_value
        self._state_to_input_to_new_state = state_to_input_to_new_state
        self._init_state = init_state


    def outputs(self, state):
        return dict(self._state_to_outname_to_value[state])


    def next_states(self, state):
        return dict(self._state_to_input_to_new_state[state])


    @property
    def states(self):
        return list(self._state_to_input_to_new_state.keys())


    @property
    def init_state(self):
        return self._init_state