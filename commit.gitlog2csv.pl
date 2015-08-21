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
#strip non ascii chars
	s/[[:^ascii:]]//g;
#strip chars, which psql misinterpret
	s/["']//g;
#any non-uuid, preprend uuid, add commas
	my ($uuid,$author,$date,$summary)=split(',');
	my ($jiratype,$jiraid)=('###',0);
	if($summary =~ /^.*?(CA|CP|XOP|SCTX|HFX|HFP|CAR)-([0-9]*).*?$/i){
		($jiratype,$jiraid)=($1,uc $2);}
	my $tmp=substr $summary,0,80;
	print "$uuid,$author,$date,$jiratype,$jiraid,$tmp\n";
}
exit 0;
