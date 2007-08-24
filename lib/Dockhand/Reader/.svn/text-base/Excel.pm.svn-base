package Dockhand::Reader::Excel;
use strict;
use warnings;
use Perl6::Say;
use Moose;

extends 'Dockhand::Reader';

use Spreadsheet::ParseExcel;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(read_file);

sub read {
	my $filename = shift;
	return undef unless $filename;
	my $book = Spreadsheet::ParseExcel::Workbook->Parse($filename);
	my $worksheet = ${$book->{Worksheet}}[0];
	my @data = ();
	for ( my $r = $worksheet->{MinRow}; defined $worksheet->{MaxRow} && 
		$r <= $worksheet->{MaxRow}; $r++ ) {
		push @data, _get_row($worksheet, $r);
	}
	return \@data;
}


sub _get_row {
	my $worksheet = shift;
	my $r_index = shift;

	my @row = ();
	for ( my $c = $worksheet->{MinCol}; defined $worksheet->{MaxCol} && 
		$c <= $worksheet->{MaxCol}; $c++ ) {
		my $cell = $worksheet->{Cells}[$r_index][$c];
		push @row, $cell->Value if $cell;
	}
	return \@row;
}
1;
