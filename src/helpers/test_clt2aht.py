from unittest import TestCase

from config import LTL3BA_PATH
from ctl2aht_.ctl2aht import ctl2aht, is_state_formula
from helpers import aht2dot
from helpers.spec_helper import prop, A, E, G, F, sig_prop
from interfaces.aht_automaton import DstFormulaPropMgr
from interfaces.spec import Spec
from ltl3ba.ltl2automaton import LTL3BA


class TestCtl2Aht(TestCase):
    def setUp(self):
        self.ltl2ba = LTL3BA(LTL3BA_PATH)

    def test_is_state_formula__yes(self):
        rs, r = sig_prop('r')
        gs, g = sig_prop('g')
        state_formulas = [
            A(r >> F(g)),
            A(G(r >> F(g))) & E(G(F(~g))),
        ]
        for s in state_formulas:
            self.assertTrue(is_state_formula(s, [rs]), msg=str(s))

    def test_is_state_formula__no(self):
        rs, r = sig_prop('r')
        gs, g = sig_prop('g')
        non_state_formulas = [
            F(g),
            r >> F(g),
            ]
        for s in non_state_formulas:
            self.assertFalse(is_state_formula(s, [rs]), msg=str(s))

    def test_ctl2aht(self):
        rs, r = sig_prop('r')
        gs, g = sig_prop('g')

        spec = Spec([rs], [gs], A(G(r >> F(g))) & E(G(F(~g))))
        dstFormPropMgr = DstFormulaPropMgr()
        aht = ctl2aht(spec, self.ltl2ba, dstFormPropMgr)

        print(aht2dot.convert(aht, dstFormPropMgr))
