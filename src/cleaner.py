#!/usr/bin/env python3

states_with_tok = set('t'+str(i) for i in range(1,20))

removed = []
correct = []

with open('full-reduced0.dot') as file:
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

        if (('\\nhlock' in l or '"hlock' in l) and ('-hbusreq' in l)):
            removed.append(l)
            continue
        correct.append(l)

print('removed lines', '\n'.join(removed))

print()
print()
print('correct lines are\n', '\n'.join(correct))
# burst
      #     ('-hburst0' in l or '-hburst1' in l):



           # locked req
           # ('-hlock' in l and ('"hbusreq' in l or '\\nhbusreq' in l)) or \

           # 
           #(('"noreq' in l or '\\nnoreq' in l) and ('"hbusreq' in l or '\\nhbusreq' in l)) or \

           # consequence
           #(('\\nhlock' in l or '"hlock' in l) and ('"noreq' in l or '\\nnoreq' in l)) or \

           #incremental
           #('\\nhburst0' in l or '"hburst0' in l or '-hburst1' in l):

#'-hburst1' in l or \
#           ('-hburst0' in l and ('-nhlock' in l and ('"hbusreq' in l or '\nhbusreq' in l))) or\



           #('-nhlock' in l and ('"hbusreq' in l or '\nhbusreq' in l)):
