#!/bin/sh
#generate map files,repos
#$1: local dir
#stdin: list of repos
while read LINE 
do  
#skip comments
	echo $LINE | grep -q '^#' && continue
#process line 
	repo=`echo $LINE | cut -d, -f3`
	dir=$1/$repo
	find $dir -not -path '*/\.git*' -type f -printf "$repo,%P\n"
done 
exit 0
