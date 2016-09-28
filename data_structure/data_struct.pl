#!/opt/ActivePerl5.24/bin/perl -w

use strict;
use warnings;

my @names = ('Apple', 'Banana', 'Grape');
my $last_one = pop @names;

print "$last_one\n";  #
print "@names\n";     #

@names = ('Foo', 'Bar');
push @names, 'Moo';
print "@names\n";     # Foo Bar Moo

my @others = ('Darth', 'Vader');
push @names, @others;
print "@names\n";


@names = ('Foo', 'Bar', 'Moo');
my $first = shift @names;
print "$first\n";     # Foo
print "@names\n";     # Bar Moo


@names = ('Foo', 'Bar');
unshift @names, 'Moo';
print "@names\n";     # Moo Foo Bar

@others = ('Darth', 'Vader');
unshift @names, @others;
print "@names\n";
