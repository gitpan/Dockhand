#!/usr/bin/perl
use strict;
use warnings;
use Perl6::Say;

use Spreadsheet::ParseExcel;

sub read_file {
	my $filename = shift;
	return undef unless $filename;
	my $book = Spreadsheet::ParseExcel::Workbook->Parse($ARGV[0]);
	my $worksheet = ${$book->{Worksheet}}[0];
	my @data = ();
	for ( my $r = $worksheet->{MinCol}; defined $worksheet->{MaxCol} && 
		$r <= $worksheet->{MaxCol}; $r++ ) {
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

sub _get_col {
	my $worksheet = shift;
	my $c_index = shift;

	my @col = ();
	for ( my $r = $worksheet->{MinCol}; defined $worksheet->{MaxCol} && 
		$r <= $worksheet->{MaxCol}; $r++ ) {
		my $cell = $worksheet->{Cells}[$r][$c_index];
		push @col, $cell->Value if $cell;
	}
	return \@col;
}


