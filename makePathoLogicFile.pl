use strict;
use warnings;

open(ANNOTIN1,"$ARGV[0]");
open(ANNOTIN2,"$ARGV[1]");
my $outputDir=$ARGV[2];
my %ECNumbers1=();
my %contigs=();
open(OUT,">$outputDir/noContig.pf");
while(<ANNOTIN1>)
{
    my $line=$_;
    chomp($line);
	#for normal AnnotationSpreadsheet, grab eight different fields separated by commas. 
	#([^,]*) means 0 or more characters that are not commas.
    if($line=~/^([^,]*),([^,]*),([^,]*),([^,]*),(.*),([^,]*),([^,]*),([^,]*)$/)
    {
	$ECNumbers1{$1}="";
	my $hasContig=1;
	#if no contig number in sixth field, output to noContig.pf
	#else, check if corresponding .pf file is already created
	#if not, create the new file, otherwise just append to existing file
	if($6 eq "")
	{
	    open(OUT,">>$outputDir/noContig.pf");
	    $hasContig=0;
	}
	elsif(!(exists $contigs{$6}))
	{
	    $contigs{$6}="";
	    open(OUT,">$outputDir/$6.pf");
	}
	else
	{
	    open(OUT,">>$outputDir/$6.pf");
	}
	my $ECNumber=$1;
	my $name=$5;
	my $id="$6_$7_$8";
	if($hasContig==1)
	{
	    print OUT "ID\t$id\n";
	}

	#if there is no name in the fifth field, use the EC number as the name
	if($name eq "")
	{
	    print OUT "NAME\t$ECNumber\n";
	}
	else
	{
	    print OUT "NAME\t$name\n";
	}
	if($hasContig==1)
	{
	    print OUT "STARTBASE\t$7\n";
	    print OUT "ENDBASE\t$8\n";
	}
	print OUT "FUNCTION\t$name\n";
	print OUT "PRODUCT-TYPE\tP\n";
	print OUT "EC\t$ECNumber\n";
	print OUT "//\n";
	close(OUT);
    }
}
open(OUT,">>$outputDir/noContig.pf");
while(<ANNOTIN2>)
{
    my $line=$_;
    chomp($line);
	#for AnnotationSpreadsheetWenbin, grab just two comma-delimited fields
    if($line=~/([^,]*),([^,]*)/)
    {
	if(!(exists $ECNumbers1{$1}))
	{
	    my $ECNumber=$1;
	    my $name=$2;
		#similar to above, if no name in second field, use EC number instead
	    if($name eq "")
	    {
		print OUT "NAME\t$ECNumber\n";
	    }
	    else
	    {
		print OUT "NAME\t$name\n";
	    }
	    print OUT "FUNCTION\t$name\n";
	    print OUT "PRODUCT-TYPE\tP\n";
	    print OUT "EC\t$ECNumber\n";
	    print OUT "//\n";
	}
    }
}
close(OUT);
opendir(DIR,$outputDir);
my @files=readdir(DIR);

#if there are some contig .fa files without any annotations, make empty dummy .pf files for them
for(my $i=0;$i<$#files;$i++)
{
    if($files[$i]=~/(.*).fa/ && $files[$i] ne "noContig.fa" && !(exists $contigs{$1}))
    {
	open(OUT,">$outputDir/$1.pf");
	close(OUT);
    }
}
