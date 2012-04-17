#!/bin/sh
wget http://www.lsv.ens-cachan.fr/~gastin/ltl2ba/ltl2ba-1.1.tar.gz
tar xvfz ltl2ba-1.1.tar.gz
rm ltl2ba-1.1.tar.gz
cd ltl2ba-1.1
make 
cd ..

