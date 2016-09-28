#!/opt/ActivePerl5.24/bin/perl -w
use strict;
use warnings FATAL => 'all';

use utf8;

use Word::Anagram;
use Tie::File;

$| = 1;


my $obj = Word::Anagram->new;

my $word = '';
my $anag = $obj->get_anagrams_of($word); # return an array ref
my @array = @{$anag};
print  scalar @array;
