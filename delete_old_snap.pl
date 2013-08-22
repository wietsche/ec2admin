#!/usr/bin/env perl

use Data::Dumper;
use warnings;
use strict;
use v5.10;

#------------------------------------------------------------------------------------------
#$numsnap determines the number of snapshots allowed.
#This script deletes snapshots so that only the $numsnap most recent snapshots are kept.

my $numsnap = 2;

#------------------------------------------------------------------------------------------

#environment variables for EC2
#system('export EC2_PRIVATE_KEY=$EC2_HOME/pk-QVNJPBQNTDJ3GEJWZNHIZHHFBMJVUT4J.pem');
#system('export EC2_CERT=$EC2_HOME/cert-QVNJPBQNTDJ3GEJWZNHIZHHFBMJVUT4J.pem');

#get snapshot ids
my $vdesc = qx(ec2-describe-volumes -F tag:Name=\'Data Volume\');
my @vattr = split( /\t/, $vdesc );    #tab seperated return
my $vid   = $vattr[1];

my $getsnaps =
  'ec2-describe-snapshots -F volume-id=\'' . $vid . '\',status=\'completed\'';
my $snaptab = qx($getsnaps);

my @snaptab2;
my $rc = 0;                           #row counter

my @snapattr = split( /\n/, $snaptab );    #get lines first
foreach my $row (@snapattr) {
    my @snapdet = split( /\t/, $row );

    #my @snaptab2[$rc];
    $snaptab2[$rc][0] = $rc;
    my $cc = 1;                            #collumn counter
    foreach my $atr (@snapdet) {
        $snaptab2[$rc][$cc] = $atr;
        print( $cc. ' ' );
        $cc++;
    }
    print("\n");

    $rc++;
}

#print Dumper(@snaptab2);
@snaptab2 =
  sort { $a->[5] cmp $b->[5] } @snaptab2;    #sort accending on snapshot date

my $numssdel = $rc - $numsnap;               #number of snapshot to be deleted

print "Deleting: " . $numssdel . " snapshots...\n";

for ( my $count = 0 ; $count < $numssdel ; $count++ ) {
    print( "deleting snapshot_id: " . $snaptab2[$count][2] . "\n" );
    my $delcom = 'ec2-delete-snapshot ' . $snaptab2[$count][2];
    qx($delcom);
}
