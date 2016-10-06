#!/opt/ActivePerl5.24/bin/perl -w

use strict;
use warnings;
use v5.24;


#use Data::Dumper;


my @names = ('Apple', 'Banana', 'Grape');
my $last_one = pop @names;

say " 1 - $last_one";  #
say " 2- @names";     #

@names = qw(Foo Bar);
push @names, 'Moo';
print "3 - @names\n";     # Foo Bar Moo

my @others = ('Paul', 'Andre');
push @names, @others;
print "4 - @names\n";#


@names = ('Foo', 'Bar', 'Moo');
my $first = shift @names;
print " 5- $first\n";     # Foo
print " 6 - @names\n";     # Bar Moo


@names = ('Foo', 'Bar');
unshift @names, 'Moo';
print "7 - @names\n";     # Moo Foo Bar


my $var_names="Paul,Mary,John,Pierre";
@names = split(',',$var_names);
#say @names;
foreach  (@names)
{
    say $_;
}
my $values = join ('-',@names);
say $values;

my @sort_array = sort @names;
say @sort_array;

#=========== hash
my %data = ("john",45,'lisa',30,'pierre',40);
print "\$data{john}= $data{'john'}\n";
print "\$data{Lisa}= $data{'lisa'}\n";
print "\$data{pierre}= $data{'pierre'}\n";

#-- autre forme d'ecriture
%data = ('john'  => 45,
         'lisa'  => 30,
         'pierre'=> 40,
        );

@names = sort keys %data;
say @names;
my @values = sort values %data;
say @values;
$data{'test'}=55;
say sort keys %data;
delete $data{'lisa'};
say sort keys %data;





#------------------- Data dumper my array -------------
#print Dumper(@names);

#-----------------------------------------------------
#my @animals = ('chien', 'chat', 'lapin');

#my @values;
#push @values, \@animals;
#push @values, \@names;

#print Dumper(@values);




