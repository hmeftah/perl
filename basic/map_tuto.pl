#!/opt/ActivePerl5.24/bin/perl -w
use strict;
use warnings FATAL => 'all';


use Data::Dumper qw(Dumper);


my @names = qw(jean paul pierre);
my %is_invited = map {$_ => 1} @names;

prompt();

sub prompt{

     print "Nom : ";
     my $visitor = <STDIN>;
     chomp $visitor;

     if ($is_invited{$visitor}) {
     print "Le visiteur $visitor a un badge valide\n";
    }
    else
    {
        print "pas valide";
    }

    #print Dumper \%is_invited;

}

#=======================================================
#
# The is more than one way to do it
# TIMTOWTDI
# TIM TOWADY
#======================================================

my @numbers = (1..10);
my @tripled = ();
for (my $i = 0; $i < scalar (@numbers); $i++)
{
    $tripled[$i] = $numbers[$i] * 3;
}
#print Dumper \@tripled;

@tripled = ();
for my $num (@numbers) {
    push @tripled, $num * 3;
}

@tripled = ();
foreach  (@numbers)
{
    push @tripled, $_ * 3;
}
#print Dumper \@tripled;



#print @tripled;

@tripled = ();
@tripled = map { $_ * 3 } @numbers;
#print Dumper \@tripled;


#==========================================

my @values= qw ( jean paul pierre rene georges joel);
splice @values ,3,2;
print Dumper \@values;

@values= qw ( jean paul pierre rene georges joel);
my @insert = qw ( gaelle  victor pauline);
splice @values ,3, @insert;
print Dumper \@values;




@numbers = (1..10);
@tripled = ();
for (my $i = 0; $i <= $#numbers; $i++)
{
    $tripled[$i] = $numbers[$i] * 3;
}
print @tripled;


#faire la meme chose avec
#                    push


my $datetime = localtime();
print $datetime;
$datetime =~/(\S+)\s+(\S+)\s+(\S+)\s+(\d{2}):(\d{2}):\d{2}\s+(\d{4})/;
if (defined $1)
{
    print "\njour  $3\n";
    print "mois  $2\n";
    print "annee $6\n";
    print "heure $4\n";
    print "minute $5\n";
}








