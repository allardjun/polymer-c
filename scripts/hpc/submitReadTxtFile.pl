#!/usr/bin/perl
# creates a number of job execution lines for submission to pbs

my $seriesName = "CD3ZetaElectrostaticsRwall6"; # command line

my $i0Max = 13;
my $i1Max = 13;

for (my $i0 = 1; $i0 <= $i0Max; $i0++)
{
    for (my $i1 = 1; $i1 <= $i1Max; $i1++)
    {
            my $runName = $seriesName . "WellDepth" . "." . $i0 . "Debye" . "." . $i1 . ".pub";
			system "qsub pubs/$runName";

			print $i1;
        
    }
}
