import spot
import buddy
from typing import Set, Dict

from helpers.str_utils import remove_from_str
from interfaces.automata import Label, LABEL_TRUE
from interfaces.expr import Signal


def parse_bdd(bdd:buddy.bdd,
              d:spot.bdd_dict,
              signal_by_name:Dict[str, Signal]=None) -> Set[Label]:
    """ Special cases: empty set for false, {LABEL_TRUE} for true """
    s = spot.bdd_format_set(d, bdd)
    # s is like: <cancel:0, grant:0, req:0, go:0><cancel:1, grant:0, req:1, go:0>

    if s == 'F':
        return set()
    if s == 'T':
        return {LABEL_TRUE}

    cube_tokens = s.split('><')
    cube_tokens = map(lambda ct: remove_from_str(ct, '>< '), cube_tokens)
    cube_labels = set()
    for ct in cube_tokens:
        # cancel:0, grant:0, req:0, go:0
        lit_tokens = ct.split(',')
        lit_tokens = map(lambda lt: remove_from_str(lt, ', '), lit_tokens)
        lbl = Label((signal_by_name[sig_name] if signal_by_name else Signal(sig_name),
                     bool(int(sig_val)))
                    for sig_name, sig_val in
                    map(lambda tok: tok.split(':'), lit_tokens))
        cube_labels.add(lbl)
    return cube_labels
    # TODO: use
    # https://mail.google.com/mail/u/0/#search/spot%40lrde.epita.fr/15aad79ccab74e5b
