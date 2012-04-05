'''
@author: Bettina Koenighofer <bettina.koenighofer(at)iaik.tugraz.at>
'''

from smtSolver import z3

def main():
    print "Welcome to BMC!"
    
    solver = z3.z3()
    solver.solve()
    

if __name__ == "__main__":
    main()
