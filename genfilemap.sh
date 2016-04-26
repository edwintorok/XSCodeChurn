#!/bin/bash
#generate map repo,file,extension,loc
#$1: local dir
#stdin: map file,repo
while read LINE 
do  
#skip comments
	echo $LINE | grep -q '^#' && continue
#process line 
	repo=`echo $LINE | cut -d, -f1`
	filename=`echo $LINE | cut -d, -f2`
#extract file extension
#TODO infer filetype from extension to compute loc more precisely
	barename=$(basename "$filename")
	extension="${barename##*.}"
	[ "$extension" == "$barename" ] && extension='NIL'
#find loc
	loc=`cat "$1/$repo/$filename"|wc -l`
#output result
	echo "$repo,$filename,$extension,$loc"
done 
exit 0
