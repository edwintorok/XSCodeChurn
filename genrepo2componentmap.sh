#!/bin/sh
#$1 working dir
#sync build.hg
pushd $1 1>&2
if [ -d build.hg/ ] 
then 
	pushd build.hg/
	hg pull
	popd
else
	hg clone http://hg.uk.xensource.com/carbon/trunk/build.hg
fi 1>&2
#parse the repos from b/config/*.mk files
tmpfile=`mktemp`
re="REPOS.*="
for i in build.hg/b/config/*.mk ;
do
	echo -n `basename $i .mk` >> $tmpfile
	egrep $re $i | sed "s/$re//" >> $tmpfile
done
#output a <component>,<repo> map
cat $tmpfile |  perl -ane '$comp=shift @F; map{print "$_,$comp\n"}@F;'
rm $tmpfile
