#!/bin/sh
#invoke git log on a set of repo
#$1: remote
#$2: local dir
#stdin: list of repos
rm -f $2/filechurn.git.log $2/commit.git.log $2/filechurn.git.csv $2/commit.git.csv
while read LINE 
do  
#skip comments
	echo $LINE | grep '^#' && continue
#process line 
	echo "Processing $LINE..."
	repo=`echo $LINE | cut -d, -f1`
	remote=$1/$repo
	dir=$2/$repo
#invoke git log
	pushd $dir
	git log --encoding=UTF-8 --numstat --no-merges --pretty=format:"%H,$repo" >> $2/filechurn.git.log
	git log --encoding=UTF-8 --no-merges --date=short --pretty=format:"%H,$repo,%an,%ad,%s" >> $2/commit.git.log
	popd
done 
#translate to .csv
	cat $2/filechurn.git.log | ./filechurn.gitlog2csv.pl > $2/filechurn.git.csv  
	cat $2/commit.git.log | ./commit.gitlog2csv.pl > $2/commit.git.csv
exit 0

