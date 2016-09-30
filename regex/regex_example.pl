#!/usr/local/bin/parallel --shebang-wrap  /opt/ActivePerl5.24/bin/perl -w
use strict;
use warnings;
use v5.24;

$|= 1;

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

$_ = " perl formation 2017";

my @words = /(\S+)/g ; #

foreach my $l (@words){
    print $l."\n";
}

my $word_count = () = /(\S+)/g;
print $word_count."\n";


#------------- regex NSS ----------------------------------

my $nss = '282122A770004 12';
if ($nss =~ m/^([1|2])(?#genre)([0-9]{2})(?#annee)([0-9]{2})(?#mois)([0-9][0-9]|[2-2A-B])(?#dept)/i) {
    print "genre: $1 \n";
    print "annee : $2 \n";
    print "mois : $3 \n";
    print "dept : $4 \n";

}
#-----------------------------------------------------------
$_ = "Bilbo Baggins's birthday is September 22";
/(.*)'s birthday is (.*)/;
say "Person: $1";
say "Date: $2";



#------------- texte avec une reference produit ----------------------------------

my $text = " Le produit est le GP8765.";

if ($text =~ /le\s(\S+?)\./) {
    print "le code produist est : $1\n";
    }
else {
    print "Pas de produit trouve\n";
    }
