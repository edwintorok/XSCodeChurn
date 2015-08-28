#!/bin/sh
#invoke git log on a set of repo
#$1: local dir
#stdin: list of repos
commitlog=$1/commit.git.log
commitcsv=$1/commit.git.csv
filechurnlog=$1/filechurn.git.log
filechurncsv=$1/filechurn.git.csv
rm -f $commitlog $commitcsv $filechurnlog $filelchurncsv
while read LINE 
do  
#skip comments
	echo $LINE | grep '^#' && continue
#process line 
	echo "Processing $LINE..."
	repo=`echo $LINE | cut -d, -f2`
	dir=$1/$repo
#invoke git log
	pushd $dir
	git log --encoding=UTF-8 --numstat --no-merges --pretty=format:"%H,$repo" >> $filechurnlog
	git log --encoding=UTF-8 --no-merges --date=short --pretty=format:"%H,$repo,%an,%ad,%s" >> $commitlog
	popd
done 
#translate to .csv
	cat $filechurnlog | ./filechurn.gitlog2csv.pl > $filechurncsv  
	cat $commitlog | ./commit.gitlog2csv.pl > $commitcsv
exit 0

