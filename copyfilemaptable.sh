#!/bin/sh
#import csv files into postgreSQL tables
#$1: local dir
#$2: host
#$3: dbname
#$4: username
psql --host=$2 --dbname=$3 --username=$4 -c "\copy filemap from $1/filemap.csv WITH CSV;" 
exit 0
