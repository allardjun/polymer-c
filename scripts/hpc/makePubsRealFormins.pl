#!/usr/bin/perl
# creates a number of job execution lines for submission to pbs
use strict;
use warnings;

my $SERIESNAME = "single_sweep_hpc1"; # command line

for (my $N = 1; $N <=300; $N++)
{
        my $runName =  $SERIESNAME . $N;

        open (FOOD, ">pubs/$runName.pub" );
        print FOOD << "EOF";

#!/bin/bash
#\$ -N $SERIESNAME
#\$ -t 1-64
#\$ -q free*,pub*,abio,bio
#\$ -ckpt restart
#\$ -e logs/
#\$ -o logs/

cd /pub/lynchks/polymer-c_runs

echo Running on host `hostname`
echo Time is `date`
echo Directory is `pwd`


#Run your executable
./metropolis.out parameters.txt $SERIESNAME.txt 0 1 $N -1 0 0 0

echo Finished at `date`

EOF
		close FOOD;
        }
