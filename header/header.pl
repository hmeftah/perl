#!/opt/ActivePerl5.24/bin/perl -w

use strict;
use warnings;

use File::Which;
use File::Spec ();

our $VERSION='1.00';

use constant IS_DOS => ($^O eq 'MSWin32' or $^O eq 'dos' or $^O eq 'os2');

if (IS_DOS){

}