#!/usr/bin/env perl

use warnings;
use strict;
use v5.10;
use Time::localtime;
use Data::Dumper;

#------------------------------------------------------------------------------------------
#$numimg determines the number of images allowed.
#This script deletes images so that only the $numimg most recent images are kept.

my $numimg = 2;

#------------------------------------------------------------------------------------------

my $getimages =
'ec2-describe-images -F description=\'RT Server Backup Image\',name=\'RT Server Backup Image*\',status=available';
print( $getimages. "\n" );
my $images = qx($getimages);

my @imtab;
my $rc = 0;    #row counter

my @iattr = split( /\n/, $images );    #get lines first
foreach my $row (@iattr) {
    my @idet = split( /\t/, $row );
    if ( $idet[0] eq 'IMAGE' ) {
        print( $idet[0] . "\n" );
        my $cc = 0;                    #collumn counter
        foreach my $atr (@idet) {
            {
                $imtab[$rc][$cc] = $atr;
                print( $cc. ' ' );
                $cc++;
            }
        }
        $rc++;
        print("\n");
    }

}

@imtab = sort { $a->[2] cmp $b->[2] } @imtab;   #sort accending on image date

#print Dumper(@imtab);

my $numimdel = $rc - $numimg;    #number of images to be deleted

if ( $numimdel > 0 ) {
    print "Deleting: " . $numimdel . " machine images...\n";

    for ( my $count = 0 ; $count < $numimdel ; $count++ ) {
        print( "deleting image : " . $imtab[$count][1] . "\n" );
        my $delcom = 'ec2-deregister ' . $imtab[$count][1];

        #print($delcom."\n");
        qx($delcom);
    }
}
else {
    print "\nNothing to delete\n";

}

