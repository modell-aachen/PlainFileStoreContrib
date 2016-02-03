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
use Foswiki::Contrib::VirtualHostingContrib::VirtualHost ();
use Foswiki::Store::PlainFile;

my ($host, $web, $topic);
for (my $i = 0; $i <= $#ARGV; $i++) {
    my $param = $ARGV[$i];
    if ($param =~ m#^-?-?host=(.*)#) {
        $host = $1;
    } elsif ($param =~ m#^-?-?web=(.*)#) {
        $web = $1;
    } elsif ($param =~ m#^-?-?topic=(.*)#) {
        $topic = $1;
    } elsif ($i < $#ARGV) {
        if ($param =~ m#^-?-?host$#) {
            $host = $ARGV[++$i];
        } elsif ($param =~ m#^-?-?web$#) {
            $web = $ARGV[++$i];
        } elsif ($param =~ m#^-?-?topic$#) {
            $topic = $ARGV[++$i];
        }
    }
}

unless ($host) {
    print <<'MESSAGE';
This script will set the mtime of all data / pub files to the value of their
corresponding metadata.

Usage:
./virtualhosts-touch_files host=hostname [web=...] [topic=...]

or
./virtualhosts-touch_files --host=hostname [--web=...] [--topic=...]

or
./virtualhosts-touch_files --host hostname [--web ...] [--topic ...]

Parameters:
    hostname: 'all' or any host
    web: (optional) 'all' or any web
    topic: (optional) can be any topic.

Run from tools directory.
MESSAGE

    exit 0;
}

$web = undef if $web && $web eq 'all';

sub check {
    my $session = Foswiki->new('admin');
    $session->{store}->touchFiles($session, sub { print $_[0]; }, $web, $topic);
};


if ($host ne 'all') {
    Foswiki::Contrib::VirtualHostingContrib::VirtualHost->run_on($host, \&check);
} else {
    Foswiki::Contrib::VirtualHostingContrib::VirtualHost->run_on_each(\&check);
}
