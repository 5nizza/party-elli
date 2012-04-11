import argparse
import sys
import random

from interfaces.ltl_spec import LtlSpec
from translation2uct.ltl2uct import ltl2uct
from synthesis.model_searcher import search
from module_generation.verilog import to_verilog


def parse_ltl(text):
    inputs = []
    outputs = []
    for l in text.strip().split('\n'):
        if 'INPUT:' in l:
            i = l.replace('INPUT:', '').strip()
            inputs.append(i)
        elif 'OUTPUT:' in l:
            o = l.replace('OUTPUT:', '').strip()
            outputs.append(o)
        elif 'PROPERTY:' in l:
            p = l.replace('PROPERTY:', '').strip()
            property = p
        else:
            assert False, 'unknown input line: ' + l

    return LtlSpec(inputs, outputs, property)


def verilog_to_str(verilog_module):
    print('verilog_to_str: i am stub!')
    return 'stub verilog module!'


def main(ltl_file, bound, verilog_file, ltl2ba_path, z3path):
    ltl_spec = parse_ltl(ltl_file.read())

    uct = ltl2uct(ltl_spec, ltl2ba_path)

    model = search(uct, ltl_spec.inputs, ltl_spec.outputs, bound, z3path)

    if model is None:
        print('The specification is unrealizable with input restrictions.')
        return

    verilog_module = to_verilog(model)

    output = verilog_to_str(verilog_module)
    if verilog_file is not None:
        verilog_file.write(output)
    else:
        print('-'*80)
        print(output)


def print_hello():
    hellos = ['Welcome to BoSy!', 'Hello!', 'Hallo!', 'Privet!', 'Haai!',
              'Ciao!', 'Tere!', 'Salut!', 'Namaste!', 'Heus!', 'Goede dag!',
              'Sveiki!', 'Selam!']
    print(hellos[random.randint(0, len(hellos) - 1)])


def print_bye():
    byes = ['bye', 'wederdom', 'Poka', 'Doei', 'Sees', 'Chao', 'zai jian', 'Hasta La Vista', 'Yasou']
    print(byes[random.randint(0, len(byes) - 1)] + '!')


if __name__ == "__main__":
    print_hello()

    parser = argparse.ArgumentParser(description='A synthesizer of bounded systems from LTL')
    parser.add_argument('ltl', metavar='ltl', type=argparse.FileType(),
        help='loads the LTL formula from the given input file')
    parser.add_argument('-verilog', metavar='verilog', type=argparse.FileType('w'), required=False,
        help='writes the verilog output to the given file')
    parser.add_argument('-bound', metavar='bound', type=int, default=1, required=False,
        help='bound the maximal size of the system to synthesize(default: %(default)i)')

    args = parser.parse_args(sys.argv[1:])

    #TODO: use external config file?
    ltl2ba_path = 'lib/ltl2ba-1.1/ltl2ba.exe'
    z3_path = 'z3'

    main(args.ltl, args.bound, args.verilog, ltl2ba_path, z3_path)

    args.ltl.close()
    if args.verilog:
        args.verilog.close()

    print_bye()
