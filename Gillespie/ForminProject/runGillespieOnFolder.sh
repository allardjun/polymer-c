#!/bin/bash
folder=$1
echo "folder: ${folder}"
timecount=$2
echo "time: ${timecount}"
timeavg=$3
echo "time avg: ${timeavg}"

ogdir=$PWD
cd ${folder}
for construct in *; do
    ifolder="${folder}/${construct}"
    numValidStates=$(wc -l < "${ifolder}/states.txt")
    iSiteTotal=$(head -n 1 "${ifolder}/states.txt" | tr ',' '\n'| wc -l)
    cd ${ogdir}
    ./gillespie.out ${ifolder}/TM.txt ${ifolder}/states.txt ${numValidStates} ${iSiteTotal} ${timecount} ${ifolder}/TMout_${timecount}_${timeavg}.txt ${timeavg}
done

