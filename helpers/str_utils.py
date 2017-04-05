from typing import Iterable


def remove_from_str(s:str, tokens_to_rm:Iterable[str]) -> str:
    for t in tokens_to_rm:
        s = s.replace(t, '')
    return s