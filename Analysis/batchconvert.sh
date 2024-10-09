#!/bin/bash

##############################################
# Convert all legacy output files in a folder to modern output
# Renames legacy outputs to name_legacy.txt and saves the modern output
# files as name.txt. If only a live output is present, the live output file
# remains and a new modern output file is generated based on the last line
# and saved as name_last_modern.txt
#
# assumes file organization: folder/run.(type).N(N)_(date)/output_*
#                            folder/run.(type).N(N)_(date)/live_output_*
#
# command line arguments: folder, submodel
##############################################

FOLDER="$1" # folder to search
TYPE="$2" # single, double, dimer

for fold in ${FOLDER}/*
do
  N=$(echo $fold | sed 's|'"${FOLDER}"\/'||'| sed 's/'run."${TYPE}".N'//'| sed 's/_.*//')
  #echo $N
  if ls ${fold}/output_*.txt 1> /dev/null 2>&1; then
    for file in ${fold}/output_*.txt
    do
      fname=$(echo $file | sed "s/.txt//")
      mv ${file} "${fname}_legacy.txt"
      python3 legacy_to_modern.py "${fname}_legacy.txt" ${file} ${N}
      echo "N:${N} output file converted"
    done
  elif ls ${fold}/live_output_*.txt 1> /dev/null 2>&1; then
    for file in ${fold}/live_output_*.txt
    do
      tail -n 1 ${file} > "${file}_temp_live_oneline.txt"
      fname=$(echo $file | sed "s/.txt//")
      python3 legacy_to_modern.py "${file}_temp_live_oneline.txt" "${fname}_last_modern.txt" ${N}
      rm "${file}_temp_live_oneline.txt"
      echo "N:${N} live output file converted"
    done
  else
    echo "no output or live_output file exists in ${fold}"
  fi
done
