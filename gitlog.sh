#!/bin/sh
#invoke git log on a set of repo
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
#invoke git log
	git -C $dir log  --numstat --no-merges --pretty=format:'%H' > $2/filechurn.$repo.log
	git -C $dir log  --no-merges --date=short --pretty=format:'%H,%an,%ad,%s' > $2/commit.$repo.log
#translate to .csv
	./filechurn.gitlog2csv.pl $2/filechurn.$repo.log > $2/filechurn.$repo.csv  
	./commit.gitlog2csv.pl $repo $2/commit.$repo.log > $2/commit.$repo.csv
done 
exit 0

