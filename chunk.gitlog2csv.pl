#!/usr/bin/perl
my $uuid,$repo,$filename,$chunk;
while(<>){
	chomp;
#skip blank lines
	/^\s*$/ and next;
#strip non ascii chars
	s/[[:^ascii:]]//g;
#strip chars, which psql misinterpret
	s/["']//g;
#record uuid and repo
	if(/^repo\t(.*?)\tuuid\t([[:xdigit:]]{40})/) 
		{$repo=$1,$uuid=$2;next;}
#record filename diff
	if(/^diff --git a\/(.*?) b\/(.*?)$/) 
		{$filename=$1;next;}
#find chunk and print the first 80 chars
	if(/^@@.*?@@ (.*?)$/)
		{$chunk=substr($1,0,80);
		print "$uuid,$repo,$filename,\"$chunk\"\n";next}
#skip all other lines
}
exit 0;
