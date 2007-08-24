package Dockhand::Reader;
use strict;
use warnings;

use Exporter;

our @ISA    = qw(Exporter);
our @EXPORT = qw(get_table get_item get_row 
                 get_fields get_col);

sub get_table {
	my $data   = shift;
	my $fields = get_fields($data);
	my %table;
	my $i = 0;
	foreach my $field (@$fields) {
		$table{$field} = get_col($data, $i);	
		++$i;
	}
	return \%table;
}

sub get_item {
	my $data    = shift;
	my $c_index = shift;
	my $r_index = shift;
	my $row = get_row($data, $r_index);
	return $row->[$c_index];		
}

sub get_row {
	my $data    = shift;
	my $r_index = shift;
	my @row;
	# FIXME: Both lines can be replaced by "return $data->[$r_index]"
	#foreach (@{$data->[$r_index]}) { push @row, $_ }
	#	return \@row;
	return $data->[$r_index];
}

# FIXME: This is not needed use "keys %table"
sub get_fields { return get_row($_[0], 0) }

sub get_col {
	my $data    = shift;
	my $c_index = shift;
	my @col;
	# FIXME: $i starts at 1 to skip the field names
	# this should be configurable
	for (my $i = 1; $i <= (int(@$data)-1); $i++) {
		push @col, $data->[$i]->[$c_index];
	}
	return \@col;
}

use lib $ENV{'DOCKHAND_PATH'} . '/lib';
use Dockhand::File::Excel;
use Perl6::Say;

dump_data(read_file($ARGV[0]));
# Description: dump data as a text file
sub dump_data {
	my $data = shift;

	map { say } @{$data->[70]};

}

1;
