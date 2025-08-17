#!/usr/bin/perl
# creates a number of job execution lines for submission to pbs
use strict;
use warnings;

my $seriesName = "CD3ZetaElectrostaticsPhosphorylation"; # command line
my $occupiediSitesFile = 'OccupiediSitesMouse.txt';
my $occupiediSitesFileNoSpace = 'OccupiediSitesMouseNoSpace.txt';

my $i0Max = 3;
my $i1Max = 3;

for (my $i0 = 1; $i0 <= $i0Max; $i0++)
{
	my $PARABOLADEPTH = 10**(0.5*($i0-1));

	for (my $i1 = 1; $i1 <= $i1Max; $i1++)
	{
		my $PARABOLAWIDTH = 10**(-1+0.5*($i1-1));
        
        my $fileName = $seriesName . "ParabolaDepth" . "." . $i0 . "." . "ParabolaWidth" . "." . $i1 ;
        my $runName =  $fileName . ".pub";

        open (FOOD, ">pubs/$runName" );
        print FOOD << "EOF";

#!/bin/bash
#\$ -N $seriesName
#\$ -t 1-64
#\$ -q free*,pub*,abio,bio
#\$ -ckpt restart
#\$ -e logs/
#\$ -o logs/

cd /pub/laraclemens/polymer-c_runs/Mar212017ElectrostaticsPhosphorylation

echo Running on host `hostname`
echo Time is `date`
echo Directory is `pwd`

OCCUPIEDFILE=$occupiediSitesFile
OCCUPIED=\$(awk "NR==\$SGE_TASK_ID" \$OCCUPIEDFILE)

OCCUPIEDNOSPACEFILE=$occupiediSitesFileNoSpace
OCCUPIEDNOSPACE=\$(awk "NR==\$SGE_TASK_ID" \$OCCUPIEDNOSPACEFILE)

# Run your executable
if [ ! -e $fileName.\$SGE_TASK_ID ]
    then
    ./metropolis.out parameters.txt $fileName.\$SGE_TASK_ID \$OCCUPIED \$OCCUPIEDNOSPACE $PARABOLADEPTH $PARABOLAWIDTH
fi

echo Finished at `date`

EOF
		close FOOD;
        }
}
