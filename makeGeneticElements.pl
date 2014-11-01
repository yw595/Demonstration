use strict;
use warnings;

my $inputDir=$ARGV[0];
my $species=$ARGV[1];
open(OUT,">$ARGV[2]");
opendir(DIR,$inputDir);
my @inputFiles=readdir(DIR);
my $contignum=0;
for(my $i=0;$i<$#inputFiles;$i++)
{
    if($inputFiles[$i] ne ".." && $inputFiles[$i] ne "." && $inputFiles[$i]=~/(.*).fa/)
    {
	if($inputFiles[$i] ne "noContig.fa")
	{
	    $contignum=$contignum+1;
	    $inputFiles[$i]=~/(.*).fa/;
	    #print $inputFiles[$i] . "\n";
	    my $contigName=$1;
	    $inputFiles[$i]=~/NODE_(\d+)_/;
	    my $contigNumber=$1;
	    print OUT "ID\t$contigName\n";
	    print OUT "NAME\t$species contig $contigNumber\n";
	    print OUT "TYPE\t:CONTIG\n";
	    print OUT "ANNOT-FILE\t$contigName.pf\n";
	    print OUT "SEQ-FILE\t$inputFiles[$i]\n";
	    print OUT "//\n";
	}
	else
	{
	    $inputFiles[$i]=~/(.*).fa/;
	    my $contigName=$1;
	    print OUT "ID\tnoContig\n";
	    print OUT "NAME\t$species $contigName\n";
	    print OUT "TYPE\t:CONTIG\n";
	    print OUT "ANNOT-FILE\t$contigName.pf\n";
	    print OUT "SEQ-FILE\t$inputFiles[$i]\n";
	    print OUT "//\n";
	}
    }
}

