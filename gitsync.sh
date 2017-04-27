#!/bin/bash
#Sync a git repo, either by clone or pull
#$1: local dir
#stdin: list of repos
while read LINE 
do  
#skip comments
	echo $LINE | grep '^#' && continue
#process line 
pkg=`echo $LINE | cut -d, -f1`
pushd $1
echo  "processing $pkg"
planex-buildenv run --no-tty generic -- planex-pin $pkg
# clone the package repositories in the repos/ folder
planex-buildenv run --no-tty generic -- planex-clone PINS/$pkg.pin
popd
done
exit 0
