#!/usr/bin/perl
use strict;
use warnings FATAL =>'all';
use v5.24;


sub hello {
    my $name = shift;
    my $last_name= shift;
    say " Hello $name-$last_name";
}

sub average{
    my $n = scalar(@_);
    my $sum = 0;
    foreach (@_){
        $sum +=$_;
    }
    my $average =$sum/$n;
    print "la moyenne est de : $average";
}

hello("John","Paul");
average(10,20,30, 100, 150);
my $mysub=sub{print my $state};
print $mysub;

