#!/bin/bash

# This is a benchmark framework which might be useful for evaluating
# bounded synthesis tools developed for the lecture
#   AK Design and Verification 2012
# at the
#   Institute for Applied Information Processing and Communications,
#   Graz University of Technology.
#
# Version: 1.0.0
# Created by Robert Koenighofer, robert.koenighofer@iaik.tugraz.at

DIR=`dirname $0`/

# Your tool will probably call ltl2ba and Z3. If these tools are not
# in your path by default, you can add them here:
#PATH=$PATH:/path_to_ltl2ba:/path_to_z3

# If you run this scritp on the cluster, uncomment the following line:
#PATH=$PATH:/workstore/akdv12/bin/ltl2ba:/workstore/akdv12/bin/z3


# Change the following line to invoke your solver.
# You can use ${DIR} (which contains the path to the
# parent directory of this script) to specify the path.
# $1 contains the input filename (the name of the LTL-file).
# $1 contains the output filename (the name of verilog file to create).
COMMAND="echo \"call_synth_tool.sh called with parameters $1 $2.\""


#other examples:
# COMMAND="${DIR}../bin/my_synth_tool --in=$1 --out=$2"
# COMMAND="${DIR}../../bin/my_tool --input=$1 --verbose=0 -whatever_option"

# In the end, calling this script with two filenames as parameters
# should make your tool start synthesizing the spec in the first file. 

#echo $COMMAND
$COMMAND
