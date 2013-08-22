#!/usr/bin/env perl

use warnings;
use strict;
use v5.10;

#environment variables for EC2
#system('export EC2_PRIVATE_KEY=$EC2_HOME/pk-QVNJPBQNTDJ3GEJWZNHIZHHFBMJVUT4J.pem');
#system('export EC2_CERT=$EC2_HOME/cert-QVNJPBQNTDJ3GEJWZNHIZHHFBMJVUT4J.pem');

my $vdesc = qx(ec2-describe-volumes -F tag:Name=\'Data Volume\');
my @vattr = split( /\t/, $vdesc );    #tab seperated return
my $vid   = $vattr[1];

#my $vid = 'vol-e5948f91';

my $thedate = localtime;

#create snapshot
print "Creating snapshot of Data Volume...\n\n";
my $ec2comment = 'Backup: ' . $thedate;
my $bkcom      = 'ec2-create-snapshot ' . $vid . ' -d  \'' . $ec2comment . '\'';
my $ssdesc     = qx($bkcom);

my @ssattr = split( /\t/, $ssdesc );    #tab seperated return
foreach my $atr (@ssattr) {

    print($atr."\n");
}
