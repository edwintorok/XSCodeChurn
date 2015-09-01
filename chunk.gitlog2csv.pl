#!/usr/bin/perl
my $uuid,$repo,$filename;
while(<>){
#skip blank lines
	/^\s*$/ and next;
#strip non ascii chars
	s/[[:^ascii:]]//g;
#strip chars, which psql misinterpret
	s/["']//g;
#record uuid and repo
	if(/^repo,(.*?),uuid,(.*?)$/) 
		{$repo=$1,$uuid=$2;next;}
#record filename diff
	if(/^diff --git a\/(.*?) b\/(.*?)$/) 
		{$1 != $2 and die "unexpected format at>$_\n"; 
		$filename=$1;
		next;}
#find chunk and print it
	if(/^@@.*?@@ (.*?)$/)
		{print "$uuid,$repo,$filename,\"$1\"\n";next}
#skip all other lines
}
exit 0;
