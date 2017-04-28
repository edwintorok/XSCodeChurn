#!/bin/bash
#invoke git log on a set of repo
#$1: working dir
#$2: specs dir
#stdin: list of repos
commitlog=$1/commit.git.log
commitcsv=$1/commit.git.csv
filechurnlog=$1/filechurn.git.log
filechurncsv=$1/filechurn.git.csv
chunklog=$1/chunk.git.log
chunkcsv=$1/chunk.git.csv
rm -f $commitlog $commitcsv $filechurnlog $filelchurncsv $chunklog $chunkcsv
while read LINE 
do  
#skip comments
	echo $LINE | grep '^#' && continue
#process line 
	repo=`echo $LINE | cut -d, -f2`
	echo "Processing $repo..."
	dir=$2/repos/$repo/
#invoke git log - generate tab delimited output
	pushd $dir
#ls $dir
	git log --encoding=UTF-8 --no-merges --date=short --pretty=format:"%H%x09$repo%x09%an%x09%ad%x09%s" >> $commitlog
	git log --encoding=UTF-8 --numstat --no-merges --pretty=format:"%H%x09$repo" >> $filechurnlog
	git log --encoding=UTF-8 -p --no-merges --pretty=format:"repo%x09$repo%x09uuid%x09%H" >> $chunklog
	popd
done 
#translate to .csv
	sort $commitlog | uniq | ./commit.gitlog2csv.pl > $commitcsv
	cat $filechurnlog | ./filechurn.gitlog2csv.pl > $filechurncsv  
	cat $chunklog | ./chunk.gitlog2csv.pl > $chunkcsv
exit 0

