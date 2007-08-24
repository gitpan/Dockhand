package Dockhand::Types;
use strict;
use warnings;

use Exporter;

our @ISA    = qw(Exporter);
our @EXPORT = qw(VARCHAR INT DEC NUM CHAR UNDEF NUMCHAR
				 get_col_type get_num_col_type get_longest_item
				 is_in get_col_length get_item_length get_item_type
				 make_format_type);

use lib $ENV{'DOCKHAND_PATH'} . '/lib';
#use Dockhand::File::CSV;

# FIXME: Findout why this makes it run slow
# TODO: Make this read table from config file
BEGIN {
	# Dynamically create all is_[type] functions
	my $notchar = '/^\-\d+/';
	my $char    = '/\>|\<|\$|\,|[a-zA-Z]|\-/i' . "and !$notchar";
	my $int     = '/-?(\d+)/';
	my $dec     = '/-?(\d+\.\d+)/';
	my $num     = "$int or $dec";
	my $undef   = '/UNDEF/i';
	my $numchar = "!$notchar and $char and ( $int or $dec )";
	
	my %PATTERNS = (
		CHAR    => "$char   or /CHAR/i",
		INT     => "$int    or /INT/i",
		DEC     => "$dec    or /DEC/i",
		NUM     => "$num    or /NUM/i or /INT/i or /DEC/i",
		UNDEF   => $undef,
		NUMCHAR => "\( $numchar \) or /NUMCHAR/i"
	);

	for my $type (keys %PATTERNS) {
		no strict 'refs';
		*{'is_' . lc $type} = sub { 
			local $_ = shift;
			return 1 if eval $PATTERNS{$type};
			return 0;
		}; 
	}
}

use constant { VARCHAR => 'VARCHAR2', 
			   INT     => 'INTEGER EXTERNAL',
			   DEC	   => 'DECIMAL EXTERNAL', 
			   NUM     => 'NUMBER',
			   CHAR    => 'CHAR',
			   UNDEF   => 'UNDEF',
			   NUMCHAR => 'NUMCHAR' };

# FIXME: This is a mess
sub get_col_type {
	my $col       = shift;
	my $filetype  = shift;
	my $fieldname = shift if ($filetype =~ /CTL/i);

	my $num_types = get_num_col_types($col, $filetype);
	my @types     = keys %$num_types;

	# Dominant Type (numericaly)
	my @dom_type = sort { $num_types->{$b} <=> $num_types->{$a} } keys %$num_types;

	if ( $dom_type[0] =~ /UNDEF/i ) {
		unless ($dom_type[1]) {
			return CHAR if $filetype =~ /CTL/i;

			my $len = get_col_length($col);
			return VARCHAR . "\($len\)" if $filetype =~ /SQL/i;
		}
		shift @dom_type;
	}
	if ( $dom_type[0] =~ /NUMCHAR/i ) {
		if ( $dom_type[1] and ($dom_type[1] =~ /CHAR/i) ) {
			if ( $filetype =~ /SQL/i ) {
				my $len = get_col_length($col);
				return VARCHAR . "\($len\)";

			} else { return CHAR }
		}
		return NUM if $filetype =~ /SQL/i;

		my $longest = get_longest_item($col);
		my $format_str = make_format_string($longest);

		return 'CHAR "TO_NUMBER(:' .
			$fieldname . "\,'". $format_str .'\')"';
	} elsif ( $dom_type[0] =~ /INT|DEC|NUMBER/i ) {
		if ( is_in('/NUMCHAR/i', @dom_type) && ($filetype =~ /CTL/i) ) { 
			my $longest = get_longest_item($col);
			my $format_str = make_format_string($longest);
			return 'CHAR "TO_NUMBER(:' .
				$fieldname . "\,'". $format_str .'\')"';
				
		} elsif ( is_in('/NUMCHAR/i', @dom_type) && ($filetype =~ /SQL/i) ) { 
			return NUM;
			
		} elsif ( is_in('/CHAR/i', @dom_type) && ($filetype =~ /CTL/i) ) { 
			return CHAR;
			
		} elsif ( is_in('/CHAR/i', @dom_type) && ($filetype =~ /SQL/i) ) {
		   my $len = get_col_length($col);
		   return VARCHAR . "\($len\)";
		   
		} else { return $dom_type[0] }
	} elsif ( $dom_type[0] =~ /VARCHAR|CHAR/i ) {
		if ( $filetype =~ /SQL/i ) {
			my $len = get_col_length($col);
			return VARCHAR . "\($len\)";
		} else { return CHAR }
	} else { return $dom_type[0] }
}

sub get_num_col_types {
	my $col      = shift;
	my $filetype = shift;
	my (@types, %num_types);
	foreach my $item (@$col) {
		my $type = get_item_type($item, $filetype); 
		push @types, $type;
		unless (is_in('/'.$type.'/i',@types)) {
			$num_types{$type} = 1;
			next;
		}
		++$num_types{$type}
	}
	return \%num_types;
}

sub get_longest_item {
	my $col = shift;
	my %lengths;
	foreach (@$col) { $lengths{$_} = get_item_length($_) }
	my @longest = sort { $lengths{$b} <=> $lengths{$a} } keys %lengths;
	return $longest[0];
}

sub is_in {
	my $query = shift;
	foreach (@_) { return 1 if (eval $query) }
	return 0;
}

sub get_col_length {
	my $col = shift;
	my @lengths;
	foreach (@$col) { push @lengths, get_item_length($_) }
	@lengths = sort {$a <=> $b} @lengths;
	my $len  = $lengths[(int(@lengths)-1)];
	return 3 unless $len;
	return $len;
}

sub get_item_length {
	local $_ = shift;
	use bytes; return length;
}

# FIXME: This can be simplified
# maybe even completely dynamic
sub get_item_type {
	my $item     = shift;
	my $filetype = shift; # SQL or CTL(Control)

	if (($filetype =~ /SQL/i) || !$filetype) {
		if    (is_numchar($item)) { return NUMCHAR }
		elsif (is_char($item))    { return VARCHAR } 
		elsif (is_num($item))     { return NUM } 
		else				      { return UNDEF }
	} elsif ($filetype =~ /CTL/i) {
		if    (is_numchar($item)) { return NUMCHAR } 
		elsif (is_char($item))    { return CHAR } 
		elsif (is_dec($item))     { return DEC } 
		elsif (is_int($item))     { return INT } 
		else				      { return UNDEF }
	} else { return UNDEF }
}

sub make_format_string {
	local $_ = shift;
	s/\d/9/g; 
	s/\-|\+/S/g;
	return $_;
}
1;
