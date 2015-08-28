#!/bin/bash
set -v #echo on
grep ',' filechurn.git.log | cut -d, -f1 | wc -l
cat 	 filechurn.git.csv | cut -d, -f1 | wc -l
grep ',' filechurn.git.log | cut -d, -f1 | sort | uniq | wc -l
cat 	 filechurn.git.csv | cut -d, -f1 | sort | uniq | wc -l

grep ',' commit.git.log | cut -d, -f1 | wc -l
cat 	 commit.git.csv | cut -d, -f1 | wc -l
grep ',' commit.git.log | cut -d, -f1 | sort | uniq | wc -l
cat 	 commit.git.csv | cut -d, -f1 | sort | uniq | wc -l
