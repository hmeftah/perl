#!/opt/ActivePerl5.24/bin/perl -w

use Modern::Perl '2015';
use strict;    # force to use local or global variable by using "my" or "our".
use Carp;      # carp gives you more info as to  where the message comes from (context)
use warnings;  # detect all warnings

use v5.24;     # force this script to use the right Perl version and promote say and other keywords.
#  implies "use strict"

# TODO Have a look to perldoc to find out how to use the following packages.

use constant IS_DOS  =>($^O eq 'MSWin32');

my @PATHEXT =(' ');
if (IS_DOS){
    if ($ENV{PATHEXT}){
        push @PATHEXT, split ';', $ENV{PATHEXT};
    }
    else {
        push @PATHEXT,qw{.com .exe .bat};
    }
}

use File::Which qw(which where);

my $exe_path = which 'perldoc';
my @paths = where 'perl';

print $exe_path, "\n";
print @paths;
