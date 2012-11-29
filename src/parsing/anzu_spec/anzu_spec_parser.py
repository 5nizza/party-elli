from helpers.ply import yacc
from helpers.spec_helper import and_properties
from parsing.anzu_spec.interface import *


class Visitor:
    def dispatch(self, node):
        if isinstance(node, BinOp):
            return self.visit_binary_op(node)

        if isinstance(node, UnaryOp):
            return self.visit_unary_op(node)

        if isinstance(node, Bool):
            return self.visit_bool(node)

        if isinstance(node, Signal):
            return self.visit_signal(node)

        if isinstance(node, Number):
            return self.visit_number(node)

        assert 0, 'unknown node type' + str(node)

    def visit_binary_op(self, binary_op): raise NotImplementedError()
    def visit_unary_op(self, unary_op): raise NotImplementedError()
    def visit_bool(self, bool_const): raise NotImplementedError()
    def visit_signal(self, signal): raise NotImplementedError()
    def visit_number(self, number): raise NotImplementedError()


def parse_ltl(anzu_text):
    """ Return {section:data}, see sections in syntax_desc """
    section_name_to_data = dict(yacc.parse(anzu_text))
    return section_name_to_data


########################################################################
# helpers
class ConverterToLtl2BaFormatVisitor(Visitor):
    def visit_binary_op(self, binary_op):
        arg1 = self.dispatch(binary_op._arg1)
        arg2 = self.dispatch(binary_op._arg2)

        if binary_op.name == '*':
            return '({arg1}) && ({arg2})'.format(arg1 = arg1, arg2 = arg2)

        if binary_op.name == '=':
            return '{neg}{arg1}'.format(arg1 = arg1, neg = ['', '!'][arg2 == Number(0)])

        if binary_op.name == '+':
            return '({arg1}) || ({arg2})'.format(arg1 = arg1, arg2 = arg2)

        if binary_op.name == 'U' or binary_op.name == '->' or binary_op.name == '<->':
            return '({arg1}) {op} ({arg2})'.format(arg1 = arg1, arg2 = arg2, op = binary_op.name)

        assert 0, 'unknown binary operator: ' + "'" + str(binary_op.name) + "'"

    def visit_unary_op(self, unary_op):
        arg = self.dispatch(unary_op._arg)
        assert unary_op.name in ('G', 'F', 'X', '!'), 'unknown unary operator: ' + str(unary_op.name)
        return '{op}({arg})'.format(op = unary_op.name, arg = arg)

    def visit_bool(self, bool_const):
        return bool_const.name.lower()

    def visit_signal(self, signal):
        return signal.name.lower() #ltl3ba treats upper letter wrongly

    def visit_number(self, number):
        return number


def convert_ast_to_ltl3ba_format(property_ast):
    result = ConverterToLtl2BaFormatVisitor().dispatch(property_ast)
    return result


def convert_asts_to_ltl3ba_format(asts):
    properties = list(map(lambda a: convert_ast_to_ltl3ba_format(a), asts)) +\
                 list(map(lambda a: convert_ast_to_ltl3ba_format(a), asts))
    property = and_properties(properties)

    return property


########################################################################
# tests

test_string = """
###############################################
# Input variable definition
###############################################
[INPUT_VARIABLES] #9
hready;
hbusreq0;
hlock0;
hbusreq1;
hlock1;
hbusreq2;
hlock2;
hburst0;
hburst1;

###############################################
# Output variable definition
###############################################
[OUTPUT_VARIABLES] #18
hmaster0;
hmaster1;
hmastlock;
start;
decide;
locked;
hgrant0;
hgrant1;
hgrant2;
busreq;
stateA1_0;
stateA1_1;
stateG2;
stateG3_0;
stateG3_1;
stateG3_2;
stateG10_1;
stateG10_2;

###############################################
# Environment specification
###############################################
[ENV_INITIAL] #9
hready=0;
hbusreq0=0;
hlock0=0;
hbusreq1=0;
hlock1=0;
hbusreq2=0;
hlock2=0;
hburst0=0;
hburst1=0;

[ENV_TRANSITIONS] #3
G( hlock0=1 -> hbusreq0=1 );
G( hlock1=1 -> hbusreq1=1 );
G( hlock2=1 -> hbusreq2=1 );

[ENV_FAIRNESS] #2
G(F(stateA1_1=0));
G(F(hready=1));

###############################################
# System specification
###############################################
[SYS_INITIAL] #18
hmaster0=0;
hmaster1=0;
hmastlock=0;
start=1;
decide=1;
locked=0;
hgrant0=1;
hgrant1=0;
hgrant2=0;
busreq=0;
stateA1_0=0;
stateA1_1=0;
stateG2=0;
stateG3_0=0;
stateG3_1=0;
stateG3_2=0;
stateG10_1=0;
stateG10_2=0;

[SYS_TRANSITIONS] #5
G((hmaster0=0) * (hmaster1=0) -> (hbusreq0=0 <-> busreq=0));
G((hmaster0=1) * (hmaster1=0) -> (hbusreq1=0 <-> busreq=0));
G((hmaster0=0) * (hmaster1=1) -> (hbusreq2=0 <-> busreq=0));
G(((stateA1_1=0) * (stateA1_0=0) * ((hmastlock=0) + (hburst0=1) + (hburst1=1))) ->
 X((stateA1_1=0) * (stateA1_0=0)));
G(((stateA1_1=0) * (stateA1_0=0) *  (hmastlock=1) * (hburst0=0) * (hburst1=0)) ->
 X((stateA1_1=1) * (stateA1_0=0)));

[SYS_FAIRNESS] #5
G(F(stateG2=0));
G(F((stateG3_0=0)  *  (stateG3_1=0)  *  (stateG3_2=0)));
G(F(((hmaster0=0) * (hmaster1=0))  +  hbusreq0=0));
G(F(((hmaster0=1) * (hmaster1=0))  +  hbusreq1=0));
G(F(((hmaster0=0) * (hmaster1=1))  +  hbusreq2=0)); """


def _do_tests():
    result = yacc.parse(test_string)

    section_name_to_data = dict(result)
    print('the result of parsing\n', section_name_to_data)

    expected_results = {'INPUT_VARIABLES':9, 'OUTPUT_VARIABLES':18,
                        'SYS_FAIRNESS':5, 'SYS_TRANSITIONS':5, 'SYS_INITIAL':18,
                        'ENV_FAIRNESS':2, 'ENV_TRANSITIONS':3, 'ENV_INITIAL':9}

    for section_name, data in section_name_to_data.items():
        actual = len(data)
        expected = expected_results[section_name]
        assert actual == expected, '{actual} != {expected}: {section}'.format(
            actual = actual, expected =expected, section = section_name)


if __name__ == '__main__':
    _do_tests()
    print('tests passed!')

