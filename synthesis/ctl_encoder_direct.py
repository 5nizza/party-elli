from typing import Iterable, Dict, List, Container

from interfaces.LTS import LTS
from interfaces.aht_automaton import DstFormulaPropMgr
from interfaces.expr import Signal
from interfaces.func_description import FuncDesc
from synthesis.encoder_helper import parse_model, encode_model_bound, encode_get_model_values
from synthesis.encoder_interface import EncoderInterface
from synthesis.smt_format import real_type, bool_type
from synthesis.smt_namings import ARG_A_STATE, TYPE_A_STATE, ARG_MODEL_STATE, TYPE_MODEL_STATE, FUNC_REACH, FUNC_R


class CTLEncoderDirect(EncoderInterface):
    def __init__(self,
                 dstPropMgr:DstFormulaPropMgr,
                 tau_desc:FuncDesc,
                 inputs:Iterable[Signal],
                 descr_by_output:Dict[Signal,FuncDesc],
                 model_init_state:int=0):
        self.dstPropMgr = dstPropMgr            # type: DstFormulaPropMgr

        self.inputs = inputs                    # type: Iterable[Signal]
        self.descr_by_output = descr_by_output  # type: Dict[Signal,FuncDesc]
        self.tau_desc = tau_desc                # type: FuncDesc

        reach_args = {ARG_A_STATE: TYPE_A_STATE,
                      ARG_MODEL_STATE: TYPE_MODEL_STATE}

        r_args = reach_args

        self.reach_func_desc = FuncDesc(FUNC_REACH, reach_args, bool_type())
        self.rank_func_desc = FuncDesc(FUNC_R, r_args, real_type())

        self.model_init_state = model_init_state  # type: int
        self.last_allowed_states = None           # type: List[int]

    def encode_headers(self, max_model_states) -> List[str]:
        pass

    def encode_initialization(self) -> List[str]:
        pass

    def encode_run_graph(self, new_states) -> List[str]:
        pass

    def parse_model(self, smt_get_value_lines:List[str]) -> LTS:
        return parse_model(smt_get_value_lines,
                           self.tau_desc,
                           self.descr_by_output, self.inputs,
                           self.model_init_state)

    def encode_model_bound(self, cur_all_states:Iterable[int]) -> List[str]:
        self.last_allowed_states = cur_all_states
        return encode_model_bound(cur_all_states, self.tau_desc)

    def encode_get_model_values(self) -> List[str]:
        return encode_get_model_values(self.tau_desc, self.descr_by_output,
                                       self.last_allowed_states)
