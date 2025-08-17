#!/usr/bin/perl
# creates a number of job execution lines for submission to pbs

my $SERIESNAME = "single_sweep_hpc1";

for (my $N = 1; $N <= $300; $N++)
{
    my $runName = $SERIESNAME . $N;

    system "echo qsub pubs/$runName.pub";
    print $N;

}
