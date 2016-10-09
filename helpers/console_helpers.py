"""
Reqiures colorama package.
"""


def print_red(*o):
    try:
        raise ImportError()    # fixme: colorama slows down with its colored print
        from colorama import init, Fore
        init(autoreset=True)
        print(Fore.RED + str(list(o)[0]), *list(o)[1:])
    except ImportError:
        print(*o)


def print_green(*o):
    try:
        raise ImportError()    # fixme: colorama slows down
        from colorama import init, Fore
        init(autoreset=True)
        print(Fore.GREEN + str(list(o)[0]), *list(o)[1:])
    except ImportError:
        print(*o)


def print_blue(*o):
    try:
        raise ImportError()    # fixme: colorama slows down
        from colorama import init, Fore
        init(autoreset=True)
        print(Fore.BLUE + str(list(o)[0]), *list(o)[1:])
    except ImportError:
        print(*o)
