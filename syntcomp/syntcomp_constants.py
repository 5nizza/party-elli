REALIZABLE_STR = 'REALIZABLE'
UNREALIZABLE_STR = 'UNREALIZABLE'
UNKNOWN_STR = 'UNKNOWN'


def print_syntcomp_unreal():
    print(UNREALIZABLE_STR)


def print_syntcomp_unknown():
    print(UNKNOWN_STR)


def print_syntcomp_real(aiger_model:str):
    print(REALIZABLE_STR)
    print(aiger_model)

