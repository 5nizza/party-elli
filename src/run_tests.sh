#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Provide the encoding"
  exit 0
fi

ENCODING=$1

TOOL="/home/ayrat/projects/party-gr1/src/elli.py --encoding $ENCODING"

FILES=(
./benchmarks/pnueli_arbiter_2.py
./benchmarks/pnueli_arbiter_3.py
./benchmarks/pnueli_arbiter_4.py
./benchmarks/pnueli_arbiter_5.py
./benchmarks/elevator_2.py
./benchmarks/elevator_3.py
./benchmarks/elevator_4.py
./benchmarks/elevator_5.py
./benchmarks/elevator_6.py
)


TIME_LIMIT=1200  # seconds
MEMORY_LIMIT=20000000  # kB


GNU_TIME=/usr/bin/time

DIR=`dirname $0`/
TIMESTAMP=`date +%s`
RES_DIR="${DIR}/results"
RES_TXT_FILE="${RES_DIR}/timings_${ENCODING}_${TIMESTAMP}.txt"
mkdir -p "${RES_DIR}"
TIMEOUT=timeout


#ulimit -m ${MEMORY_LIMIT} -v ${MEMORY_LIMIT} -t ${TIME_LIMIT} -T 1
for f in "${FILES[@]}"
do
  F_FILE_NAME="${f##*/}"
  LOG_FILE_NAME=${RES_DIR}/${ENCODING}_${F_FILE_NAME}_${TIMESTAMP}.log
  DOT_FILE_NAME=${RES_DIR}/${ENCODING}_${F_FILE_NAME}_${TIMESTAMP}.dot
  echo "writing log to " $LOG_FILE_NAME " and dot to " $DOT_FILE_NAME
  echo -e "\n Synthesizing ${f} ..." | tee -a $RES_TXT_FILE

  ARGS="-vvv --moore --dot ${DOT_FILE_NAME}.dot --tmp --log ${LOG_FILE_NAME}"
  #${GNU_TIME} --quiet --output=${RES_TXT_FILE} -a -f "Synthesis time: %e sec (Real time)/ %U sec (User CPU time)" $TOOL $ARGS $f
  ${GNU_TIME} --quiet --output=${RES_TXT_FILE} -a -f "Synthesis time: %e sec (Real time)/ %U sec (User CPU time)" ${TIMEOUT} ${TIME_LIMIT} $TOOL $ARGS $f

   exit_code=$?

   #if [[ $exit_code == 137 ]];
   if [[ $exit_code == 124 ]];
   then
     echo "  Timeout!" | tee -a $RES_TXT_FILE
   fi

done
