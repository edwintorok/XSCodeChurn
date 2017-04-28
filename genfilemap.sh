#!/bin/bash
#generate map repo,file,extension,loc
#$1: specs dir
#stdin: map file,repo
while read LINE 
do  
#skip comments
	echo $LINE | grep -q '^#' && continue
#process line 
	repo=`echo $LINE | cut -d, -f1`
	filename=`echo $LINE | cut -d, -f2`
#extract file extension
	barename=$(basename "$filename")
	extension="${barename##*.}"
	[ "$extension" == "$barename" ] && extension='NIL'
#find loc
#	loc=`cat "$1/$repo/$filename"|wc -l`
	loc=`cloc --csv  "$1/repos/$repo/$filename"| tail -n1 | cut -d, -f5`
	echo $loc | grep -q 'ignored' && loc=0
#output result
	echo "$repo,$filename,$extension,$loc"
done 
exit 0
