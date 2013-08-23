#!/usr/bin/env perl

use warnings;
use strict;
use v5.10;
use Time::localtime;

my $idesc = qx(ec2-describe-instances -F tag:Name=\'RT Server\');
my @iattr = split( /\t/, $idesc );    #tab seperated return
foreach my $atr (@iattr) {

    #print($atr."\n");
}

my $instance_id = $iattr[4];

#my $thedate = localtime;
print( "Creating image of Instance: " . $instance_id . "...\n\n" );

my $t         = localtime;
my $timestamp = sprintf(
    "%04d-%02d-%02d_%02d-%02d-%02d",
    $t->year + 1900,
    $t->mon + 1,
    $t->mday, $t->hour, $t->min, $t->sec
);

my $ec2comment = 'RT Server Backup Image';
my $ec2command =
    'ec2-create-image '
  . $instance_id
  . ' -n \'RT Server Backup Image '
  . $timestamp
  . '\' -d  \''
  . $ec2comment . '\''
#  . ' -b \'/dev/sdg=none\''
    . ' --no-reboot'
  ;
print($ec2command);
my $ec2result = qx($ec2command);

print( $ec2result. "\n" );
