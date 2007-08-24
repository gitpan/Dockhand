#!/usr/bin/perl
use strict;
use warnings;

use Spreadsheet::ParseExcel;
my $oBook = Spreadsheet::ParseExcel::Workbook->Parse($ARGV[0]);
my($iR, $iC, $oWkS, $oWkC);
foreach my $oWkS (@{$oBook->{Worksheet}}) {
	print "--------- SHEET:", $oWkS->{Name}, "\n";
     for ( my $iR = $oWkS->{MinRow} ; defined $oWkS->{MaxRow} && 
			$iR <= $oWkS->{MaxRow} ; $iR++ ) {
		for ( my $iC = $oWkS->{MinCol} ; defined $oWkS->{MaxCol} && 
				$iC <= $oWkS->{MaxCol} ; $iC++ ) {
			$oWkC = $oWkS->{Cells}[$iR][$iC];
               print "( $iR , $iC ) => ", $oWkC->Value, "\n" if ($oWkC);
		}
     }
}
