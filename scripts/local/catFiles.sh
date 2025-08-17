##############################################
# Concatenate log, output files
# Tar individual files
# 08 02 2019

##############################################
# Set up variables
ITERMIN=-1
ITERMAX=103

I2MAX=64

FOLDERNAME="StiffenRange"
FILENAME="CD3ZetaMembrane0"
LOGFILENAME="o*"

##############################################
##############################################
##############################################
# Make cat folders

# start in code part of folder
if [[ ! -d "CatFiles" ]];
then
    mkdir CatFiles

    cd CatFiles

    mkdir CatLogs

    mkdir MissingFiles

    cd ..
fi

echo "We are here: $PWD"

# end in code part of folder

##############################################
##############################################

# Concatenate log files
for ((ITER=$ITERMIN;ITER<=$ITERMAX;ITER++))
do
    cd $FOLDERNAME.$ITER/logs


    if [[ ! -e "$FILENAME.$ITER.log" ]];
    then
        for ((I2=1;I2<=$I2MAX;I2++))
        do
                if [[ 0 -lt $(ls $FILENAME.$LOGFILENAME.$I2 2>/dev/null | wc -w) ]];
                    then
                        TEMPFILENAME="$(ls $FILENAME.$LOGFILENAME.$I2)"
                        echo -e "/************************/\n\n" >> $FILENAME.$ITER.log
                        echo -e "$TEMPFILENAME\n" >> $FILENAME.$ITER.log
                        cat $TEMPFILENAME >> $FILENAME.$ITER.log
                else
                        echo -e "Log file $FILENAME.$LOGFILENAME.$I2 does not exist.\n"
                fi

        done

        cp $FILENAME.$ITER.log ../../CatFiles/CatLogs/

        echo "Finished concatenating log file $ITER."
    fi

    cd ../..
done

# wait for all background processes to finish before concatenating files
wait

echo "Done concatenating log files."

echo "We are here: $PWD"

##############################################
##############################################

# Concatenate output files
for ((ITER=$ITERMIN;ITER<=$ITERMAX;ITER++))
do
    cd $FOLDERNAME.$ITER

    echo "We are here: $PWD"

    if [[ ! -e "$FILENAME$FOLDERNAME.$ITER.cat" ]];
    then

        for ((I2=1;I2<=$I2MAX;I2++))
        do
            if [[ -e "$FILENAME$FOLDERNAME.$ITER.$I2" ]];
                then
                    cat $FILENAME$FOLDERNAME.$ITER.$I2 >> $FILENAME$FOLDERNAME.$ITER.cat
            else
                    echo -e "$FILENAME$FOLDERNAME.$ITER.$I2\n" >> MissingFiles.$ITER
            fi

        done

        if [[ "$(wc -l < $FILENAME$FOLDERNAME.$ITER.cat)" -gt "$I2MAX" ]];
           then
               echo -e "Too many lines in cat file $FILENAME.$ITER.cat.\n" >> ../CatFiles/CatFiles.err
        fi

        if [[ "$(wc -l < $FILENAME$FOLDERNAME.$ITER.cat)" -lt "$I2MAX" ]];
            then
                echo -e "Missing lines in cat file $FILENAME.$ITER.cat.\n" >> ../CatFiles/CatFiles.err
        fi

        cp $FILENAME$FOLDERNAME.$ITER.cat ../CatFiles/

        if [[ -e MissingFiles.$ITER ]];
        then
            cp MissingFiles.$ITER ../CatFiles/MissingFiles/
        fi

        echo "Finished concatenating output files $ITER."
    fi

    cd ..

done

echo "Done concatenating output files."

echo "We are here: $PWD"

##############################################
##############################################

# Tar individual output files into single folder

if [[ ! -e "$FOLDERNAME.$ITER.tar.gz" ]];
then

    for ((ITER=$ITERMIN;ITER<=$ITERMAX;ITER++))
    do

        tar -czvf $FOLDERNAME.$ITER.tar.gz $FOLDERNAME.$ITER/

    done

fi

if [[ ! -e "Data_IndividualFiles.tar.gz" ]];
then
    tar -czvf Data_IndividualFiles.tar.gz $FOLDERNAME.*.tar.gz
fi

echo "Finished archiving files."

##############################################
##############################################

# Remove non archived files

echo "We are here: $PWD"

if [[ -e "Data_IndividualFiles.tar.gz" ]];
then
    for ((ITER=$ITERMIN;ITER<=$ITERMAX;ITER++))
    do
        if [[ -e "$FOLDERNAME.$ITER.tar.gz" ]];
        then

            rm -rf $FOLDERNAME.$ITER/

            rm $FOLDERNAME.$ITER.tar.gz

        fi

    done
fi


