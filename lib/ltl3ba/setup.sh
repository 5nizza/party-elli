#!/bin/bash

tar xvfz ltl3ba-1.0-modified.tar.gz
tar xvfz buddy-2.4.tar.gz

cd buddy-2.4
./configure --includedir=$PWD/output/include --libdir=$PWD/output/lib
make
make install
cd ..

cd ltl3ba-1.0/
BUDDY_INCLUDE=../buddy-2.4/output/include BUDDY_LIB=../buddy-2.4/output/lib make

echo "Done!"
