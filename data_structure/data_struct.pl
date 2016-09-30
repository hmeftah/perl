#!/opt/ActivePerl5.24/bin/perl -w

use strict;
use warnings;

use Data::Dumper;


my @names = ('Apple', 'Banana', 'Grape');
my $last_one = pop @names;

print " 1 - $last_one\n";  #
print " 2- @names\n";     #

@names = ('Foo', 'Bar');
push @names, 'Moo';
print "3 - @names\n";     # Foo Bar Moo

my @others = ('Darth', 'Vader');
push @names, @others;
print "4 - @names\n";


@names = ('Foo', 'Bar', 'Moo');
my $first = shift @names;
print " 5- $first\n";     # Foo
print " 6 - @names\n";     # Bar Moo


@names = ('Foo', 'Bar');
unshift @names, 'Moo';
print "7 - @names\n";     # Moo Foo Bar

@others = ('Darth', 'Vader');
unshift @names, @others;
print " 8 - @names\n";

#------------------- Data dumper my array -------------
#print Dumper(@names);

#-----------------------------------------------------
my @animals = ('chien', 'chat', 'lapin');

my @values;
push @values, \@animals;
push @values, \@names;

print Dumper(@values);




