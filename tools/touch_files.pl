#!/usr/bin/perl
# Copyright 2015 Modell Aachen GmbH
# License: GPLv2+

use strict;
use warnings;

# Set library paths in @INC, at compile time
BEGIN {
  if (-e './setlib.cfg') {
    unshift @INC, '.';
  } elsif (-e '../bin/setlib.cfg') {
    unshift @INC, '../bin';
  }
  require 'setlib.cfg';
}

use Foswiki ();
my $session = Foswiki->new('admin');

use Foswiki::Store::PlainFile;

my ($web, $topic, $help);
for (my $i = 0; $i <= $#ARGV; $i++) {
    my $param = $ARGV[$i];
    if ($param =~ m#^-?-?help#) {
        $help = 1;
    } elsif ($param =~ m#^-?-?web=(.*)#) {
        $web = $1;
    } elsif ($param =~ m#^-?-?topic=(.*)#) {
        $topic = $1;
    } elsif ($i < $#ARGV) {
        if ($param =~ m#^-?-?web$#) {
            $web = $ARGV[++$i];
        } elsif ($param =~ m#^-?-?topic$#) {
            $topic = $ARGV[++$i];
        }
    }
}

if ($help) {
    print <<'MESSAGE';
This script will set the mtime of all data / pub files to the value of their
corresponding metadata.

Usage:
./touch_files [web=...] [topic=...]

or
./touch_files [--web=...] [--topic=...]

or
./touch_files [--web ...] [--topic ...]

Parameters:
    web: (optional) 'all' or any web
    topic: (optional) can be any topic.

Run from tools directory.
MESSAGE

    exit 0;
}

$web = undef if $web && $web eq 'all';

$session->{store}->touchFiles($session, sub { print $_[0]; }, $web, $topic);
