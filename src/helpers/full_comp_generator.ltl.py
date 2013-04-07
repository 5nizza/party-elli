spec_template = """
[spec_unit u{i}]
(!((((r_{i}=0) * (g_{i}=0)) U ((r_{i}=0) * (g_{i}=1)))));
(!((F((((g_{i}=1) * (X(((r_{i}=0) * (g_{i}=0))))) * (X((((r_{i}=0) * (g_{i}=0)) U ((g_{i}=1) * (r_{i}=0))))))))));
(G((((r_{i}=0) * (g_{i}=1)) -> (F((((r_{i}=1) * (g_{i}=1)) + (g_{i}=0)))))));
(G(((r_{i}=1) -> (F((g_{i}=1))))));
"""

mutual_exclusion="""(G((!(((g_{i}=1) * (g_{j}=1))))));"""


import sys

number_of_units = int(sys.argv[1])

for i in range(number_of_units):
    print(spec_template.format(i=i))
    for j in set(range(number_of_units)).difference({i}):
        print(mutual_exclusion.format(i=i,j=j))
