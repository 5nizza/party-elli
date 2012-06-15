from helpers import boolean
from helpers.boolean import AND, normalize, FALSE, TRUE
from interfaces.automata import Automaton, get_next_states, Node, enumerate_values, DEAD_END, LIVE_END


def _build_terminals(automaton):
    term_clauses = dict([(s, boolean.Symbol(s.name)) for s in automaton.nodes if s.name != ''])
    true_states = list(filter(lambda x: x.name == '', automaton.nodes))

    if true_states is not None and len(true_states) == 1:
        term_clauses[true_states[0]] = boolean.TRUE

    term_clauses[DEAD_END] = FALSE

    return term_clauses


def _build_clause(term_clauses, list_of_state_sets):
    if len(list_of_state_sets) is 0:
        return boolean.FALSE

    ors = []
    for state_set in list_of_state_sets:
        if len(state_set) > 1:
            and_args = list(map(lambda s: term_clauses[s], state_set))
            ors.append(boolean.AND(*and_args))
        else:
            state = list(state_set)[0]
            ors.append(term_clauses[state])

    if len(ors) > 1:
        clause = boolean.OR(*ors)
    else:
        clause = ors[0]

    return clause


def _get_spec_states_of_clause(spec_state_clause, terminals):
    symbols = spec_state_clause.symbols
    symbol_to_state = dict([(x[1],x[0]) for x in terminals.items()])
    states = set(map(lambda s: symbol_to_state[s], symbols))
    return states


def _get_next_spec_state_clause(signal_values,
                                spec_state_clause,
                                term_clauses):
    # each state is replaced by true/false/next_spec_state_by_automaton
    # then the formula is evaluated:
    # return true/false/next_spec_state_clause

    states = _get_spec_states_of_clause(spec_state_clause, term_clauses)

    subst_map = {}
    for state in states:
        list_of_next_state_sets = get_next_states(state, signal_values)
        next_state_clause = _build_clause(term_clauses, list_of_next_state_sets)
        subst_map[term_clauses[state]] = next_state_clause

    if subst_map:
        next_clause = spec_state_clause.subs(subst_map)
    else:
        next_clause = FALSE

    return next_clause


def _get_node_name(clause):
    assert clause != FALSE and clause != TRUE

    node_name = str(clause).replace('+', '_or_').replace(' ', '')
    return node_name


def _create_nodes_if_necessary(clauses, clause_to_node):
    return list(map(lambda c: _get_create(c, clause_to_node), clauses))


def _get_create(clause, clause_to_node):
    if clause not in clause_to_node:
        clause_to_node[clause] = Node(_get_node_name(clause))

    return clause_to_node[clause]


def _process_spec_clause(crt_clause, term_clauses, clauses_generated, clause_to_node, variables):
    crt_node = _get_create(crt_clause, clause_to_node)

    #TODO: how not to enumerate all values? consider only existing! it is possible man.
    for signal_values in enumerate_values(variables):
        next_clause = _get_next_spec_state_clause(signal_values, crt_clause, term_clauses)
        #next clause might be True/False
        #ignore True, map False to a dead state
        if next_clause == TRUE:
            continue

        next_clauses = normalize(AND, next_clause)
        _create_nodes_if_necessary(next_clauses, clause_to_node)

        next_states = set(map(lambda c: clause_to_node[c], next_clauses))
        assert len(next_states) > 0

        crt_node.add_transition(signal_values, next_states)

        clauses_generated.update(next_clauses)


def convert_acw_to_ucw(acw, variables):
    """ Accepts alternating coBuchi automaton as outputted by
        ltl3ba: failing out of automaton => death!
        but here in Universal coBuchi automaton:
                failing out of automaton => life!
    """

    term_clauses = _build_terminals(acw)

    clause_to_node = {FALSE: DEAD_END} #adding TRUE might be dangerous

    init_state_clause = _build_clause(term_clauses, acw.initial_sets_list)

    explored_clauses = set()
    unexplored_clauses = {init_state_clause}
    while unexplored_clauses:
        crt_clause = unexplored_clauses.pop()

        clauses_generated = set()
        _process_spec_clause(crt_clause, term_clauses, clauses_generated, clause_to_node, variables)

        explored_clauses.add(crt_clause)
        unexplored_clauses.update(clauses_generated.difference(explored_clauses))

    init_list_of_sets = [{clause_to_node[init_state_clause]}]
    rejecting_states = set()
    states = set(map(lambda c: clause_to_node[c], explored_clauses))

    return Automaton(init_list_of_sets, rejecting_states, states)
