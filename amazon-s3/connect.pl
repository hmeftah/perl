#!/opt/ActivePerl5.24/bin/perl -w
use strict;
use warnings ;

use Net::Amazon::S3;
use VM::EC2;

# reservation  M4
my $aws_access_key_id     = 'AKIAJ3X6UD4VZ6NKJRTQ';
my $aws_secret_access_key = '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';

my $s3 = Net::Amazon::S3->new(
    {   aws_access_key_id     => $aws_access_key_id,
        aws_secret_access_key => $aws_secret_access_key,
        # or use an IAM role .
    }
);

# a bucket is a globally-unique directory
# list all buckets that i own
my $response = $s3->buckets;
foreach my $bucket ( @{ $response->{buckets} } ) {
    print "You have a bucket: " . $bucket->bucket . "\n";
}

my $ec2 = VM::EC2->new( -access_key => $aws_access_key_id,
                        -secret_key => $aws_secret_access_key,
                        -endpoint   => 'http://ec2.amazonaws.com');


my @instances = $ec2->describe_instances();
for my $i (@instances){
    print $i->reservationId;
}