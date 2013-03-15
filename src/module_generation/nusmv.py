from helpers.python_ext import StrAwareList, to_str
from interfaces.automata import Label
from interfaces.lts import LTS

# MODULE main
# IVAR
#   in_r : boolean;
#
# VAR
#   state : { t0, t1 };
#
# DEFINE
#   out_g := (state=t1);
#
# ASSIGN
#   init(state) := t0;
#   next(state) :=
#     case
#       state=t0 & !in_r   : t0;
#       state=t0 & in_r    : t1;
#
#       state=t1 & !in_r   : t0;
#       state=t1 & in_r    : t1;
#     esac;
#
# LTLSPEC G(in_r -> F(out_g))
from interfaces.parser_expr import QuantifiedSignal
from interfaces.spec import SpecProperty, expr_from_property
from module_generation.ast_to_smv_property import AstToSmvProperty


def _clause_to_formula(clause:Label) -> str:
    literals = []
    for (var, value) in clause.items():
        if isinstance(var, QuantifiedSignal):
            lit = ['!', ''][value] + var.name
        else:
            lit = var + '=' + value
        literals.append(lit)

    return '(' + ' & '.join(literals) + ')'


def _get_formula(out_name, out_model):
    clauses = [label for (label, value) in out_model.items()
               if value is True]

    return ' | '.join(map(_clause_to_formula, clauses))


def to_nusmv(lts:LTS, specification:SpecProperty) -> str:
    dot_lines = StrAwareList()
    dot_lines += 'MODULE main'
    dot_lines += 'IVAR'
    dot_lines += ['  {signal} : boolean;'.format(signal=s.name) for s in lts.input_signals]

    dot_lines += 'VAR'
    dot_lines += '  {state} : {{ {states} }};'.format(states=to_str(lts.states), state=lts.state_name)

    dot_lines += 'DEFINE'
    dot_lines += ['  {out_name} := {formula} ;'.format(out_name=out_name,
                                                       formula=_get_formula(out_name, out_model))
                  for (out_name,out_model) in lts.model_by_name.items()]

    dot_lines += 'ASSIGN'
    dot_lines += '  init({state}) := {init_state};'.format(state=lts.state_name, init_state=list(lts.init_states)[0])

    dot_lines += '  next({state}) := '.format(state=lts.state_name)
    dot_lines += '    case'
    dot_lines += ['      {formula} : {next_state};'.format(formula=_clause_to_formula(label),
                                                           next_state=next_state)
                  for (label, next_state) in lts.tau_model.items()]
    dot_lines += '    esac;'

    dot_lines += 'LTLSPEC ' + AstToSmvProperty().dispatch(expr_from_property(specification))

    return '\n'.join(dot_lines)
