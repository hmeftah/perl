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

use Data::Dumper;

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

 print "\n";

#--------------------------------------------------------------------------------------------
my %good_opt = map {$_ => 1, "-$_" => 1}
    qw(memory dw_size mode recsep discipline autodefer autochomp autodefer_threshhold concurrent);

print Dumper(%good_opt);


