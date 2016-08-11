# Parallelization Script
# July 13, 2016

NRequested=0            # initialize number of runs submitted

NRODS=143

IRATIO=1

BRATIO=4

FORCE=0

VERBOSE=1

TESTRUN=0 # 0 = not test run, use first set of hardcoded iSites, 1 and 2 - use test run iSites

ITERATIONS=1


#########You can ignore these parameters###########

#DELIVERYDISTANCE=$IRATIO

#DELIVERYMETHOD=1 # 0 = test if ligand intersects base ligand site, 1 = test if within delivery distance

#COMMANDISITES=0 # 0=use hardcoded iSites 1 = use user input iSites 2 = read in from file

#ISITETOTAL=4

ISITELOCATION=-1

BSITELOCATION=0


STIFFENRANGE=0 # -1 means don't stiffen

#####################################################

TOTALITERATIONS=1 #for testing

#TOTALITERATIONS=`wc -l < PhosphorylatediSites.txt`

echo "Length of file is $TOTALITERATIONS"

    # set number of runs submitted by checking the running processes for lines with the program name, set NRequested to number of lines (may include one more than actual number of runs, since it counts grep -c metropolis in its tally)

NRequested=`ps | grep -c metropolis`

# while number of iterations ran is less than or equal to total number of iterations desired, loop through runs

#for ((BRATIO=0;BRATIO<=14;BRATIO++))
#do

#echo "bRatio = $BRATIO"

ITERATIONS=1

while (( $ITERATIONS <= $TOTALITERATIONS ))
    do

    # loop to periodically check how many runs are submitted

    while (( $NRequested >= $1 ))   # while number requested is greater than number of processors we want to use (user input in command line)

        do
            sleep 1     # wait 1 sec before checking again

            NRequested=`ps | grep -c metropolis` # check again

    done

        echo "Done sleeping."

    # loop to submit more runs until reach max number of processors we want to use ($1)

    while (( $NRequested < $1 && $ITERATIONS <= $TOTALITERATIONS ))
        do

###############Ignore these lines - used for Stiffening.  Currently still in input, so need to be read, but otherwise can be ignored.###############
            # read specified line of text file
#
#            STIFFISITES="`awk 'NR==iter' iter=$ITERATIONS PhosphorylatediSites.txt`"
#
#            STIFFISITESNOSPACE="`awk 'NR==iter' iter=$ITERATIONS PhosphorylatediSitesNoSpace.txt`"

            # print to screen the line read
            echo "Line $ITERATIONS of file is $STIFFISITES"
################################

            # run program with specified parameters

            ~/Documents/polymer-c_runs/metropolis.out StiffenTestN14ReeDist $NRODS $IRATIO $BRATIO $FORCE $VERBOSE $TESTRUN $ISITELOCATION $BSITELOCATION "0 1 0 1 0 1 0 1 0 1 0 1 0 1" $STIFFENRANGE "01010101010101" &

            # If user gives V or v as second command line argument, then code will be verbose. Any other input will result in non-verbose.
            if [[ $2 == "V" || $2 == "v" ]]
                then
                    # print to screen the process ID and the name of the run
                    echo "PID of MultipleBinding.$ITERATIONS is $!"
            fi

            # update number of running programs
            NRequested=`ps | grep -c metropolis`

            # increase iteration run by 1
            ITERATIONS=$(( ITERATIONS + 1 ))
    done
            echo "Done calling metropolis."
done
#done


## wait for all background processes to finish before concatenating files
#wait
#
#echo "Done waiting for processes to finish."

## loop through all files, concatenate them into one file
# for ((BRATIO=0; BRATIO<=14; BRATIO++))
# do
#
##IT=1
##
##for ((IT=1; IT<=$TOTALITERATIONS; IT++))
##do
##
#cat MultipleBindingTestReeN50bSitesTotal4.$BRATIO >> MultipleBindingTestReeN50bSitesTotal4.cat.txt
##
##done
#done