#!/usr/bin/env perl
#creates a new snapshot of the data volume in busii's AWS account
#the snapshot has the system date as a description for identification on the web portal

use warnings;
use strict;
use v5.10;

#environment variables for EC2
system('export EC2_PRIVATE_KEY=$EC2_HOME/pk-QVNJPBQNTDJ3GEJWZNHIZHHFBMJVUT4J.pem');
system('export EC2_CERT=$EC2_HOME/cert-QVNJPBQNTDJ3GEJWZNHIZHHFBMJVUT4J.pem');

my $vdesc = qx(ec2-describe-volumes -F tag:Name=\'Data Volume\');
my @vattr = split(/\t/,$vdesc); #tab seperated return
my $vid = $vattr[1];

#my $vid = 'vol-e5948f91';

my $thedate = localtime;

#create snapshot
my $bkcom = 'ec2-create-snapshot '.$vid.' -d  \''. $thedate.'\'';
my $ssdesc = qx($bkcom);

my @ssattr = split(/\t/,$ssdesc); #tab seperated return
foreach my $atr (@ssattr)
{
#print($atr."\n");
}






