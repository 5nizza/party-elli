#!/usr/bin/env python3
from itertools import combinations
import argparse
from benchmarks.spec_helper import and_, inst_i

NOF_FLOORS = 4

####################################################
def _floor(number):
    return 'f'+str(number)


def _button(number):
    return 'b'+str(number)


def _generate_single_up(floor_number):
    return '(%(floor)s && X(%(above_floor)s))' % \
        {'floor': _floor(floor_number),
         'above_floor': _floor(floor_number+1)
        }


def _generate_up_condition(nof_floors):
    return ' || '.join(map(_generate_single_up, range(nof_floors-1)))


def _generate_button_pressed_condition(nof_floors):
    return ' || '.join([_button(i) for i in range(nof_floors)])


def _allowed_move(floor_number, max_number):
    if floor_number == 0:
        return '({0} -> X({0} || {1}))'.format(_floor(0), _floor(1))

    if floor_number == max_number - 1:
        return '({0} -> X({0} || {1}))'.format(_floor(floor_number), _floor(floor_number-1))

    return '({0} -> X({0} || {1} || {2}))'.format(_floor(floor_number),
                                                  _floor(floor_number+1),
                                                  _floor(floor_number-1))


def _single_exclusion(i, j):
    return '(!({0} && {1}))'.format(_floor(i), _floor(j))


def _generate_mutual_exclusion_of_floors(nof_floors):
    return ' && '.join(_single_exclusion(i, j) for i, j in combinations(range(nof_floors), 2))


####################################################

inputs = [_button(i) for i in range(NOF_FLOORS)]
outputs = [_floor(i) for i in range(NOF_FLOORS)]

S_a_init_i = '!b{i}'
S_a_trans_i = and_('b{i} && f{i}  -> X !b{i}',
                   'b{i} && !f{i} -> X b{i}')

#
S_a_init = inst_i(S_a_init_i, NOF_FLOORS)
S_a_trans = inst_i(S_a_trans_i, NOF_FLOORS)
L_a_property = 'true'

#
S_g_init = 'f0'

S_g_trans1 = '({up}) -> ({sb})'.format(up=_generate_up_condition(NOF_FLOORS),
                                       sb=_generate_button_pressed_condition(NOF_FLOORS))
S_g_trans2 = _generate_mutual_exclusion_of_floors(NOF_FLOORS)
S_g_trans3 = and_(*[_allowed_move(f, NOF_FLOORS) for f in range(NOF_FLOORS)])
S_g_trans = and_(S_g_trans1, S_g_trans2, S_g_trans3)

L_g_property1 = 'G F (f0 || ({sb}))'.format(sb=_generate_button_pressed_condition(NOF_FLOORS))
L_g_property2 = inst_i('G(b{i} -> F f{i})', NOF_FLOORS)
L_g_property = and_(L_g_property1, L_g_property2)

