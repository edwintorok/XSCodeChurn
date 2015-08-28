#!/usr/bin/perl
my $repo= "$ARGV[$0]";
my $uuid;
while(<>){
#skip blank lines
	/^\s*$/ and next;
#strip non ascii chars
	s/[[:^ascii:]]//g;
#strip chars, which psql misinterpret
	s/["']//g;
#record uuid and repo
	if(/^([[:xdigit:]]{40}),(.*?)$/) 
		{$uuid=$1;$repo=$2;next;}
#any non-uuid, preprend uuid, add commas
	my ($plus,$minus,$filename)=split(' ');
#fixup any git special format
	$plus =~ /[^0-9]/  and $plus=0;
	$minus =~ /[^0-9]/ and $minus=0;
	print "$uuid,$repo,$plus,$minus,",$plus+$minus,",$filename\n";
}
exit 0;
