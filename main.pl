#!/usr/bin/perl

use strict;

sub sayHello {
    print "Hello my name is @_ \n";
}

sayHello(qw(Hank Muxi));

my $simplexed = 0;

sub isDutSimplexed() {
    return 1;
}



