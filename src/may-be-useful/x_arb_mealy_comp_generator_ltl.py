spec_template = """
[spec_unit u{i}]
(g_{i}=0);
((((G((((X((r_{i}=0))) * (X((g_{i}=1)))) -> (X((X((r_{i}=0)))))))) * (G((((X((r_{i}=1))) * (X((g_{i}=0)))) -> (X((X((r_{i}=1))))))))) * (G((((X((r_{i}=1))) * (X((g_{i}=1)))) -> (X((X((r_{i}=0))))))))) -> (((G((((X((r_{i}=0))) * (g_{i}=0)) -> (X((g_{i}=0)))))) * (G(((X((r_{i}=1))) -> (X((F((g_{i}=1))))))))) * (G((((X((r_{i}=1))) * (X((g_{i}=1)))) -> (((X((X((g_{i}=1))))) * (X((X((X((g_{i}=1)))))))) * (X((X((X((X((g_{i}=0)))))))))))))));
"""

mutual_exclusion="""(G((!(((g_{i}=1) * (g_{j}=1))))));"""


import sys

if __name__ == '__main__':
    number_of_units = int(sys.argv[1])

    for i in range(number_of_units):
        print(spec_template.format(i=i))
        for j in set(range(number_of_units)).difference({i}):
            print(mutual_exclusion.format(i=i,j=j))
