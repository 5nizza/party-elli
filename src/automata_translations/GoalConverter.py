import os
import logging
import xml.etree.ElementTree as ET
import config
from tempfile import NamedTemporaryFile
from helpers.shell import execute_shell
from interfaces.automata import Automaton
from sympy import true, sympify
from sympy.core.symbol import Symbol
from sympy.logic.boolalg import simplify_logic, false


# this file contains excerpts from Framework for Specifying Synthesis Problems by A.Khalimov

class GoalConverter:
    def __init__(self, goal_exec_path):
        self._goal_path = goal_exec_path

    def _get_tmp_file_name(self):
        tmp = NamedTemporaryFile(prefix='goal_', delete=False)
        return tmp.name

    def _execute_goal_script(self, script:str) -> str:
        """
        :return: stdout as printed by GOAL
        """
        logger = logging.getLogger(__name__)

        script_tmp_file_name = self._get_tmp_file_name()
        with open(script_tmp_file_name, 'w') as f:
            f.write(script)
            logger.debug(script)

        cmd_to_execute = '%s batch %s' % (config.GOAL, script_tmp_file_name)
        res, out, err = execute_shell(cmd_to_execute)
        assert res == 0 and err == '', 'Shell call failed:\n' + cmd_to_execute + '\nres=%i\n err=%s' % (res, err)

        os.remove(script_tmp_file_name)
        return out

    def formula_2_automaton_gff(self, spec:PropertySpec) -> PropertySpec:
        input_file_name = self._get_tmp_file_name()
        output_file_name = self._get_tmp_file_name()

        with open(input_file_name, 'w') as f:
            f.write(spec.data)

        goal_script = "translate QPTL -m ltl2ba -t nbw -o %s %s;" % (output_file_name, input_file_name)
        self._execute_goal_script(goal_script)

        automaton_data = readfile(output_file_name)

        new_spec = copy.copy(spec)
        new_spec.data = automaton_data
        new_spec.input_type = "automaton"

        os.remove(input_file_name)
        os.remove(output_file_name)

        return new_spec

    def convert_to_deterministic(self, ltl_formula:str, signal_by_name:dict, states_prefix) -> Automaton:
        # if doesn't scale -- try
        # load -c Promela input_file.gff;
        # i.e., convert using ltl3ba and then determinize using goal

        output_file_name = self._get_tmp_file_name()

        goal_script = """
$res = "{ltl_formula}";
$res = translate $res;
$res = simplify -m fair -dse -ds -rse -rs -ru -rd $res;
$res = determinization -m bk09 $res;
""".format(ltl_formula=ltl_formula)

        # goal_script = GoalScript(output_file_name)
        # goal_script.load_ltl_formula(ltl_formula)
        # goal_script.convert_ltl()
        # goal_script.simplify()
        # goal_script.determinize()
        # goal_script.max_acceptance()
        # goal_script.save()

        out = self._execute_goal_script(goal_script)
        # now parse the result into automaton

        os.remove(output_file_name)

        assert 0

    def determinize(self, automaton:Automaton, signal_by_name:dict) -> Automaton:
        # 1. allow the format of properties to be the GOAL format (which subsumes ltl3ba)
        # 2. using goal convert formula into an automaton
        # 3. using goal determinize the automaton
        # will this scale?

        assert 0


class GoalScript:
    def __init__(self, output_file):
        self.text = ''
        self.output_file = output_file

    def load_ltl_formula(self, ltl_formula:str):
        self.text += '$res = "%s"' % ltl_formula

    def convert_ltl(self):
        self.text += '$res = translate {$res};\n'

    def simplify(self):
        self.text +=

    def save(self):
        self.text += 'save $res -o ' + self.output_file


def is_all_states_are_accepting(automaton:Automaton):
    return set(automaton.states) == set(automaton.acc_live_states).union(automaton.acc_dead_states)


def reduces_to_true(clauses):
    """
    >>> reduces_to_true([('True',), ('a',)])
    True
    >>> reduces_to_true([('r',), ('~r',)])
    True
    >>> reduces_to_true([('r',), ('~a',)])
    False
    >>> reduces_to_true([('r', 'b'), ('~r',)])
    False
    >>> reduces_to_true([('r','b'), ('~r','~b')])
    False
    >>> reduces_to_true(['a b'.split(), '~a ~b'.split(), '~a b'.split(), 'a ~b'.split()])
    True
    >>> reduces_to_true(['a b'.split(), '~a ~b'.split(), '~a b'.split(), 'a ~b'.split()])
    True
    """

    clauses = list(clauses)

    expr = false
    for c in clauses:
        new_c = true
        for l in c:
            v = l.replace('~', '')
            if v == 'True' or v == 'False':
                s = sympify(v)
            else:
                s = Symbol(v)
            new_c &= (~s if '~' in l else s)
        expr |= new_c

    return simplify_logic(expr) == true


def gff_2_automaton(gff_xml:str) -> Automaton:  # TODOopt: (boolean) simplify transitions labels
    # """
    # >>> print(gff_2_automaton(readfile('/tmp/tmp.gff')))
    # """
    states = set()
    edges = dict()  # (src,dst) -> set of labels
    root = ET.fromstring(gff_xml)
    for transition_element in root.iter('Transition'):
        src = transition_element.find('From').text
        dst = transition_element.find('To').text
        lbl = transition_element.find('Label').text

        states.add(src)
        states.add(dst)

        if (src,dst) not in edges:
            edges[(src,dst)] = set()

        edges[(src,dst)].add(tuple(lbl.split()))

    init_state = root.find('InitialStateSet').find('StateID').text

    acc_states = set(elem.text for elem in root.find('Acc').iter('StateID'))

    acc_trap_states = set()
    for s in acc_states:
        s_edges = edges.get((s,s))
        if s_edges:
            if reduces_to_true(s_edges):
                acc_trap_states.add(s)  # TODOopt: also replace edges with one trivial

    acc_states.difference_update(acc_trap_states)

    return Automaton(states, init_state, acc_states, acc_trap_states, list(edges.items()))

