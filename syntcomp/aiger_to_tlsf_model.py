#!/usr/bin/env python3
import argparse
from typing import List

from helpers.python_ext import readfile, lmap


def _get_bad_line_indices(aiger_lines:List[str], bad_name:str) -> (int, int, int):
    """ :returns line_of_def, line_of_symbol, id """
    header_numbers = lmap(int, aiger_lines[0].split()[1:])  # aag M I L O A
    symbols_table_start = 1+sum(header_numbers[1:])
    for i,l in enumerate(aiger_lines[symbols_table_start:]):
        if l == 'c':
            assert 0, 'name of the bad output was not found'
        if l[0] == 'o':  # example: "o0 g_0"
            names = l.split()[1:]
            if bad_name in names:
                idx = int(l.split()[0][1:])
                return (1+header_numbers[1]+header_numbers[2]+idx), symbols_table_start+i, idx
    assert 0, 'name of the bad output was not found'


def convert_aiger_model_to_tlsf(aiger_model:str, bad_name:str) -> str:
    """ :returns AIGER string with bad output removed and
                 outputs have prefix 'controllable_' removed.
                 The header is adapted.
    """
    aiger_lines = aiger_model.splitlines()
    header_numbers = lmap(int, aiger_lines[0].split()[1:])  # aag M I L O A
    assert len(header_numbers) == 5, 'only old AIGER format is supported'
    new_header = 'aag ' + ' '.join(map(str, header_numbers[:3] + [header_numbers[3]-1] + header_numbers[4:]))

    bad_def_line_idx, bad_sym_line_idx, bad_idx = _get_bad_line_indices(aiger_lines, bad_name)

    new_aiger_lines = [new_header] + \
                      aiger_lines[1:bad_def_line_idx] + \
                      aiger_lines[bad_def_line_idx+1:bad_sym_line_idx] + \
                      aiger_lines[bad_sym_line_idx+1:]

    symbols_table_start = 1+sum(header_numbers[1:])
    for i,l in enumerate(new_aiger_lines[symbols_table_start:]):
        if l[0] == 'o':
            cur_idx = int(l.split()[0][1:])
            new_aiger_lines[symbols_table_start+i] = 'o{dec} {wo_prefix}'.format(
                dec=cur_idx-1 if cur_idx>bad_idx else cur_idx,
                wo_prefix=' '.join(l.split()[1:])[len('controllable_'):])
        if l[0] == 'c':
            break
    return '\n'.join(new_aiger_lines)


def main():
    parser = argparse.ArgumentParser(description='I remove `bad` output and '
                                                 'remove prefix `controllable` from output names',
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    parser.add_argument('aiger', metavar='aiger', type=str,
                        help='input AIGER file')
    parser.add_argument('bad', metavar='bad', type=str,
                        help='name of the bad output')

    args = parser.parse_args()
    file = args.aiger
    bad = args.bad
    print(convert_aiger_model_to_tlsf(readfile(file), bad))


if __name__ == '__main__':
    main()
