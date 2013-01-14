from helpers.labels_map import LabelsMap
from interfaces.automata import Label


class LTS:
    def __init__(self, init_states, model_by_name:dict, tau_model:LabelsMap):
        self._output_models = model_by_name
        self._tau_model = tau_model
        self._init_states = set(init_states)

    @property
    def init_states(self):
        return self._init_states

    @property
    def states(self):
        states = set(k['state'] for k in self._tau_model) #TODO: hack!

        return states

    @property
    def tau_model(self):
        return self._tau_model

    @property
    def model_by_name(self):
        return self._output_models

    def get_outputs(self, label:Label):
        return dict((outvar, transitions[label]) for outvar, transitions in self._output_models.items())
