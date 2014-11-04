use strict;
use warnings;

open(IN,"$ARGV[0]");
my $outputFolder=$ARGV[1];
my $currentContig="";

#create noContig.fa file, print stub header
open(OUT,">$outputFolder/noContig.fa");
print OUT ">noContig\n";

while(<IN>)
{
    my $line=$_;
    chomp($line);
	#for each new contig header encountered in input fasta file,
	#create new .fa file
    if($line=~/>(.*)/ && (substr($line,1) ne $currentContig))
    {
	$currentContig=substr($line,1);
	close(OUT);
	open(OUT,">$outputFolder/$currentContig.fa");
    }
    print OUT "$line\n";
}
