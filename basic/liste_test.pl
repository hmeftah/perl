#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use v5.24;

use IO::File; #chargement d'un package

my @test = (1..5);
foreach  ( @test)
    {
        say $_;
    }
# Assign a list of array references to an array.
my @AoA = (
    [ "paul", "pierre" ],
    [ "george", "jeanne", "marc" ],
    [ "emile", "jean", "helene" ],
);

say $AoA[2][1];
say $AoA[2]->[1];
for my $i ( 0 .. $#AoA ) {
    for  my $j ( 0 .. $#{$AoA[$i]} ) {
        print "element $i $j is $AoA[$i][$j]\n";
    }
}
# ------------- par une variable intermediaire
for my $i ( 0 .. $#AoA ) {
    my $row = $AoA[$i];
    for  my $j ( 0 .. $#{$row} ) {
        print "element $i $j is $row->[$j]\n";
    }
}
#=============== open a file
my @lines;
open(DATA,'C:\perl_tutorial\perl\data_structure\txt\test.csv') or die "open failed\n";
while(<DATA>)
{
    chomp($_);
    print $_ ;
    @lines=split(',',$_);
    print @lines;
    foreach (@lines){
        say $_;
    }
}
open(DATA,'C:\perl_tutorial\perl\data_structure\txt\test.csv') or die "open failed\n";
my @data = <DATA>;
print @data;
my $nbr_ligne;
$nbr_ligne= @data;
print "\n$nbr_ligne\n";
print $data[0];

my $fhd;
open $fhd,'<','C:\perl_tutorial\perl\data_structure\txt\test.csv'
      or die "open failed\n";
close($fhd);
open $fhd,'>>','C:\perl_tutorial\perl\data_structure\txt\test.csv'
    or die "open failed\n";
print $fhd "\n1,2,3,4,5";
close($fhd);

$fhd= IO::File->new('>> C:\perl_tutorial\perl\data_structure\txt\test.csv')
    or die "open failed\n";


my $texte =<<'TEXT';
Debut----- test -------
rer,rere,rerewqw,qwqwq,ouiou1,2,3,4,5
fin
TEXT

print $texte;










#my @days = qw/Mon Tue Wed Thu Fri Sat Sun/;
#my @weekdays = @days[3,4,5];
#print "certains jours de la semaine @weekdays\n";


#my @nums = (1..20);
#print "Avant - @nums\n";
#splice(@nums, 5, 5, 21..25);
#print "Apres - @nums \n";

#my @fs =  (1..10);
#splice @fs, 3, 2;
#print "@fs";    # Doc Grumpy Happy Dopey Bashful


# test ternary
#my $name = "Jean";
#my $age = 10;
#my $status = ($age > 60 )? "est un senior" : "est un enfant";
#print "$name is - $status\n";






