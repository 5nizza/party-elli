import math
from helpers.python_ext import StrAwareList, lmap, bin_fixed_list
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

from interfaces.parser_expr import QuantifiedSignal, BinOp, and_expressions
from interfaces.spec import SpecProperty, expr_from_property
from module_generation.ast_to_smv_property import AstToSmvProperty
from parsing.helpers import WeakToUntilConverterVisitor


def _ith_state_bit(i:int) -> str:
    return 's' + str(i)


def _state_to_formula(state:str, bits_by_state:dict,) -> str:
    clause = ' & '.join('({neg}{name})'.format(neg=['!',''][val],
                                               name=_ith_state_bit(i))
                        for i,val in enumerate(bits_by_state[state]))

    return '(' + clause + ')'


def _clause_to_formula(clause:Label, bits_by_state:dict) -> str:
    literals = []
    for (var, value) in clause.items():
        if isinstance(var, QuantifiedSignal):
            lit = ['!', ''][value] + var.name
        else:
            lit = _state_to_formula(value, bits_by_state)
        literals.append(lit)

    return '(' + ' & '.join(literals) + ')'


def _get_formula(out_name, out_model, bits_by_state:dict) -> str:
    clauses = [label for (label, value) in out_model.items()
               if value is True]

    if not clauses:
        return 'FALSE'

    return ' | '.join(map(lambda c: _clause_to_formula(c, bits_by_state), clauses))


def _assert_no_intersection(state_bool_vars, signals):
    state_bool_vars = set(state_bool_vars)
    signal_names = set(s.name for s in signals)

    intersection = state_bool_vars.intersection(signal_names)
    assert not intersection, str(intersection)


def to_boolean_nusmv(lts:LTS, specification:SpecProperty) -> str:
    nof_state_bits = int(max(1, math.ceil(math.log(len(lts.states), 2))))
    bits_by_state = dict((state, bin_fixed_list(i, nof_state_bits))
                         for (i,state) in enumerate(sorted(lts.states)))

    state_bits = lmap(_ith_state_bit, range(nof_state_bits))

    _assert_no_intersection(state_bits, list(lts.input_signals) + lts.output_signals)

    dot_lines = StrAwareList()
    dot_lines += 'MODULE main'
    dot_lines += 'IVAR'
    dot_lines += ['  {signal} : boolean;'.format(signal=s.name) for s in lts.input_signals]

    dot_lines += 'VAR'
    dot_lines += ['  {si} : boolean;'.format(si=si) for si in state_bits]

    dot_lines += 'DEFINE'
    dot_lines += ['  {out_name} := {formula} ;'.format(out_name=out_name,
                                                       formula=_get_formula(out_name, out_model, bits_by_state))
                  for (out_name,out_model) in lts.model_by_name.items()]

    dot_lines += 'ASSIGN'
    for i,sb in enumerate(state_bits):
        sb_init = str(bits_by_state[list(lts.init_states)[0]][i]).upper()

        dot_lines += '  init({sb}) := {init_sb};'.format(sb=sb, init_sb=sb_init)

        dot_lines += '  next({sb}) := '.format(sb=sb)
        dot_lines += '    case'

        for (label,next_state) in lts.tau_model.items():
            sb_next = str(bits_by_state[next_state][i]).upper()
            dot_lines += '      {formula} : {next_state};'.format(formula=_clause_to_formula(label, bits_by_state),
                                                                  next_state=sb_next)

        dot_lines += '    TRUE : FALSE;'  # default: unreachable states, don't care
        dot_lines += '    esac;'

    expr = BinOp('->', and_expressions(specification.assumptions), and_expressions(specification.guarantees))
    expr = WeakToUntilConverterVisitor().dispatch(expr)  # SMV does not have Weak until

    dot_lines += 'LTLSPEC ' + AstToSmvProperty().dispatch(expr)

    return '\n'.join(dot_lines)
