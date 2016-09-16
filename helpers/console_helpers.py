"""
Reqiures colorama package.
"""


def print_red(*o):
    try:
        from colorama import init, Fore
        init(autoreset=True)
        print(Fore.RED + str(list(o)[0]), *list(o)[1:])
    except ImportError:
        print(*o)


def print_green(*o):
    try:
        from colorama import init, Fore
        init(autoreset=True)
        print(Fore.GREEN + str(list(o)[0]), *list(o)[1:])
    except ImportError:
        print(*o)
