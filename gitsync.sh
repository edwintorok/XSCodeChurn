#!/bin/sh
#Sync a git repo, either by clone or pull
#$1: local dir
#stdin: list of repos
while read LINE 
do  
#skip comments
	echo $LINE | grep '^#' && continue
#process line 
	remote=`echo $LINE | cut -d, -f1`
	repo=`echo $LINE | cut -d, -f2`
	dir=$1/$repo
	if [ -e $dir ]
	then
		pushd $dir
		git pull origin	
		popd
	else
		git clone $remote/$repo $dir
	fi
done 
exit 0

