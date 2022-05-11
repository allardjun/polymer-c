#!/bin/bash
#./metropolis.out parameters.txt outputfile verboseTF NFil N iSite baseSepDist Force dimerForce

d=`date +%Y.%d.%m`


#Edit these parameters:
for NumSeg in $(seq 1 122)
do
what='dimer' #'single' 'double'
NFil=2 #2
#NumSeg=${i} #single=300; double=200; dimer=122
if [ ${NFil} -eq 2 ]
then
	baseSepDist=16.667000
else
  baseSepDist=0
fi;
dimerForce=10 #0
iSite='-1'
force=0
#


#echo submit.${what}.N${NumSeg}.${d}.sh

cp testsubmit.sh submit.${what}.N${NumSeg}.${d}.sh
sed -i "34c\ ./metropolis.out parameters.txt output_${what}.N${NumSeg}.iSite${iSite}.BSD${baseSepDist}.force${force}.kdimer${dimerForce}.txt 0 ${NFil} ${NumSeg} ${iSite} ${baseSepDist} ${force} ${dimerForce}
" "submit.${what}.N${NumSeg}.${d}.sh"
done


cd /u/home/k/katiebog/Data/
mkdir dimer.${d}

for NumSeg in $(seq 1 122)
do
cd /u/home/k/katiebog/Data/dimer.${d}
mkdir run.${what}.N${NumSeg}_${d}
cd /u/home/k/katiebog/test/src/PolymerCode
cp metropolis.out parameters.txt ISEED submit.${what}.N${NumSeg}.${d}.sh /u/home/k/katiebog/Data/dimer.${d}/run.${what}.N${NumSeg}_${d}
cd /u/home/k/katiebog/test/src/PolymerCode
rm submit.${what}.N${NumSeg}.${d}.sh
done

for NumSeg in $(seq 1 122)
do
cd /u/home/k/katiebog/Data/dimer.${d}/run.${what}.N${NumSeg}_${d}
qsub ./submit.${what}.N${NumSeg}.${d}.sh
done
