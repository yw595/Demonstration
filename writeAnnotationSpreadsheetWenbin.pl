use strict;
use warnings;

open(ANNOTTABLEIN,"$ARGV[0]");
my %commonECNumbers=();
while(<ANNOTTABLEIN>)
{
    my $line=$_;
    chomp($line);
    my @words=split(/\s/,$line);
    if($line =~ /(\d)+\.(\d)+\.(\d)+\.(\d)+/)
    {
	my @ECNumbers=getECNumbers($line);
	#if($#ECNumbers != -1)
	#{
	#    print join("\t",@ECNumbers) . "\n";
	#}
	for(my $i=0;$i<=$#ECNumbers;$i++)
	{
	    #print "$ECNumbers[$i]\n";
	    $commonECNumbers{$ECNumbers[$i]}="";
	}
    }
}

my %ECNumbersToEnzymeNames=();
for(my $i=1;$i<=6;$i++)
{
    my $EXPASYFile="EXPASY/EXPASY" . $i . ".txt";
    open(EXPASYIN,$EXPASYFile);
    while(<EXPASYIN>)
    {
	my $line=$_;
	chomp($line);
	if($line =~ /(\d)+\.(\d)+\.(\d)+\.(\d)+/)
	{
	    $line =~ /\d </;
	    my $endECNumberIndex=$-[0];
	    $line =~ />\s/;
	    my $startDescriptionIndex=$+[0];
	    $ECNumbersToEnzymeNames{substr($line,0,$endECNumberIndex+1)}=substr($line,$startDescriptionIndex+2);
	}
    }
    close(EXPASYIN);
}

open(CSVOUT,">$ARGV[1]");
open(TXTOUT,">$ARGV[2]");
for my $ECNumber (sort(keys %commonECNumbers))
{
    print CSVOUT "$ECNumber";
    print TXTOUT "$ECNumber\n";
    if (exists $ECNumbersToEnzymeNames{$ECNumber})
    {
	print CSVOUT ",$ECNumbersToEnzymeNames{$ECNumber}\n";
    }
    else
    {
	print CSVOUT ",\n";
    }
}

sub getECNumbers
{
    my $description=$_[0];
    my @ECNumbers=();
    while($description =~ m/((\d|-)+\.(\d|-)+\.(\d|-)+\.(\d|-)+)/)
    {
	$description =~ /((\d|-)+\.(\d|-)+\.(\d|-)+\.(\d|-)+)/;
	$description=substr($description,$+[0]);
	push(@ECNumbers,$1);
	#print "$#ECNumbers\n";
    }
    return @ECNumbers;
}
