#!/usr/local/bin/parallel --shebang-wrap  /opt/ActivePerl5.24/bin/perl -w
use strict;
use warnings;
use v5.24;

$|= 1;

use re 'debug';

#------------- use /x and comments in regex ------------------------------

my $isbn = '0-596-10206-1';

$isbn =~ m/\A(\d+)(?#group)-(\d+)(?#publisher)-(\d+)(?#item)-([\dX])\z/i;

if ( defined $1 )
{
    print "\t Group code: $1 \t
         Publisher code: $2 \t
         Item: $3 \t
         Checksum: $4
            ";
}

sub isbn_regex {
        qr/ \A
            (\d+) #group
            -
            (\d+) #publisher
            -
            (\d+)  #item
            -
            ([\dX])
            \z
        /ix;
}
my $regex=isbn_regex();
if ($isbn =~ m/$regex/){
    print "Matched !\n";
}

if ($isbn =~ $regex){
    print "Matched !\n";
}

#------------- global matching -----------------------------

$_ = " perl formation 2016";

my @words = /(\S+)/g ; #

foreach my $l (@words){
    print $l."\n";
}

my $word_count = () = /(\S+)/g;
print $word_count."\n";

# ---------------------------------------------

$_ ="c'est le language perl";
say $_;
say /perl/; # le mot exact

$_ ="perl langage";
say $_;
say /^perl/; # commence par

$_ ="langage perl";
say $_;
say /perl$/;  # fini par

$_ ="c'est le language PerL";
say $_;
say /perl/i;  # incensive a maj

$_ ="c'est le language pal";
say $_;
say /p[eawr]l/;

$_ ="122";
say $_;
say /\d\d\d/;

$_ ="123";
say $_;
say /\d\d\d?/;

$_ ="1233333";
say $_;
say /\d\d\d+/;

$_ ="1234567";
say $_;
say /\d\d\d*/;

$_ ="perl";
say $_;
say /p..l/;

$_="//commemtaire";
say $_;
say /^\/\//;


$_ ="perl reer";
say $_;
say /p.*/;

$_ ="perl langage";
say $_;
say /p.?/;

$_ ="5112";
say $_;
say /\d{4}/;

$_ ="Produits NG4567";
say $_;
say /(\s+)([A-Z]{2}\d{4})/;


$_ = "le perl langage";
my $pos = pos( $_ ); # same as pos()

#print "I'm at position [$pos]\n"; # undef
/(perl)/g;

$pos = pos();
print "[$1] ends at position $pos\n"; # 7


my $line = "Juste une autre regex, test";
my $regex1= qr/\G \s* (\w+) /x;
while( $line =~ /$regex1/g ) {
    print "Found the word '$1'\n";
    print "Pos is now @{ [ pos( $line ) ] }\n";
}




#my $line1 = "Juste, une, autre, regex, test";
#my $regex2= qr/\G \s* (\S+) /x;
#while( $line1 =~ /$regex2/g ) {
#    print "Found the word '$1'\n";
#    print "Pos is now @{ [ pos( $line1 ) ] }\n";
#}

# http://perldoc.perl.org/index-functions.html
#===========================================================================

#my $first_name = prompt("First name: ", "pass");
#my $last_name = prompt("Last name: ","pass");

#say $first_name;
#say $last_name;

#sub prompt {
#    my  ($text) = @_;
#    print $text;
#
#    my $answer = <STDIN>;
#    chomp $answer;
#    return $answer;
#}

















#------------- regex NSS ----------------------------------

#my $nss = '282122A770004 12';
#if ($nss =~ m/^([1|2])(?#genre)([0-9]{2})(?#annee)([0-9]{2})(?#mois)([0-9][0-9]|[2-2A-B])(?#dept)/i) {
#    print "genre: $1 \n";
#    print "annee : $2 \n";
#    print "mois : $3 \n";
#    print "dept : $4 \n";
#
#}
#-----------------------------------------------------------
#$_ = "Bilbo Baggins's birthday is September 22";
#/(.*)'s birthday is (.*)/;
#say "Person: $1";
#say "Date: $2";



#------------- texte avec une reference produit ----------------------------------

#my $text = " Le produit est le GP8765.";

#if ($text =~ /le\s(\S+?)\./) {
#    print "le code produist est : $1\n";
 #   }
#else {
#    print "Pas de produit trouve\n";
#    }
