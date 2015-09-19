#!/usr/bin/env python3
# simple script to convert Unbeast specs to Acacia/Lily like

import xml.etree.ElementTree as ET
from xml.etree.ElementTree import Element

import sys


inputs = set()
outputs = set()
assumptions = []
guarantees = []


def _walk(node:Element):
    global _handlers
    handler = _handlers.get(node.tag, _default)
    return handler(node)


def _default(node:Element):
    print('WARNING: no handler for: ' + node.tag)


def SynthesisProblem(node:Element):
    for c in node:
        _walk(c)


def GlobalInputs(node:Element):
    for c in node:
        inputs.add(_walk(c))


def GlobalOutputs(node):
    for c in node:
        outputs.add(_walk(c))


def Bit(node:Element):
    return node.text.lower()


def Assumptions(node:Element):
    for c in node:
        assumptions.append(_walk(c))


def LTL(node:Element):
    return _walk(list(node)[0])


def G(node:Element):
    return 'G({arg})'.format(arg=_walk(list(node)[0]))


def WU(node):
    assert 0


def F(node):
    return 'F({arg})'.format(arg=_walk(list(node)[0]))


def Not(node:Element):
    return '!({arg})'.format(arg=_walk(list(node)[0]))


def Var(node:Element):
    return '{a}=1'.format(a=node.text.lower())


def Specification(node:Element):
    for c in node:
        guarantees.append(_walk(c))


def Or(node:Element):
    args = []
    for c in node:
        args.append('({a})'.format(a=_walk(c)))
    return ' + '.join(args)


def And(node):
    args = []
    for c in node:
        args.append('({a})'.format(a=_walk(c)))
    return ' * '.join(args)


def U(node:Element):
    c1, c2 = list(node)
    return '({a1}) U ({a2})'.format(a1=_walk(c1), a2=_walk(c2))


def _False(node0):
    return 'FALSE'


def _True(node):
    return 'TRUE'


def X(node):
    return 'X({arg})'.format(arg=_walk(list(node)[0]))


def Iff(node:Element):
    assert 0


_handlers = {
    'SynthesisProblem':SynthesisProblem,
    'GlobalInputs':GlobalInputs,
    'GlobalOutputs':GlobalOutputs,
    'Bit':Bit,

    'False':_False,
    'True':_True,
    'Specification':Specification,
    'Assumptions':Assumptions,
    'LTL':LTL,
    'Or':Or,
    'And':And,
    'Not':Not,
    'Iff':Iff,
    'X':X,
    'G':G,
    'F':F,
    'U':U,
    'WU':WU,
    'Var':Var,
}


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('no input file is given')
        exit(0)

    file_name = sys.argv[1]
    tree = ET.parse(file_name)
    root= tree.getroot()

    _walk(root)

    file_prefix = file_name.strip('.xml').strip('.XML')

    with open(file_prefix + '.ltl', 'w') as ltl:
        for a in assumptions:
            ltl.write('assume ' + a + ';\n')

        for g in guarantees:
            ltl.write(g + ';\n')

    with open(file_prefix + '.part', 'w') as part:
        part.write('.inputs ' + ' '.join(inputs) + '\n')
        part.write('.outputs ' + ' '.join(outputs))
