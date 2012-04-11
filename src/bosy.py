import argparse
import sys

from interfaces.ltl_spec import LtlSpec

from translation2uct.ltl2uct import ltl2uct

from synthesis.model_searcher import search

from module_generation.verilog import to_verilog


def parse_ltl(text):
    inputs = []
    outputs = []
    properties = []
    for l in text.strip().split('\n'):
        if 'INPUT:' in l:
            i = l.replace('INPUT:', '').strip()
            inputs.append(i)
        elif 'OUTPUT:' in l:
            o = l.replace('OUTPUT:', '').strip()
            outputs.append(o)
        elif 'PROPERTY:' in l:
            p = l.replace('PROPERTY:', '').strip()
            properties.append(p)
        else:
            assert False, 'unknown input line: ' + l

    return LtlSpec(inputs, outputs, properties)


def verilog_to_str(verilog_module):
    print('verilog_to_str: i am stub!')
    return 'stub verilog module!'


def main(argv):
    parser = argparse.ArgumentParser(description='A synthesizer of bounded systems from LTL')
    parser.add_argument('ltl', metavar='ltl', type=argparse.FileType('r'),
                        help='loads the LTL formula from the given input file')
    parser.add_argument('verilog', metavar='verilog', type=argparse.FileType('w'),
                        help='writes the verilog output to the given file')

    args = parser.parse_args(argv)

    ltl_spec = parse_ltl(args.ltl.read())
    args.ltl.close()

    uct = ltl2uct(ltl_spec)

    model = search(uct, ["r1", "r2"], ["g1","g2","g3"], 3)

    if model is None:
        print('The specification is unrealizable with input restrictions.')
        return

    verilog_module = to_verilog(model)

    args.verilog.write(verilog_to_str(verilog_module))
    args.verilog.close()


if __name__ == "__main__":
    import random

    hellos = ['Welcome to BoSy!', 'Hello!', 'Hallo!', 'Privet!', 'Haai!',
              'Ciao!', 'Tere!', 'Salut!', 'Namaste!', 'Heus!', 'Goede dag!',
              'Sveiki!', 'Selam!']
    print(hellos[random.randint(0, len(hellos) - 1)])

    main(sys.argv[1:])

    byes = ['bye', 'wederdom', 'Poka', 'Doei', 'Sees', 'Chao', 'zai jian', 'Hasta La Vista', 'Yasou']
    print(byes[random.randint(0, len(byes) - 1)] + '!')
