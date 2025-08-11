#!/bin/bash

##############################################
# Concatenate output or liveoutput files of driveMetropolis for N sweep
# command line arguments: location of data files, location of output file, name of output file, fist part of folder name format, N start, N end
##############################################

# Set up variables
DATALOC="$1"
OUTLOC="$2"
OUTFILENAME="$3"
DATAFOLDERSTART="$4"
N_start=$5
N_end=$6

echo "the location of the data files is: $1"
echo "the location of the output lookup table is: $2"
echo "the name of the output lookup table is: $3"
echo "concatenate files in folders: $4*"
echo "the N values range from: $5-$6"

##############################################
cd ${OUTLOC}
mkdir temp
cd temp
> ${OUTFILENAME}
echo "${OUTFILENAME} created"

for NumSeg in $(seq $5 $6)
do
echo "starting N${NumSeg}"
cd ${DATALOC}/${DATAFOLDERSTART}${NumSeg}*
if ls output_*.txt; then
	cp output_*.txt ${OUTLOC}temp/${NumSeg}.txt
  echo "N${NumSeg} output copied to ${OUTLOC}temp/"
  cd ${OUTLOC}temp/
  cat ${NumSeg}.txt >> ${OUTFILENAME}
  echo "N${NumSeg} added to ${OUTFILENAME}"
  #rm ${NumSeg}.txt
  echo "N${NumSeg} output file removed from ${OUTLOC}temp/"
elif ls live_output_*.txt; then
  cp live_output_*.txt ${OUTLOC}temp/${NumSeg}.txt
  echo "N${NumSeg} live script copied to ${OUTLOC}temp/"
  cd ${OUTLOC}temp/
  tail -1 ${NumSeg}.txt >> ${OUTFILENAME}
  echo "N${NumSeg} added to ${OUTFILENAME}"
  #rm ${NumSeg}.txt
  echo "N${NumSeg} live script file removed from ${OUTLOC}temp/"
fi
done
mv ${OUTFILENAME} ${OUTLOC}/
cd ${OUTLOC}
wc ${OUTFILENAME}
#rmdir temp/
