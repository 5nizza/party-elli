import os
import tempfile
from unittest import TestCase

from config import LTL3BA_PATH
from ctl2aht_.ctl2aht import ctl2aht, is_state_formula
from helpers import aht2dot
from helpers.spec_helper import A, E, G, F, sig_prop, EGF, AG, EFG, AFEG, X, EF
from interfaces.aht_automaton import DstFormulaPropMgr, SharedAHT
from interfaces.expr import Bool
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
        """ 'Crash' test: no assertions fails """
        rs, r = sig_prop('r')
        cs, c = sig_prop('c')
        gs, g = sig_prop('g')

        formulas = [
            AG(r >> F(g)),
            AG(r >> F(g)) & EGF(~g),
            AG(r >> F(g)) & EFG(g) & AFEG(~g),
            AG(r >> X(g & X(g & EGF(g) & EGF(~g)))),
            AG(r >> F(g | c) & EGF(g) & EF(c) & EF(~c) & EGF(r)),
            AG(EFG(r & g)),
            AG(EFG(r & g)) | AFEG(g),
            AG(~r >> F(~g)) & AG(~r >> F(~g)) & EFG(g) & AFEG(~g),
            A(r),
            A(r) & A(~r),
            g,
            Bool(False),
            Bool(True)
        ]

        i = 0
        for f in formulas:
            i += 1
            print('checking: ', str(f))

            dstFormPropMgr = DstFormulaPropMgr()
            shared_aht = SharedAHT()
            spec = Spec([rs, cs], [gs], f)
            ctl2aht(spec, self.ltl2ba, shared_aht, dstFormPropMgr)

            with tempfile.NamedTemporaryFile(delete=False) as dot_file:
                dot = aht2dot.convert(shared_aht, dstFormPropMgr)
                dot_file.write(dot.encode())
                # with open('/tmp/ttmmpp%i.dot'%i, 'w') as output:
                #     output.write(dot)

            os.remove(dot_file.name)
