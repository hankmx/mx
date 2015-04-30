#!/usr/bin/perl

#####################################################
# Function: _waitForAllNodes()
#
# Parameters:
#   timeout - Maximum time to wait for all nodes join the cluster
#   fatal - If set to 1, throw exception on failure that is caught by fttest
#   imageSimplex - if set to 0, no need wait for the second node
#
# Returns:
#   0 - Success. All expected nodes have joined the cluster
#   1 - Failure.
#####################################################
sub _waitForAllNodes() {
    my $self = shift or die("%Error: Cannot call without a valid object!\n");
    my %args = ( timeout => '10m',
                 fatal => 1,
                 imageSimplex => 0,
                 @_ );
   
    # no need wait if only 1 node is required or already have 2 nodes on DUT.
    return 0 if ( $args{imageSimplex} || not $self->isDutSimplexed() );

    $self->{logger}->trace("waitForAllNodes: ...started ($args{timeout})\n");

    my $start = time();
    my $deadline = Deadline->new();
    $deadline->init(fatal=>1, timeout=>$args{timeout});

    while ( not $deadline->isExpired(%args, msg=>"Second node did not join the cluster.\n", sleep=>30) ) {
        if ( not $self->isDutSimplexed() ) {
            my $timeString = secsToTime((time() - $start));
            $self->{logger}->trace("waitForAllNodes: Completed in $timeString\n");
            return 0;    
        } else {
            $self->{logger}->debug("…waiting for second node to join the cluster.\n");
        }
    }
    
    return 1;
}
