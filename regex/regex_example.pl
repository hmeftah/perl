#!/usr/local/bin/parallel --shebang-wrap  /opt/ActivePerl5.24/bin/perl -w
use strict;
use warnings;

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

$_ = " perl formation 2016";

my @words = /(\S+)/g ; #

foreach my $l (@words){
    print $l."\n";
}

my $word_count = () = /(\S+)/g;
print $word_count."\n";


#------------- regex NSS ----------------------------------

my $nss = '28212A160004';

$nss =~ m/\A(\d{1})(?#genre) (\d{2})(?#anne) (\d{2})(?#month)/i;

print <<"HERE";
Genre: $1
annee: $2
mois: $3
HERE

#------------- texte avec une reference produit ----------------------------------

my $text = " Le produit est le GP8765.";

if ($text =~ /le\s(\S+?)\./) {
    print "le code produist est : $1\n";
    }
else {
    print "Pas de produit trouve\n";
    }
