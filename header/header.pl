#!/opt/ActivePerl5.24/bin/perl -w

use strict;
use warnings;

use Benchmark qw/cmpthese timethese/;
use Tie::File;


my @array;
my @sort_array;

## number one  load from file
sub One {
    tie @array , 'Tie::File', '/home/hme/table_employee.txt' or die "file not found\n";
}
## number two - an alphabetic sort
sub Two {
    @sort_array = sort @array;
}
## number three - display
sub Three {
    for my $i (@sort_array){
        print $i . "\n";
    }
}

## We'll test each one, with simple labels
timethese (
        -5,
        {   'Method One' => '&One',
            'Method Two' => '&Two',
            'Method Three' => '&Three'
        });
