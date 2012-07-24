from interfaces.ltl_spec import LtlSpec


def _remove_comments_in_ltl(text):
    return '\n'.join(filter(lambda l: l.strip().startswith('#') is False, text.split('\n')))



def _consume_new_lines_and_split_into_blocks(text):
    new_text = []
    splitted_text = [l for l in text.strip().split('\n') if l.strip() != '']

    crt = splitted_text[0]
    for l in splitted_text[1:]:
        if 'INPUT' in l or 'OUTPUT' in l or 'PROPERTY' in l:
            new_text.append(crt)
            crt = l
        else:
            crt += ' ' + l

    new_text.append(crt)

    return [l for l in new_text if l != '']


def parse_ltl(text):
    cleared_text = _remove_comments_in_ltl(text)
    blocks = _consume_new_lines_and_split_into_blocks(cleared_text)

    inputs = []
    outputs = []
    for l in blocks:
        if 'INPUT:' in l:
            i = l.replace('INPUT:', '').strip()
            inputs.append(i)
        elif 'OUTPUT:' in l:
            o = l.replace('OUTPUT:', '').strip()
            outputs.append(o)
        elif 'PROPERTY:' in l:
            p = l.replace('PROPERTY:', '').strip()
            property = p
        else:
            assert False, 'unknown input line: ' + l

    ltl_spec = LtlSpec(inputs, outputs, property)
    return ltl_spec
