#!/usr/bin/perl -w
#
# take_snapshot.pl - copies files from the app directory to a named directory
# Boyd Duffee, Aug 2017

use strict;
use v5.010;
use File::Copy::Recursive qw/dircopy/;

my $name = ucfirst shift;
die "Usage: $0 <name>\n" unless $name;

my $archive_dir = 'Snapshots';
mkdir $archive_dir unless -d $archive_dir;

my $directory = "$archive_dir/$name";
die "$name already exists in $archive_dir\n" if -e "$directory";
mkdir $directory;

my $working_copy = 'session_tutorial';
dircopy($working_copy, $directory) or die "Couldn't copy $working_copy to $directory: $!\n";

say "Files copied to $directory";
exit;
