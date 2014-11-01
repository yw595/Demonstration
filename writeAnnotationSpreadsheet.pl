use strict;
use warnings;

open(RASTIN,"$ARGV[0]");
open(KAASIN,"$ARGV[1]");
open(BLAST2GOIN,"$ARGV[2]");
my %RASTECNumbers=();
my %KAASECNumbers=();
my %BLAST2GOECNumbers=();
my %commonECNumbers=();

my %RASTLocs=();
my %KAASLocs=();

my $linenumber=0;
my $currentLoc="";
while(<RASTIN>)
{
    $linenumber=$linenumber+1;
    my $line=$_;
    chomp($line);
    if(($linenumber % 2) ==0)
    {
	$currentLoc=$line;
    }
    else
    {
	my @words=split(/\s/,$line);
	if($line =~ /\s/)
	{
	    for(my $i=0;$i<=$#words;$i++)
	    {
		$RASTECNumbers{$words[$i]}="";
		$commonECNumbers{$words[$i]}="";
		$RASTLocs{$words[$i]}=$currentLoc;
	    }
	}
	else
	{
	    $RASTECNumbers{$line}="";
	    $commonECNumbers{$line}="";
	    $RASTLocs{$line}=$currentLoc;
	}
    }
}
$linenumber=0;
$currentLoc="";
while(<KAASIN>)
{
    $linenumber=$linenumber+1;
    my $line=$_;
    chomp($line);
    if(($linenumber % 2)==0)
    {
	$currentLoc=$line;
    }
    else
    {
	$KAASECNumbers{$line}="";
	$commonECNumbers{$line}="";
	$KAASLocs{$line}=$currentLoc;
    }
}
while(<BLAST2GOIN>)
{
    my $line=$_;
    chomp($line);
    if($line =~ /EC:/)
    {
	my $ECStartIndex=$+[0];
	$line =~ /(\d)+\.(\d)+\.(\d)+\.(\d)+/;
	my $ECEndIndex=$+[0];
	$BLAST2GOECNumbers{substr($line,$ECStartIndex,$ECEndIndex-$ECStartIndex)}="";
	$commonECNumbers{substr($line,$ECStartIndex,$ECEndIndex-$ECStartIndex)}="";
	#print substr($line,$ECStartIndex,$ECEndIndex-$ECStartIndex) . "\n";
    }
}
my %ECNumbersToEnzymeNames=();
for(my $i=1;$i<=6;$i++)
{
    my $EXPASYFile="EXPASY/EXPASY" . $i . ".txt";
    open(EXPASYIN,$EXPASYFile);
    print "$EXPASYFile\n";
    while(<EXPASYIN>)
    {
	my $line=$_;
	chomp($line);
	if($line =~ /(\d)+\.(\d)+\.(\d)+\.(\d)+/)
	{
	    $line =~ s/,//;
	    $line =~ /\d </;
	    my $endECNumberIndex=$-[0];
	    $line =~ />\s/;
	    my $startDescriptionIndex=$+[0];
	    $ECNumbersToEnzymeNames{substr($line,0,$endECNumberIndex+1)}=substr($line,$startDescriptionIndex+2);
	}
    }
    close(EXPASYIN);
}

open(CSVOUT,">$ARGV[3]");
open(TXTOUT,">$ARGV[4]");
my $RASTAddedNumbers=0;
my $KAASAddedNumbers=0;
my $BLAST2GOAddedNumbers=0;
my %addedLocs=();
for my $ECNumber (sort(keys %commonECNumbers))
{
    print CSVOUT "$ECNumber";
    print TXTOUT "$ECNumber\n";
    my $added=0;
    my @locationWords=();
    if (exists $RASTECNumbers{$ECNumber})
    {
	if($added==0)
	{
	    $RASTAddedNumbers=$RASTAddedNumbers+1;
	    if(exists $addedLocs{$ECNumber})
	    {
		print "Overlapping: $ECNumber\n";
	    }
	    else
	    {
		#print "$RASTLocs{$ECNumber}\n";
		@locationWords=split(/\s/,$RASTLocs{$ECNumber});
		$addedLocs{$ECNumber}=$RASTLocs{$ECNumber};
	    }
	}
	print CSVOUT ",1";
	$added=1;
    }
    else
    {
	print CSVOUT ",0";
    }
    if (exists $KAASECNumbers{$ECNumber})
    {
	if($added==0)
	{
	    $KAASAddedNumbers=$KAASAddedNumbers+1;
	    if(exists $addedLocs{$ECNumber})
	    {
		print "Overlapping: $ECNumber\n";
	    }
	    else
	    {
		#print "$RASTLocs{$ECNumber}\n";
		@locationWords=split(/\s/,$KAASLocs{$ECNumber});
		$addedLocs{$ECNumber}=$KAASLocs{$ECNumber};
	    }
	}
	print CSVOUT ",1";
	$added=1;
    }
    else
    {
	print CSVOUT ",0";
    }
    if (exists $BLAST2GOECNumbers{$ECNumber})
    {
	if($added==0)
	{
	    $BLAST2GOAddedNumbers=$BLAST2GOAddedNumbers+1;
	}
	print CSVOUT ",1";
	$added=1;
    }
    else
    {
	print CSVOUT ",0";
    }
    if (exists $ECNumbersToEnzymeNames{$ECNumber})
    {
	print CSVOUT ",$ECNumbersToEnzymeNames{$ECNumber}";
	#print ",$ECNumbersToEnzymeNames{$ECNumber}\n";
    }
    else
    {
	print CSVOUT ",";
    }
    if($#locationWords<1)
    {
	print CSVOUT ",,,\n";
    }
    else
    {
	print CSVOUT ",$locationWords[0],$locationWords[1],$locationWords[2]\n";
    }
}
print "RASTAddedNumbers: $RASTAddedNumbers\n";
print "KAASAddedNumbers: $KAASAddedNumbers\n";
print "BLAST2GOAddedNumbers: $BLAST2GOAddedNumbers\n";
