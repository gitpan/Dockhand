package Dockhand::Reader::Config;
use strict;
use warnings;
use Moose;

extends 'Dockhand::Reader';

use lib $ENV{'DOCKHAND_PATH'} . '/lib';
use Dockhand::CSV;
use Dockhand::Types;
use Exporter;

our @ISA       = qw(Exporter);
our @EXPORT    = qw(get_overrides);
our @EXPORT_OK = qw(read_config);

sub get_overrides {
	my $table    = shift;
	my $file     = shift;
	my $filetype = shift;
	unless (-e $file) { return {} }
	my %or = %{read_config('overrides', $file)};
	my ($field, $type);
	while ( ($field, $type) = each %or ) {
		if ( $filetype =~ /SQL/i ) {
			$or{$field} = NUM     if $type =~ /INT|DEC/i;
			if ($type =~ /CHAR/i) {
				my $len = get_col_length($table->{$field});
				$or{$field} = (VARCHAR . "\($len\)");
			}

		} elsif ( $filetype =~ /CTL/i ) {
			$or{$field} = INT     if $type =~ /INT/i;
			$or{$field} = DEC     if $type =~ /DEC/i;
			$or{$field} = CHAR    if $type =~ /CHAR/i;

		}
	}
	return \%or;	
}

sub read_config {
	my $tag  = shift;
	my $file = shift;
	my ($tagfound, $name) = (0,);
	open CONFIG, "<$file" or warn "Cannot read $file: $!";
	no strict 'refs';
	foreach (<CONFIG>) {
		if ( /\[$tag\]/i ) {
			*{lc $tag} = {};
			$tagfound = 1;
			next;
		} 
		s/\s//g;
		my ($key, $value) = split /=/;
		${*$tag}{$key} = $value;
	}
	close CONFIG;
	return \%{*$tag};
}
1;
