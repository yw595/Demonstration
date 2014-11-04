use strict;
use warnings;

my $inputDir=$ARGV[0];
my $species=$ARGV[1];
open(OUT,">$ARGV[2]");

#get list of all files in inputDir
opendir(DIR,$inputDir);
my @inputFiles=readdir(DIR);
for(my $i=0;$i<$#inputFiles;$i++)
{
	#check that input files are only .fa files
    if($inputFiles[$i] ne ".." && $inputFiles[$i] ne "." && $inputFiles[$i]=~/(.*).fa/)
    {
	#for normal contig files, pick contigName as the name of input file, contigNumber as a substring of that
	#for noContig.fa, contigName is "noContig"
	if($inputFiles[$i] ne "noContig.fa")
	{
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

