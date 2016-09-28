#!/opt/ActivePerl5.24/bin/perl -w

use Modern::Perl '2015';
use strict;    # force to use local or global variable by using "my" or "our".
use Carp;      # carp gives you more info as to  where the message comes from (context)
use warnings;  # detect all warnings

use v5.24;     # force this script to use the right Perl version and promote say and other keywords.
               #  implies "use strict"

# TODO Have a look to perldoc to find out how to use the following packages.

my $test1_double = "test1";   # assign a local variable to a string
my $test_single = 'test2\n';    #The difference between single quotes and double quotes is that single quotes mean that
# their contents should be taken literally,
# while double quotes mean that their contents should be interpreted.
# quote in a single-quoted string must be escape with a leading baskslash

say   $test1_double ;  # print out this variable
print $test1_double ;

print $test_single;
say   $test_single;

my $name = "Tom";
my $address = "20, Penny Lane SW15 6GL London";

my $factoid = "$name lives at $address!";
# equivalent to
$factoid = $name . ' lives at ' . $address . '!';

# TODO quoting operator
my $quote = qq{"Ouch", he said. "That hurt!"};
print $quote . "\n";
my $reminder = q^Don't escape the single quote!^;
print $reminder. "\n";;
my $complaint = q{It's too early to be awake.};
print $complaint. "\n";;
my @name = qw(Tom Tim John);


# TODO heredoc, 3 parts : double angle-brackets, the quotes et the ending delimiter
my $blurb =<<'END_BLURB';
He looked up. "Change is the constant on which they all
can agree. We instead, born out of time, remain perfect
and perfectly self-aware. We only suffer change as we
pursue it. It is against our nature. We rebel against
that change. Shall we consider them greater for it?"
END_BLURB

print $blurb;



my $a = "8";    # Note the quotes.  $a is a string.
my $b = $a + "1";   # "1" is a string too.
say "print b = " . $b ;
my $c = $a . "1";   # But $b and $c have different values!
say "print c = " . $c;

$a = 123;
$b = 3;
say $a * $b;
say $a x $b;
$c = $a x $b + 1;
say $c;

#lvalue assignement
my $temp= 95;   # F degree
($temp -= 32) *= 5/9;
say "Temperature is " . $temp;    # Celsius degree

my $v= "salut toi";
substr($v,5,1) = "ation a ";
say $v;


$a = 5; # $a is assigned 5
$b = ++$a; # $b is assigned the incremented value of $a, 6
$c = $a--; # $c is assigned 6, then $a is decremented to 5
say $a," ", $b, " ", $c;


# valeurs faussses
# 0
# "0" ou '0'
# ""  ou ''
# et undef
## toutes les autres valeurs sont vraies
# par contre

my $valeur = "00";  #  est vraie

my $tt = 2;
my $yy = $tt;

if ($tt== $yy)
{
    print "\$tt et \$yy sont egaux \n";
}
else
{
    print "\$tt et \$yy sont differents \n";
}

# variables
my $answer = 42; # an integer

my $pi = 3.14159265; # a "real" number

my $avocados = 6.02e23; # scientific notation

my $pet = "Camel"; # string

my $file = "/home/hme/.bashrc";
my $exit = system("ls -alrt $file"); # numeric status of a command
say $exit;

my $t = `ls -alrt $file`; # backqotes
say $t;
my $cwd = `pwd`; # string output from a command
say $cwd;


my $myname= "hme";
my @myarray = (1,2,3,0);  #
my %myhash = ("hme" => 59, "baz" => 59);

my $myname_ref= \$myname;
print \$myname ."\n";

my @cards = qw( K Q J 10 9 8 7 6 5 4 3 2 A ); # array of cards
my $cards_ref = \@cards; # hold the array ref

my $card_count = @$cards_ref;
my @card_copy = @$cards_ref;

print $card_count . "number of cards \n";
print @card_copy . "array of values \n";

my $first_card = $cards_ref->[0];
my $last_card = $cards_ref->[-1];

print $first_card . "\t" . $last_card . "\n";
my @high_cards = @{$cards_ref}[0..2,-1];
print @high_cards, " high_cards\n";


my $ary = \@myarray; # reference to a named array
my $hsh = \%myhash; # reference to a named hash
my $sub = \&mysub; # reference to a named subroutine
$ary = [1,2,3,4,5]; # reference to an unnamed array
$hsh = {"hme" => 19, "baz" => 35}; # reference to an unnamed hash
$sub = sub { print my $state }; # reference to an unnamed subroutine

# TODO See the side-effect of lvalue in foreach loop
# see http://perldoc.perl.org/perlsyn.html#Foreach-Loops
use strict;
my @ar = (1, 2, 3);
foreach my $a (@ar)
{
    $a = $a + 1;
}
print join ", ", @ar;
print "\n";
# Because a scalar variable can only contain a scalar, assigning an array to a scalar
#imposes a scalar context on the operation, that produces the number of elments in the array:
my $count = @ar;
print $count;

