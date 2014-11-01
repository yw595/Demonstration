use strict;
use warnings;

open(ANNOTIN,"$ARGV[0]");
open(OUT,">$ARGV[1]");
my @ECNumbers=();
my @names=();
my $ECLines=0;
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
