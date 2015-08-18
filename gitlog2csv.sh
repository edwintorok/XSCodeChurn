#!/bin/sh
git log  --no-merges --date=short --pretty=format:'%H,%an,%ad,%s' > commitlog.csv
git log  --numstat --no-merges --pretty=format:'%H' > filelog.csv

