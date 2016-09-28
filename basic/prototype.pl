#!/opt/ActivePerl5.24/bin/perl -w
# Exemple de prototype
#
#
use strict;
use warnings;
use v5.24;
use Test::TCP;
use Test::More;
use FindBin;


use autodie;


sub test_redis(&;$)  # syntax prototype
{
    chomp(my $redis_server = `which perl`); #doesn't work on windows
    unless ($redis_server && -e $redis_server && -x _)
    {
        plan skip_all => 'perl not found in your PATH'
    }
    my $dir = $FindBin::Bin;
    print $dir;
}

sub test
{
    print "test";
}
my $mytest = 3;

test_redis(\&test,$mytest);