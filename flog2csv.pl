#!/usr/bin/perl
my $uuid;
while(<>){
#skip blank lines
	/^\s*$/ and next;
#record uuid
	/^([[:xdigit:]]{40})$/ and $uuid=$1 and next;
#any non-uuid, preprend uuid, add commas
	my ($plus,$minus,$filename)=split(' ');
	print "$uuid,$plus,$minus,",$plus+$minus,",$filename\n";
}
exit 0;
