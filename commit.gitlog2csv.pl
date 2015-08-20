#!/usr/bin/perl
#in: git log file
#out:csv file
#param0: name of git repo
#param1: path to log file
my $repo= "$ARGV[$0]";
open(my $fd, "<", $ARGV[1]) or die "Cannot open $ARGV[1]";
while(<$fd>){
	chomp;
#skip blank lines
	/^\s*$/ and next;
#any non-uuid, preprend uuid, add commas
	my ($uuid,$author,$date,$summary)=split(',');
	my ($jiratype,$jiraid)=('###','###');
#	$summary ~= /^.*?(CA|CP|XOP|SCTX)-(\d*?)/;
	if($summary =~ /^(CA|CP|XOP|SCTX|HFX|HFP|CAR)-([0-9]*)/){
		($jiratype,$jiraid)=($1,$2);}
	print "$uuid,$repo,$author,$date,$jiratype,$jiraid,$summary\n";
}
exit 0;
