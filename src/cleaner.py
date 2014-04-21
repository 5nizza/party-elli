#!/usr/bin/env python3

states_with_tok = {'t1', 't2', 't3', 't4', 't5', 't6', 't7', 't8', 't9'}

removed = []
correct = []

with open('param_mealy_amba2_weak_short_reduced8-weakag0.dot') as file:
    for l in file.readlines():
        l = l.strip()
        if not l: continue
        if not l.startswith('"'): continue
        should_continue = False
        for s in states_with_tok:
            if l.startswith('"{0}"'.format(s)) and ('"prev' in l or '\\nprev' in l):
                removed.append(l)
                should_continue=True
                break
        if should_continue:
            continue

        if '"hburst0' in l or '\\nhburst0' in l or \
           '-hburst1' in l or \
           (('\\nhlock' in l or '"hlock' in l) and '-hbusreq' in l):
           #(('"hlock' in l or '\\nhlock' in l)): #or '\\nhlock' in l) and '-hbusreq' in l):
            removed.append(l)
            continue
        correct.append(l)

print('removed lines', '\n'.join(removed))

print()
print()
print('correct lines are\n', '\n'.join(correct))
