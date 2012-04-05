'''
@author: Bettina Koenighofer <bettina.koenighofer(at)iaik.tugraz.at>
'''

import smtSolver;

class z3(smtSolver.smtSolver):
    
    def __init__(self):
        print "init z3 object"
    
    def solve(self):
            print self.__class__.__name__