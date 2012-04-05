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

# This directory:
DIR=`dirname $0`/

# Maybe change the following line to point to GNU time:
GNU_TIME="/usr/bin/time"

# Time limit in seconds:
TIME_LIMIT=60
# Memory limit in kB:
MEMORY_LIMIT=2000000

# The directory where the benchmarks are located:
BM_DIR="${DIR}benchmarks/"

# The benchmarks to be used.
# The files have to be located in ${BM_DIR}.
FILES=(
       s0
       s1
       count1
       count2
       count3
       count4
       count5
       count6
       count7
       handshake1
       handshake2
       handshake3
       handshake4
      )

CALL_SYNTH_TOOL=${DIR}call_synth_tool.sh
TIMESTAMP=`date +%s`
RES_TXT_FILE="${DIR}results/results_${TIMESTAMP}.txt"
RES_DIR="${DIR}results/results_${TIMESTAMP}/"
mkdir -p "${DIR}results/"
mkdir -p ${RES_DIR}

{ ulimit -m ${MEMORY_LIMIT} -v ${MEMORY_LIMIT} -t ${TIME_LIMIT} &&\
  for element in $(seq 0 $((${#FILES[@]} - 1))) ; do \
     file_name=${FILES[$element]}  &&\
     correct_sat=${FILES[$element+1]} &&\
     echo -e "running " $file_name " ..." &&\
     echo -e "=====================" $file_name "=====================" 1>> $RES_TXT_FILE  &&\
     ${GNU_TIME} --output=${RES_TXT_FILE} -a -f "Time: %e sec (Real time)" ${CALL_SYNTH_TOOL} ${BM_DIR}${file_name}.ltl ${RES_DIR}${file_name}.v   &&\
     sleep 1 ;\
  done ;
} \





