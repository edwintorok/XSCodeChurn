#!/bin/sh
#$1 working dir
#sync build.hg
url=http://hg.uk.xensource.com/carbon/trunk
pushd $1 1>&2
if [ -d build.hg/ ] 
then 
	pushd build.hg/
	hg pull
	popd
else
	hg clone $url/build.hg
fi 1>&2
#parse the repos from b/config/*.mk files
tmpfile=`mktemp`
re="REPOS.*="
for i in build.hg/b/config/*.mk ;
do
	printf "%s %s " `basename $i .mk` $url >> $tmpfile
	egrep $re $i | sed "s/$re//" >> $tmpfile
done
#output a <component>,<url>,<repo> map
cat $tmpfile |  perl -ane '$comp=shift @F; $url=shift @F;map{print "$comp,$url,$_\n"}@F;'
rm $tmpfile
