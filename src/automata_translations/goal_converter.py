import os
import logging
import xml.etree.ElementTree as ET
import config
from tempfile import NamedTemporaryFile
from helpers.automata_helper import to_dot
from helpers.console_helpers import print_green
from helpers.python_ext import readfile
from helpers.shell import execute_shell
from interfaces.automata import Automaton, Node, Label, LABEL_TRUE
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
        :return: automaton in the GOAL format
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

    def convert_to_deterministic_total_minacc(self, ltl_formula:str, signal_by_name:dict, states_prefix) -> Automaton:
        # I use it for S_g, L_a, L_g

        # if doesn't scale -- try
        # load -c Promela input_file.gff;
        # i.e., convert using ltl3ba and then determinize using goal
        output_file_name = self._get_tmp_file_name()

        goal_script = """
$res = "{ltl_formula}";
$res = translate -sf -m ltl2ba $res;
$res = simplify -m fair -dse -ds -rse -rs -ru -rd $res;
$res = determinization -m bk09 $res;
acc -min $res;
save $res {output_file_name};
""".format(ltl_formula=ltl_formula, output_file_name=output_file_name)
        # $res = simplify $res;

        self._execute_goal_script(goal_script)
        gff_xml = readfile(output_file_name)

        automaton = gff_2_automaton(gff_xml, signal_by_name, states_prefix)

        os.remove(output_file_name)

        return automaton

    def convert_to_deterministic_maxacc(self, ltl_formula:str, signal_by_name:dict, states_prefix) -> Automaton:
        # I use it for S_a
        output_file_name = self._get_tmp_file_name()

        # to ensure that the automaton does not have non-accepting states we call `simplify -rd` (remove dead states)
        # after determinization
        goal_script = """
$res = "{ltl_formula}";
$res = translate -sf -m ltl2ba $res;
$res = simplify -m fair -dse -ds -rse -rs -ru -rd $res;
$res = determinization -m bk09 $res;
$res = simplify -rd $res;
acc -max $res;
save $res {output_file_name};
""".format(ltl_formula=ltl_formula, output_file_name=output_file_name)
        # $res = simplify $res;

        self._execute_goal_script(goal_script)
        gff_xml = readfile(output_file_name)

        automaton = gff_2_automaton(gff_xml, signal_by_name, states_prefix)

        os.remove(output_file_name)

        return automaton

    def convert_to_nondeterministic(self, ltl_formula, signal_by_name, states_prefix):
        # I use it for S_a
        output_file_name = self._get_tmp_file_name()

        # to ensure that the automaton does not have non-accepting states we call `simplify -rd` (remove dead states)
        # after determinization
        goal_script = """
$res = "{ltl_formula}";
$res = translate -sf -m ltl2ba $res;
$res = simplify -m fair -dse -ds -rse -rs -ru -rd $res;
save $res {output_file_name};
""".format(ltl_formula=ltl_formula, output_file_name=output_file_name)
        # $res = simplify -rd $res;

        self._execute_goal_script(goal_script)
        gff_xml = readfile(output_file_name)

        automaton = gff_2_automaton(gff_xml, signal_by_name, states_prefix)

        os.remove(output_file_name)

        return automaton


# class DummyDict(dict):
#     def __getitem__(self, key):
#         return key
#
#     def __contains__(self, *args, **kwargs):
#         return True

def gff_2_automaton(gff_xml:str, signal_by_name, states_prefix:str) -> Automaton:
    # """
    # >>> print(gff_2_automaton(readfile('/tmp/tmp.gff'), 'prefix', DummyDict()))
    # """

    # TODO: simplify transitions labels

    def get_add(name:str):
        if name not in node_by_name:
            node_by_name[name] = Node(states_prefix + name)
        return node_by_name[name]

    node_by_name = dict()

    root = ET.fromstring(gff_xml)

    init_node = get_add(root.find('InitialStateSet').find('StateID').text)

    acc_nodes = set(map(get_add, [elem.text for elem in root.find('Acc').iter('StateID')]))

    for transition_element in root.iter('Transition'):
        src_str = transition_element.find('From').text
        dst_str = transition_element.find('To').text
        lbl_str = transition_element.find('Label').text    # list of name/~name separated by the space

        src = get_add(src_str)
        dst = get_add(dst_str)

        if lbl_str == 'True':
            lbl = LABEL_TRUE
        else:
            lbl = Label([(signal_by_name[var.strip('~')], '~' not in var)
                         for var in lbl_str.split()])

        src.add_transition(lbl, [(dst, dst in acc_nodes)])

    automaton = Automaton([init_node], acc_nodes, node_by_name.values())
    return automaton

    # acc_trap_states = set()
    # for s in acc_states:
    #     s_edges = edges.get((s,s))
    #     if s_edges:
    #         if reduces_to_true(s_edges):
    #             acc_trap_states.add(s)  # TODOopt: also replace edges with one trivial

    # acc_states.difference_update(acc_trap_states)

# def is_all_states_are_accepting(automaton:Automaton):
#     return set(automaton.states) == set(automaton.acc_live_states).union(automaton.acc_dead_states)


# def reduces_to_true(clauses):
#     """
#     >>> reduces_to_true([('True',), ('a',)])
#     True
#     >>> reduces_to_true([('r',), ('~r',)])
#     True
#     >>> reduces_to_true([('r',), ('~a',)])
#     False
#     >>> reduces_to_true([('r', 'b'), ('~r',)])
#     False
#     >>> reduces_to_true([('r','b'), ('~r','~b')])
#     False
#     >>> reduces_to_true(['a b'.split(), '~a ~b'.split(), '~a b'.split(), 'a ~b'.split()])
#     True
#     >>> reduces_to_true(['a b'.split(), '~a ~b'.split(), '~a b'.split(), 'a ~b'.split()])
#     True
#     """
#
#     clauses = list(clauses)
#
#     expr = false
#     for c in clauses:
#         new_c = true
#         for l in c:
#             v = l.replace('~', '')
#             if v == 'True' or v == 'False':
#                 s = sympify(v)
#             else:
#                 s = Symbol(v)
#             new_c &= (~s if '~' in l else s)
#         expr |= new_c
#
#     return simplify_logic(expr) == true
