from interfaces.automata import Label


class LTS:
    def __init__(self, init_states, output_models:dict, tau_model:dict):
        self._output_models = output_models
        self._tau_model = tau_model
        self._init_states = set(init_states)

    @property
    def init_states(self):
        return self._init_states

    @property
    def states(self):
        states = set(k['state'] for k in self._tau_model.keys()) #TODO: hack!

        return states

    @property
    def tau_model(self):
        return dict(self._tau_model)

    def get_outputs(self, label:Label):
        return dict((outvar, transitions[label]) for outvar, transitions in self._output_models.items())
