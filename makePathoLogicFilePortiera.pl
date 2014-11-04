use strict;
use warnings;

open(ANNOTIN,"$ARGV[0]");
open(OUT,">$ARGV[1]");
my @ECNumbers=();
my @names=();
my $ECLines=0;

#iterate over each line
#if it begins with EC, push the first EC number onto the array ECNumbers
#else, push onto the array names
while(<ANNOTIN>)
{
    my $line=$_;
    chomp($line);
    if($line=~/EC-(.*)/)
    {
	$ECLines=1;
    }
    if($line ne "")
    {
	if($ECLines)
	{
	    $line=~/EC-(.*)/;
	    my $ECIndex=$-[1];
	    $line=~/\s/;
	    my $spaceIndex=$+[0];
	    #print "$ECIndex $spaceIndex\n";
	    push(@ECNumbers,substr($line,$ECIndex,$spaceIndex-$ECIndex));
	}
	else
	{
	    push(@names,$line);
	}
    }
}

#names and ECNumbers should be the same length
#print entries for each enzyme with name and ECNumber
for(my $i=0;$i<=$#ECNumbers;$i++)
{
    if($ECNumbers[$i] ne "")
    {
	print OUT "NAME\t$names[$i]\n";
	print OUT "FUNCTION\t$names[$i]\n";
	print OUT "PRODUCT-TYPE\tP\n";
	print OUT "EC\t$ECNumbers[$i]\n";
	print OUT "//\n";
    }
}
close(OUT);
close(ANNOTIN);
