#!/bin/sh
#Sync a git repo, either by clone or pull
#$1: remote
#$2: local dir
#stdin: list of repos
while read LINE 
do  
#skip comments
	echo $LINE | grep '^#' && continue
#process line 
	repo=`echo $LINE | cut -d, -f1`
	remote=$1/$repo
	dir=$2/$repo
	if [ -e $dir ]
	then
		git -C $dir pull origin	
	else
		git clone $remote $dir
	fi
done 
exit 0

