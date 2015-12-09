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

my $web = $ARGV[0];
unless ($web) {
    print <<'MESSAGE';
This script will set the mtime of all data / pub files to the value of their
corresponding metadata.

Usage:
./touch_files web [topic]

Where web can be 'all' or any web and topic (optional) can be any topic.

Run from tools directory.
MESSAGE

    exit 0;
}

$web = undef if $web eq 'all';

$session->{store}->touchFiles($session, sub { print $_[0]; }, $web, $ARGV[1]);
