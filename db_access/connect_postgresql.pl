#!/usr/local/bin/parallel --shebang-wrap  /opt/ActivePerl5.24/bin/perl -w
use strict;
use warnings;

use DBI;
use DBD::Pg;
use Tie::File;

$|= 1;

my $dbname = 'parallel';
my $host= 'localhost';
my $username='postgres';
my $password='xxxxx';

my @array;
tie @array , 'Tie::File', '/home/hme/codeplex/perl/english.txt' or die "file not found\n";

my $nbr_of_word=  @array;
#print $array[int rand($nbr_of_word)];

my $dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=$host",$username,$password,{AutoCommit=>1,
    RaiseError=>1,PrintError=>0}) or die $DBI::errstr;
$dbh->trace(1,'tracelog.txt');

my $SQL;
# $SQL ="DROP TABLE IF EXISTS employee";
#my $sth= $dbh->do($SQL);

# Create a table
#$SQL = "CREATE TABLE employee (
#                  employe_id BIGSERIAL PRIMARY KEY,
#                  first_name varchar(100),
#                  last_name varchar(100),
#                  EMAIL VARCHAR(100),
#                  DESCRIPTION text,
#                 last_update timestamp without time zone NOT NULL DEFAULT now()
#          )";
#$sth = $dbh->do($SQL);
#$dbh->commit or die $DBI::errstr;

my $description =<<'END_BLURB';
He looked up. Change is the constant on which they all
can agree. We instead, born out of time, remain perfect
and perfectly self-aware.
END_BLURB

my  $iteration = $ARGV[0];

for ( my $i=0 ; $i <= $iteration ;$i++) {
    my $first_name = $array[int rand($nbr_of_word)];
    my $last_name = $array[int rand($nbr_of_word)];
    my $email = $first_name.".".$last_name."@"."yahoo.com";
    print $email . "\n";
    my $query = "INSERT INTO EMPLOYEE (first_name,last_name,email,description) values ( ? ,? ,? ,?)";
    my $res = $dbh->prepare( $query ) or die ("cannot prepare");

    $res->execute( $first_name, $last_name, $email, $description );
}




