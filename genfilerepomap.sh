#!/bin/sh
#generate map files,repos
#$1: specs dir
#stdin: list of repos
while read LINE 
do  
#skip comments
	echo $LINE | grep -q '^#' && continue
#process line 
	repo=`echo $LINE | cut -d, -f2`
	dir=$1/repos/$repo/
	find $dir -not -path '*/\.git*' -type f -printf "$repo,%P\n"
done 
exit 0
