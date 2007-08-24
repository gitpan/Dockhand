package Dockhand::Reader::CSV;
use strict;
use warnings;
use Moose;

extends 'Dockhand::Reader';

use Text::CSV::Simple;
use Exporter;

our @ISA    = qw(Exporter);
our @EXPORT = qw(read_file);

sub read {
	my $filename = shift;
	return undef unless $filename;
	my $parser    = Text::CSV::Simple->new({eol=>"\n"});
	my @data      = $parser->read_file($filename);
	return \@data;
}
