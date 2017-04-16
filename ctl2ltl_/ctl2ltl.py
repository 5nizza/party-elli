from ctl2aht_.ctl2aht import replace_top_AEs
from helpers.nnf_normalizer import NNFNormalizer
from interfaces.expr import Expr
from interfaces.spec import Spec


def convert(spec:Spec) -> Expr:
    """
    :return: LTL formula
    """
    nnf_formula = NNFNormalizer().dispatch(spec.formula)
    prop_form_pairs, new_form = replace_top_AEs(spec.formula)
