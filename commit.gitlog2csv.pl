#!/usr/bin/perl
#in: git log file
#out:csv file
while(<>){
	chomp;
#skip blank lines
	/^\s*$/ and next;
#strip non ascii chars
	s/[[:^ascii:]]//g;
#strip single and double quotes, which psql misinterpret
	s/["']//g;
#extract jira object
	my ($uuid,$repo,$author,$date,$summary)=split(',');
	my ($jiratype,$jiraid)=('###',0);
	if($summary =~ /^.*?(CA|CP|XOP|SCTX|HFX|HFP|CAR)-([0-9]*).*?$/i){
		($jiratype,$jiraid)=(uc $1,$2);}
	my $tmp=substr $summary,0,80;
	print "$uuid,$repo,$author,$date,$jiratype,$jiraid,$tmp\n";
}
exit 0;
