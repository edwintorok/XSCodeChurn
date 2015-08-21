#!/bin/sh
#import csv files into postgreSQL tables
#$1: local dir
#$2: host
#$3: dbname
#$4: username
#stdin: list of repos
commitrawcsv=$1/commit.git.raw.csv
commitcsv=$1/commit.git.csv # sorted and uniq'd
filechurnrawcsv=$1/filechurn.git.raw.csv
filechurncsv=$1/filechurn.git.csv # sorted and uniq'd
rm -f $commitrawcsv $commitcsv $filechurnrawcsv $filechurncsv
while read LINE 
do  
#skip comments
	echo $LINE | grep '^#' && continue
#process line 
	echo "Processing $LINE..."
	repo=`echo $LINE | cut -d, -f1`
	cat "$1/commit.$repo.csv" >> $commitrawcsv
	cat "$1/filechurn.$repo.csv" >> $filechurnrawcsv
done 
sort $commitrawcsv | uniq > $commitcsv
sort $filechurnrawcsv | uniq > $filechurncsv
psql --host=$2 --dbname=$3 --username=$4 -c "\copy commit from $commitcsv WITH CSV;" 
psql --host=$2 --dbname=$3 --username=$4 -c "\copy filechurn from $filechurncsv WITH CSV;" 
exit 0
