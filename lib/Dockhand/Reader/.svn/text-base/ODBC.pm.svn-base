package Dockhand::Reader::ODBC;
use DBI;
use Moose;

extends 'Dockhand::Reader';

sub read {
	my $dsn    = shift;
	my $user   = shift;
	my $passwd = shift;
	my $conn   = DBI->connect("dbi:ODBC:$dsn", $user, $passwd);
}
