#! /usr/bin/perl -w

use strict;
#use Spreadsheet::WriteExcel;
use Spreadsheet::ParseExcel;

my $ExcelFile="$ARGV[0]";
my $parser=Spreadsheet::ParseExcel->new();
my $workbook=$parser->parse($ExcelFile);

open (OUT,">$ARGV[1]");
#iterate over all worksheets in the Excel file
for my $worksheet ( $workbook->worksheets())
{
    my ($row_min,$row_max) = $worksheet->row_range();
    my ($col_min,$col_max) = $worksheet->col_range();
	#for each row in the RAST excel file, get the function in the seventh cell and location in the third cell
	#extract contig, begin and end from the location, and all EC numbers from the function using getECNumbers
	#print out all EC numbers found, plus contig, begin and end
    for my $row (1 ... $row_max)
    {
	my $locationCell = $worksheet->get_cell($row,3);
	my $functionCell = $worksheet->get_cell($row,7);
	if($functionCell->value() =~ m/EC.((\d|-)+\.(\d|-)+\.(\d|-)+\.(\d|-)+)/)
	{
	    my @ECNumbers=getECNumbers($functionCell->value);
	    $locationCell->value() =~ /(.*)_(\d*)_(\d*)$/;
	    my $contig=$1;
	    my $begin=$2;
	    my $end=$3;
	    print OUT join("\t",@ECNumbers) . "\n";
	    print OUT "$1\t$2\t$3\n";
	}
    }
}

#find one EC number in description at a time, remove it from description, and then search for more
sub getECNumbers
{
    my $description=$_[0];
    my @ECNumbers=();
    while($description =~ m/EC.((\d|-)+\.(\d|-)+\.(\d|-)+\.(\d|-)+)/)
    {
	$description =~ /EC.((\d|-)+\.(\d|-)+\.(\d|-)+\.(\d|-)+)/;
	$description=substr($description,$+[0]);
	push(@ECNumbers,$1);
    }
    return @ECNumbers;
}
