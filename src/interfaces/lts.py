from interfaces.labels_map import LabelsMap
from helpers.python_ext import to_str
from interfaces.automata import Label


class LTS:
    def __init__(self,
                 init_states,
                 model_by_name:dict,
                 tau_model:LabelsMap,
                 state_name:str,
                 input_signals,
                 output_signals):
        self._output_models = model_by_name
        self._tau_model = tau_model
        self._init_states = set(init_states)

        self._state_name = state_name
        self._output_signals = output_signals
        self._input_signals = input_signals

    @property
    def state_name(self):
        return self._state_name

    @property
    def input_signals(self):
        return self._input_signals

    @property
    def output_signals(self):
        return self._output_signals

    @property
    def init_states(self):
        return self._init_states

    @property
    def states(self):
        # states = set(k[self._state_name] for k in self._tau_model)
        # return the range of tau \cup init_states
        states = set(map(lambda l_v: l_v[1], self._tau_model.items()))
        states.update(self.init_states)

        return states

    @property
    def tau_model(self) -> LabelsMap:
        return self._tau_model

    @property
    def model_by_name(self):
        return self._output_models

    @property
    def output_models(self) -> dict:
        return self._output_models

    def get_outputs(self, label:Label):
        return dict((outvar, transitions[label])
                    for (outvar, transitions) in self._output_models.items())

    def __str__(self):
        return 'LTS:\n' \
               '  inputs: {inputs}\n' \
               '  outputs: {outputs}\n' \
               '  init_states: {init}\n' \
               '  states: {states}\n' \
               '  output_models: {output_models}'.format(init=str(self._init_states),
                                                         states=str(self.states),
                                                         output_models=str(self.model_by_name),
                                                         inputs=to_str(self._input_signals),
                                                         outputs=to_str(self._output_signals))
