from LTL_to_atm.ast_to_ltl3ba import ConverterToLtl2BaFormatVisitor
from interfaces.spec import Spec


def convert(spec:Spec, title:(str or None)=None) -> str:
    tlsf_formula = ConverterToLtl2BaFormatVisitor().dispatch(spec.formula)
    template = """
    INFO {{
      TITLE: "{title}"
      DESCRIPTION: "Generated from CTL* by Party"
      SEMANTICS: Moore
      TARGET: Moore
    }}
    MAIN {{
      INPUTS {{ {inputs} }}
      OUTPUTS {{ {outputs} }}
      GUARANTEES {{
        {formula}
      }}
    }}
    """

    tlsf_str = template.format(
        title=title or 'title',
        inputs='; '.join(map(lambda s: s.name, spec.inputs)) + ';',
        outputs='; '.join(map(lambda s: s.name, spec.outputs)) + ';',
        formula=tlsf_formula + ';'
    )

    return tlsf_str
