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
#record uuid
	/^([[:xdigit:]]{40})$/ and $uuid=$1 and next;
#any non-uuid, preprend uuid, add commas
	my ($plus,$minus,$filename)=split(' ');
	print "$uuid,$plus,$minus,",$plus+$minus,",$filename\n";
}
exit 0;
