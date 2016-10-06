#!/usr/bin/perl
use strict;
use warnings FATAL =>'all';
use v5.24;
print "formation perl\n";  #double-quote
print 'formation perl\n';  #simple-quote
print "\n";

print "C:\\test\\test\n";
print 'C:\test\test';
print "\n";
print "test " . "test\n";  # concatenation

my $name = "John"; # local au script
our $t = "test";  # global aux scripts
print $name;
my $name1 = $name . "\n"; # local au script
print $name1;
print "Ok\n";
my $degree= 25;
print $degree . "\n";
print $degree .  $name1;
my $value = 45;
print $degree + $value;
my $value1;   # undef
print "\n";
print $value + 3;
print "\n";
print $name x 4;
print "\n";
print "\$\Uname nom est $name \n";

my $a ="8";
my $b= $a + "1";
say "b = " . $b;
my $c= $a . "1";
say "c = " . $c;

$a =123;
$b = 3;
say $a * $b;
say $a x $b;
$c = $a x $b +1 ;

say $c;
my $v="-";
my $ligne = $v x 80;
say $ligne;

$a = 5;
$b = ++$a;
say $b;
$c = $a--;
say $c, $b, $a ;

# valeur fausses
# 0
# "0" ou '0'
# ""  ''
# undef
my $valeur = "00"; # vraie
my $val;

my $text = "salut toi";
substr($text, 5,0)= "ation a";
say $text;

my $tt= "bruno2";
my $yy = $tt;
if ($tt eq $yy) {  # eq pour des chaines
    say "$tt et $yy sont egaux";
}
else
{
    say "$tt et $yy sont different";
}
my $val1= 10;
my $val2= 20;
print (($val1 + $val2) / 2) ;
print "\n";

my $email;
if (!defined $email){
    say $email= 'support@groupe-casino.fr';
}
else{
    say $email;
}
my $vv;
if ($vv)
{
    say "connu";

}
else
{
    say "inconnu";
}

$vv=3;
$vv +=3;
$vv = $vv + 3;
say $vv;

$vv ="durand";
$vv .= " Paux";
say $vv;
say length($vv);
chop($vv);
say chop($vv);
say $vv;
$vv= "testing\n";
chomp($vv);
print $vv . " perl\n";
say substr($vv,0,4);

for (my $i=0; $i<=10 ; $i+=2)
{
    say $i;
}
my $i=0;
while ( $i<=20)
{
    say $i;
    $i +=2;
}
$i= -1;
while(1)
{
    $i++;
    last if ($i >20);
    next if ($i%2 != 0);
    say $i;
}
say 0%2;

my @t=();
@t = (3,'chaine',"testing");
say $t[0];
say @t;
say $t[$#t];
say $t[-1];
say $t[-2];
@t = (1..10);
say @t;
say $#t;

foreach my $rr (@t)
{
    print $rr . " ";
}
print "\n";
my $number_element = @t; # scalar context and list context
say "elements total = $number_element";

my @pp = (3,23.4,"test");
$pp[7]="Paul";
#say @pp;

foreach my $cc (@pp)
{
    if (defined $cc) {
        print $cc . " ";
    }
}
my ($nom, $prenom) = ("Durand","Paul","john","Walter");
print $nom, $prenom, "\n";
my $nom1 ="toto";
my $nom2= "lulu";
print $nom1 . " " . $nom2 . "\n";
($nom1,$nom2) = ($nom2,$nom1);
print $nom1 . " " . $nom2 . "\n";

my @cards = qw( K Q J 10 9 8 7 6 5 4 3 2 A ); #
say $cards[-1];
my $cards_ref = \@cards;
say $cards_ref;
say \$nom1;
my $cards_count= @$cards_ref;
say $cards_count;
my $first_card = $cards_ref->[0];
say $first_card;
my $last_card = $cards_ref->[-1];
say $last_card;
my @high_cards=@{$cards_ref}[0..2,-1];
say @high_cards;
$high_cards[2]="V";
say @high_cards;

my $array = [3,'chaine',"testing"];
say $array;
say $array->[1];
































