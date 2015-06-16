#!/usr/bin/env python3
from itertools import combinations
import argparse


def _floor(number):
    return 'f'+str(number)


def _button(number):
    return 'b'+str(number)


def _get_single_assumption(floor_number):
    return '(!%(button)s) && []((%(button)s && %(floor)s) -> X(!%(button)s)) && ' \
                          '[]((%(button)s && (!%(floor)s) -> X(%(button)s)) )' % \
        {
            'button': _button(floor_number),
            'floor': _floor(floor_number)
        }


def _generate_assumption(nof_floors):
    return ' && '.join(map(_get_single_assumption, range(0, nof_floors)))


def _generate_single_up(floor_number):
    return '(%(floor)s && X(%(above_floor)s))' % \
        {'floor': _floor(floor_number),
         'above_floor': _floor(floor_number+1)
        }


def _generate_up_condition(nof_floors):
    return ' || '.join(map(_generate_single_up, range(nof_floors-1)))


def _generate_button_pressed_condition(nof_floors):
    return ' || '.join([_button(i) for i in range(nof_floors)])


def _request_is_finally_granted(floor_number):
    return '[]({0} -> <>({1}))'.format(_button(floor_number), _floor(floor_number))


def _allowed_move(floor_number, max_number):
    if floor_number == 0:
        return '[]({0} -> X({0} || {1}))'.format(_floor(0), _floor(1))

    if floor_number == max_number - 1:
        return '[]({0} -> X({0} || {1}))'.format(_floor(floor_number), _floor(floor_number-1))

    return '[]({0} -> X({0} || {1} || {2}))'.format(_floor(floor_number),
                                                   _floor(floor_number+1),
                                                   _floor(floor_number-1))


def _single_exclusion(i, j):
    return '[](! ({0} && {1}) )'.format(_floor(i), _floor(j))


def _generate_mutual_exclusion_of_floors(nof_floors):
    return ' && '.join(_single_exclusion(i, j) for i, j in combinations(range(nof_floors), 2))


def _generate_guarantee(nof_floors):
    up = _generate_up_condition(nof_floors)
    button_pressed = _generate_button_pressed_condition(nof_floors)
    floors_mutual_exclusion = _generate_mutual_exclusion_of_floors(nof_floors)

    initial_floor = _floor(0)
    every_request_granted = ' && '.join(map(_request_is_finally_granted, range(nof_floors)))

    allowed_moves = ' && '.join(map(lambda f: _allowed_move(f, nof_floors), range(nof_floors)))

    return '( (%(initial)s) && []((%(up)s) -> (%(sb)s)) &&  []<>(%(floor0)s || (%(sb)s)) && (%(exclusion)s) && (%(liveness)s) && (%(movements)s) )' % \
        {
            'initial': initial_floor,
            'up': up,
            'sb': button_pressed,
            'floor0': _floor(0),
            'exclusion': floors_mutual_exclusion,
            'liveness': every_request_granted,
            'movements': allowed_moves
        }


def _generate_spec(nof_floors):
    inputs = [_button(i) for i in range(nof_floors)]
    outputs = [_floor(i) for i in range(nof_floors)]

    assumption = _generate_assumption(nof_floors)
    guarantee = _generate_guarantee(nof_floors)

    out_text = [
        '\n'.join(['INPUT: {0}'.format(i) for i in inputs]),
        '\n'.join(['OUTPUT: {0}'.format(o) for o in outputs]),
        'PROPERTY:({0}) -> ({1})'.format(assumption, guarantee)
    ]

    return '\n'.join(out_text)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('nof_floors',
        type=int,
        help='the number of floors in your skyscraper')

    args = parser.parse_args()

    print(_generate_spec(args.nof_floors))

