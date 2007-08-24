package Dockhand::Reader::MDB;
use strict;
use warnings;
use Perl6::Say;
use Moose;

extends 'Dockhand::Reader';

use Win32::OLE; # NOTE: This will only work on windows
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(read_file);

sub read {
	my $filename = shift;
	return undef unless $filename;
	my @data = ();
	return \@data;
}

1;

