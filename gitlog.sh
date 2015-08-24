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
	echo "Processing $LINE..."
	repo=`echo $LINE | cut -d, -f1`
	remote=$1/$repo
	dir=$2/$repo
#invoke git log
	pushd $dir
	git log --encoding=UTF-8 --numstat --no-merges --pretty=format:'%H' > $2/filechurn.$repo.log
	git log --encoding=UTF-8 --no-merges --date=short --pretty=format:'%H,%an,%ad,%s' > $2/commit.$repo.log
	popd
#translate to .csv
	./filechurn.gitlog2csv.pl $2/filechurn.$repo.log > $2/filechurn.$repo.csv  
	./commit.gitlog2csv.pl $repo $2/commit.$repo.log > $2/commit.$repo.csv
done 
exit 0

