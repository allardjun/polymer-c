#!/bin/bash

##############################################
# Concatenate output files of driveMetropolis for N sweep
# command line arguments: location of data files, location of output file, name of output file, first part of file name format, second part of file name format, fist part of folder name format, second part of folder name format, N start, N end
##############################################

# Set up variables
DATALOC="$1"
OUTLOC="$2"
OUTFILENAME="$3"
DATAFILESTART="$4"
DATAFILEEND="$5"
DATAFOLDERSTART="$6"
DATAFOLDEREND="$7"
N_start=$8
N_end=$9

echo "the location of the data files is: $1"
echo "the location of the output lookup table is: $2"
echo "the name of the output lookup table is: $3"
echo "the data file name format is: $4i$5"
echo "the data folder name format is: $6i$7"
echo "the N values range from: $8-$9"

##############################################
cd ${OUTLOC}
> ${OUTFILENAME}
echo "${OUTFILENAME} created"

for NumSeg in $(seq $8 $9)
do
echo "starting N${NumSeg}"
cd ${DATALOC}/${DATAFOLDERSTART}${NumSeg}${DATAFOLDEREND}
cp ${DATAFILESTART}${NumSeg}${DATAFILEEND} ${OUTLOC}
echo "N${NumSeg} copies to ${OUTLOC}"
cd ${OUTLOC}
cat ${DATAFILESTART}${NumSeg}${DATAFILEEND} >> ${OUTFILENAME}
echo "N${NumSeg} added to ${OUTFILENAME}"
rm ${DATAFILESTART}${NumSeg}${DATAFILEEND}
echo "N${NumSeg} file removed from ${OUTLOC}"
done




