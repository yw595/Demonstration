use strict;
use warnings;
use Spreadsheet::ParseExcel;
use LWP;

my $ExcelFile="$ARGV[2]";
my $parser=Spreadsheet::ParseExcel->new();
my $workbook=$parser->parse($ExcelFile);

my %IDsToContigs=();
my %IDsToBegins=();
my %IDsToEnds=();
for my $worksheet ( $workbook->worksheets())
{
    my ($row_min,$row_max) = $worksheet->row_range();
    my ($col_min,$col_max) = $worksheet->col_range();
    for my $row (1 ... $row_max)
    {
	my $locationCell = $worksheet->get_cell($row,3);
	my $featureIDCell = $worksheet->get_cell($row,1);
	$locationCell->value() =~ /(.*)_(\d*)_(\d*)$/;
	my $contig=$1;
	my $begin=$2;
	my $end=$3;
	$IDsToContigs{$featureIDCell->value()}=$contig;
	$IDsToBegins{$featureIDCell->value()}=$begin;
	$IDsToEnds{$featureIDCell->value()}=$end;
	#print $featureIDCell->value()  . "\n";
    }
}

open (IN,"$ARGV[0]");
open (OUT,">$ARGV[1]");
my @URLArray=();
my %KOsToContigs=();
my %KOsToBegins=();
my %KOsToEnds=();
while(<IN>)
{
    my $line=$_;
    chomp($line);
    if($line =~ /(\S*)(\s*)(K(.)*)/)
    {
	push(@URLArray,$3);
	$KOsToContigs{"$3"}=$IDsToContigs{"$1"};
	$KOsToBegins{"$3"}=$IDsToBegins{"$1"};
	$KOsToEnds{"$3"}=$IDsToEnds{"$1"};
	#print $1 . "\n";
	#print $IDsToEnds{"$1"} . "\n";
    }
}
#print OUT $URL;
for (my $i=0;$i<$#URLArray/100;$i++)
{
    my $URL="";
    for(my $j=$i*100;$j<($#URLArray<=($i+1)*100 ? $#URLArray : ($i+1)*100);$j++)
    {
	if(length($URL)==0)
	{
	    $URL=$URLArray[$j];
	}
	else
	{
	    $URL = $URL . "+" . $URLArray[$j];
	}
    }
    my $browser = LWP::UserAgent->new;
    my $browserURL = "http://rest.kegg.jp/link/ec/" . $URL;
    my $browserResponse = $browser->get($browserURL);
    my @lines=split("\n",$browserResponse->content);
    for(my $j=0;$j<=$#lines;$j++)
    {
	$lines[$j] =~ /ko:(\w*)(\s*)ec:(.*)$/;
	my $ECNumber=$3;
	my $contig=$KOsToContigs{"$1"};
	my $begin=$KOsToBegins{"$1"};
	my $end=$KOsToEnds{"$1"};
	print OUT "$ECNumber\n";
	print OUT "$contig\t$begin\t$end\n";
    }
}
