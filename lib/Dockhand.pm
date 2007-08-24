package Dockhand;
use strict;
use warnings;

use lib $ENV{'DOCKHAND_PATH'} . '/lib';
use Dockhand::Types;
use Exporter;

our @ISA    = qw(Exporter);
our @EXPORT = qw(make_table make_control);

sub make_table {
	my $table    = shift;
	my $name     = shift;
	my $outfile  = shift;
	my $override = shift;
	my @fields   = keys %$table;

	open OUT, ">$outfile" or die "Cannot write $outfile: $!";

	print OUT "CREATE TABLE ", $name, " (\n";
	foreach (@fields) {
		my $type;
		if ( $override->{$_} ) { $type = $override->{$_} }
		else                   { $type = get_col_type($table->{$_}, 'SQL') }
		printf OUT "%15s\t%15s", $_, $type;
		print  OUT "\,\n" unless $_ eq $fields[(int(@fields)-1)];
	}
	print OUT "\n)\;\n";
}

sub make_control {
	my $table     = shift;
	my $tablename = shift;
	my $outfile   = shift;
	my $filename  = shift;
	my $override  = shift;
	my @fields    = keys %$table; 
	
	open OUT, ">$outfile" or die "Cannot write $outfile: $!";
	
	my @data_types;
	my $i = 0;
	print OUT <<EOF;
OPTIONS (DIRECT=TRUE)
LOAD DATA
INFILE $filename
APPEND
INTO TABLE $tablename
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
TRAILING
(
EOF
	foreach (@fields) {
		my $type;
		if ( $override->{$_} ) { $type = $override->{$_} }
		else                   { $type = get_col_type($table->{$_}, 'CTL', $_) }
		printf OUT "%15s\t%50s", $_, $type;
		print  OUT ',' unless $i == (int(@fields)-1);
		print  OUT "\n";
		$i++;
	}
	print OUT ")\n";
}
1;
